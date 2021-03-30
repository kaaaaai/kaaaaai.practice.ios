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

@end
