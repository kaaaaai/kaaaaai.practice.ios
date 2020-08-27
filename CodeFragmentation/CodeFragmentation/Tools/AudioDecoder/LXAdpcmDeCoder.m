//
//  LXAdpcmDeCoder.m
//  CGABluetoothDemo
//
//  Created by Kai Lv on 2020/8/11.
//  Copyright © 2020 yhl. All rights reserved.
//

#import "LXAdpcmDeCoder.h"
#import "asc_decoder.h"
#import "adpcm.h"

@interface LXAdpcmDeCoder(){
    struct adpcm_state ADPCMstate;
}
@end

@implementation LXAdpcmDeCoder

+ (instancetype)shared {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone: NULL] init];
    });
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [[self class] shared];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareDecoder{
    
    ADPCMstate.index = 0;
    ADPCMstate.valprev = 0;
}

- (NSData *)decode:(NSData *)adpcm{
    Byte* buf = (Byte*)malloc(230);
    NSRange range;
    range.location = 8;
    range.length = 230;
    [adpcm getBytes:buf range:range];
    NSData* data = [NSData dataWithBytes:buf length:230];
    
    unsigned char *inbuf = (unsigned char *)[data bytes];
    
    short outbuf[230*4] = {0};
   
    adpcm_decoder((char*)inbuf, outbuf, 230*2, &ADPCMstate);
    
    NSData *outData = [[NSData alloc]initWithBytes:outbuf length:230 * 4 ];

    return outData;
}


@end
