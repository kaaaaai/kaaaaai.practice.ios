//
//  ViewController.m
//  XWMP3ToWAV
//
//  Created by 邱学伟 on 2017/3/13.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWMP3ToPCM.h"
#import <sbc.h>
#import <stdlib.h>
#import <stdbool.h>
#include <stdint.h>
#include <errno.h>
#import <Foundation/Foundation.h>

#define MSBC_FRAME_SIZE 57
#define SBC_MAX_SAMPLES_PER_FRAME 240
#define MSBC_SYNCWORD 0xAD

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self testMP3ToPCM];
    
    NSLog(@"viewDidLoad");
}

- (void)testMP3ToPCM {
    //    __weak typeof (self) weakSelf = self;
    NSString *mp3FilePath = [[NSBundle mainBundle] pathForResource:@"降噪测试.mp3" ofType:nil];
    NSString *pcmFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    pcmFilePath = [pcmFilePath stringByAppendingPathComponent:@"降噪测试.pcm"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [XWMP3ToPCM mp3ToPcmWithMp3FilePath:mp3FilePath pcmFilePath:pcmFilePath complete:^{
            
        }];
    });
}

- (IBAction)decodeDidTap:(id)sender {
//    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *sbcFilePath = [documentPath stringByAppendingPathComponent:@"taiwan_2.msbc"];
//        NSString *sbcFilePath = [[NSBundle mainBundle] pathForResource:@"audio.msbc" ofType:nil];
    NSString *sbcFilePath = [[NSBundle mainBundle] pathForResource:@"taiwan_2.msbc" ofType:nil];
    
    NSString *pcmFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    pcmFilePath = [pcmFilePath stringByAppendingPathComponent:@"decode_audio_3.pcm"];
    
    BOOL success = [self decodeMSBCFile:sbcFilePath toPCMFile:pcmFilePath];
    if (success) {
        NSLog(@"文件解码成功，输出路径: %@", pcmFilePath);
        
        NSUInteger fileSize = [self fileSizeAtPath:pcmFilePath];
        NSLog(@"解码后文件长度: %lu bytes", (unsigned long)fileSize);
    } else {
        NSLog(@"文件解码失败");
    }
}

- (NSUInteger)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    return [attributes fileSize];
}

- (BOOL)decodeMSBCFile:(NSString *)inputFilePath toPCMFile:(NSString *)outputFilePath {
    FILE *inputFile = fopen([inputFilePath UTF8String], "rb");
    if (!inputFile) {
        NSLog(@"无法打开输入文件 %@", inputFilePath);
        return NO;
    }
    
    FILE *outputFile = fopen([outputFilePath UTF8String], "wb");
    if (!outputFile) {
        NSLog(@"无法打开输出文件 %@", outputFilePath);
        fclose(inputFile);
        return NO;
    }
    
    sbc_t sbc;
    if (sbc_init_msbc(&sbc, 0) != 0) {
        NSLog(@"无法初始化 SBC 解码器");
        fclose(inputFile);
        fclose(outputFile);
        return NO;
    }
    
    sbc.endian = SBC_LE;
    uint8_t msbcBuffer[57]; // MSBC 帧大小为 57 字节
    size_t pcmBufferSize = 240; // 每帧解码后的 PCM 数据大小为 240 字节
    //        size_t pcmBufferSize = 1920; // 每帧解码后的 PCM 数据大小为 240 字节
    
    uint16_t pcmBuffer[pcmBufferSize / 2]; // 240 字节的 PCM 数据为 120 个 int16_t 样本
    size_t outputSize = 0;
    
    while (fread(msbcBuffer, 1, 57, inputFile) == 57) {
        if (![self isValidMSBCFrame:msbcBuffer]) {
            NSLog(@"MSBC 不合法");
        }
        
        ssize_t decoded = sbc_decode(&sbc, msbcBuffer, 57, (uint8_t *)pcmBuffer, pcmBufferSize, &outputSize);
        if (decoded < 0) {
            NSLog(@"MSBC decoding failed: %zd", decoded);
            sbc_finish(&sbc);
            fclose(inputFile);
            fclose(outputFile);
            return NO;
        }
        
        fwrite(pcmBuffer, sizeof(int16_t), outputSize / sizeof(int16_t), outputFile); // 这里写入的是 int16_t 数据
    }
    
    sbc_finish(&sbc);
    fclose(inputFile);
    fclose(outputFile);
    
    return YES;
}
- (IBAction)decodemSbcAudio1:(id)sender {
    NSString *sbcFilePath = [[NSBundle mainBundle] pathForResource:@"voice.msbc" ofType:nil];
    
    NSString *pcmFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    pcmFilePath = [pcmFilePath stringByAppendingPathComponent:@"voice_0611.pcm"];
    
    BOOL success = [self decodeMSBCFile:sbcFilePath toPCMFile:pcmFilePath];
    if (success) {
        NSLog(@"文件解码成功，输出路径: %@", pcmFilePath);
        
        NSUInteger fileSize = [self fileSizeAtPath:pcmFilePath];
        NSLog(@"解码后文件长度: %lu bytes", (unsigned long)fileSize);
    } else {
        NSLog(@"文件解码失败");
    }
    
}

- (IBAction)decodemSbcAudio2:(id)sender {
    NSString *sbcFilePath = [[NSBundle mainBundle] pathForResource:@"audio2.msbc" ofType:nil];
    
    NSString *pcmFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    pcmFilePath = [pcmFilePath stringByAppendingPathComponent:@"audio2_decode.pcm"];
    
    BOOL success = [self decodeMSBCFile:sbcFilePath toPCMFile:pcmFilePath];
    if (success) {
        NSLog(@"文件解码成功，输出路径: %@", pcmFilePath);
        
        NSUInteger fileSize = [self fileSizeAtPath:pcmFilePath];
        NSLog(@"解码后文件长度: %lu bytes", (unsigned long)fileSize);
    } else {
        NSLog(@"文件解码失败");
    }
}

- (IBAction)encodeMSBCFile:(id)sender {
    NSString *originFilePath = [[NSBundle mainBundle] pathForResource:@"taiwan.pcm" ofType:nil];
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *outputPath = [documentPath stringByAppendingPathComponent:@"taiwan_2.msbc"];
    
    const char *input_pcm_file = [originFilePath UTF8String];
    const char *output_msbc_file = [outputPath UTF8String];
    
    // 打开输入 PCM 文件
    FILE *pcm_file = fopen(input_pcm_file, "rb");
    if (!pcm_file) {
        perror("Failed to open PCM file");
        return;
    }
    
    // 打开输出 MSBC 文件
    FILE *msbc_file = fopen(output_msbc_file, "wb");
    if (!msbc_file) {
        perror("Failed to open MSBC file");
        fclose(pcm_file);
        return;
    }
    
    int16_t *pcm_data = NULL;
    size_t pcm_data_size = 0;
    uint8_t *msbc_data = NULL;
    size_t msbc_data_size = 0;
    
    // 读取 PCM 文件
    if (read_pcm_file(input_pcm_file, &pcm_data, &pcm_data_size) != 0) {
        return;
    }
    
    // 编码 PCM 数据为 MSBC
    if (encode_msbc(pcm_data, pcm_data_size, &msbc_data, &msbc_data_size) != 0) {
        free(pcm_data);
        return;
    }
    
    // 确保编码后的 MSBC 数据非空
    if (msbc_data_size == 0) {
        fprintf(stderr, "Encoded MSBC data size is 0\n");
        free(pcm_data);
        free(msbc_data);
        return;
    }
    
    // 将 MSBC 数据写入文件
    if (write_msbc_file(output_msbc_file, msbc_data, msbc_data_size) != 0) {
        free(pcm_data);
        free(msbc_data);
        fprintf(stderr, "MSBC 数据写入文件 失败");
        
        return;
    }
    
    printf("MSBC encoding successful, encoded size: %zu bytes\n", msbc_data_size);
    
    // 释放内存
    free(pcm_data);
    free(msbc_data);
}


// 读取 PCM 文件数据
int read_pcm_file(const char *filename, int16_t **pcm_data, size_t *pcm_data_size) {
    FILE *file = fopen(filename, "rb");
    if (!file) {
        perror("Failed to open PCM file");
        return -1;
    }
    
    // 获取文件大小
    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    fseek(file, 0, SEEK_SET);
    
    // 分配内存并读取数据
    *pcm_data = (int16_t *)malloc(file_size);
    if (!*pcm_data) {
        perror("Failed to allocate memory for PCM data");
        fclose(file);
        return -1;
    }
    
    size_t read_size = fread(*pcm_data, 1, file_size, file);
    fclose(file);
    
    if (read_size != file_size) {
        perror("Failed to read PCM data");
        free(*pcm_data);
        return -1;
    }
    
//    *pcm_data_size = file_size / sizeof(int16_t); // 返回样本数
    *pcm_data_size = file_size; // 返回文件实际长度
    printf("PCM 数据大小: %zu\n", *pcm_data_size);
    return 0;
}

// 将 MSBC 数据写入文件
int write_msbc_file(const char *filename, uint8_t *msbc_data, size_t msbc_data_size) {
    FILE *file = fopen(filename, "wb");
    if (!file) {
        perror("Failed to open MSBC file");
        return -1;
    }
    
    printf("写入前检查：%zu\n", msbc_data_size);
    
    size_t write_size = fwrite(msbc_data, 1, msbc_data_size, file);
    fclose(file);
    
    printf("write_msbc_file 文件大小：%zu\n", write_size);
    
    if (write_size != msbc_data_size) {
        perror("Failed to write MSBC data");
        return -1;
    }
    
    return 0;
}

// 编码 PCM 数据为 MSBC
int encode_msbc(const int16_t *pcm_data, size_t pcm_data_size, uint8_t **msbc_data, size_t *msbc_data_size) {
    sbc_t sbc;
    int result = sbc_init_msbc(&sbc, 0); // 初始化 MSBC 编码器
    if (result < 0) {
        fprintf(stderr, "Failed to initialize MSBC encoder\n");
        return -1;
    }
    
    size_t frame_length = 240; // 16kHz, 16bit, Mono, 每帧 240 字节的 PCM 数据
    size_t msbc_frame_length = 57; // 每帧 mSBC 数据长度为 57 字节
    size_t max_output_size = (pcm_data_size * sizeof(int16_t) / msbc_frame_length) * frame_length; // 计算最大输出大小
    
    *msbc_data = (uint8_t *)malloc(max_output_size);
    if (!*msbc_data) {
        fprintf(stderr, "Failed to allocate memory for MSBC data\n");
        sbc_finish(&sbc);
        return -1;
    }
    
    size_t input_offset = 0;
    size_t output_offset = 0;
    
    while (input_offset + frame_length <= pcm_data_size) {
        ssize_t written = 0;
        ssize_t encoded = sbc_encode(&sbc, (const uint8_t *)(pcm_data + input_offset / sizeof(int16_t)), frame_length, *msbc_data + output_offset, msbc_frame_length, &written);
        
        if (encoded < 0) {
            fprintf(stderr, "MSBC encoding failed at offset %zu\n", input_offset);
            free(*msbc_data);
            sbc_finish(&sbc);
            return -1;
        }
        
        input_offset += frame_length;
        output_offset += written;
        
//        printf("当前读取包长度: %zu\n", frame_length);
        printf("当前读取偏移: %zu\n", input_offset);
        printf("当前写入偏移: %zu\n", output_offset);
//        printf("成功编码的结果长度: %zu\n", encoded);
    }
    
    *msbc_data_size = output_offset;
    printf("编码后数据的实际大小: %zu\n", *msbc_data_size);
    
    sbc_finish(&sbc);
    return 0;
}

- (BOOL)isValidMSBCFrame:(uint8_t *)frame {
    // 检查帧头是否为合法的msbc帧
    return frame[0] == MSBC_SYNCWORD;
}

@end
