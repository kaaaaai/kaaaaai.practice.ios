//
//  ViewController.m
//  CodeFragmentation
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//

#import "ViewController.h"
#import "CodeFragmentation-Swift.h"
#import <Masonry/Masonry.h>

#import "KIRSA.h"

@interface ViewController ()<NSURLSessionDelegate>{
    NSMutableData *mData;
    NSURLConnection *connentGet;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testMethod];
    // Do any additional setup after loading the view.
}

- (void)rsaEncryptAndDecrypt{
    NSString * str = [KIRSA encryptString:@"I am a Chinese"];
       
    NSLog(@"加密后:%@",str);
    NSLog(@"%@ 解密后:%@",str,[KIRSA decryptString:str]);
}

- (void)testMethod{
    [[KKLabTool sharedLabTool] takeOutSameItem];
}

#pragma mark - 弹出框
- (IBAction)successBtnClicked:(id)sender {
    [KKHeadMessageView showMessageView:@"😊这是一个测试的弹窗" style:MessageStyleSuccess];
}

- (IBAction)warningBtnClicked:(id)sender {
    [KKHeadMessageView showMessageView:@"😊这是一个测试的弹窗" style:MessageStyleWarning];
}

- (IBAction)errorBtnClicked:(id)sender {
    [KKHeadMessageView showMessageView:@"😊这是一个测试的弹窗" style:MessageStyleError];
}

- (IBAction)noneBtnClicked:(id)sender {
    [KKHeadMessageView showMessageView:@"😊这是一个测试的弹窗" style:MessageStyleNone];
}

- (IBAction)mvpBtnClicked:(id)sender {
    KKPersonViewController *kkpvc = [[KKPersonViewController alloc]init];
    [self presentViewController:kkpvc animated:true completion:nil];
}

- (IBAction)mvvmBtnClicked:(id)sender {
}

- (IBAction)viperBtnClicked:(id)sender {
    
    
}

@end
