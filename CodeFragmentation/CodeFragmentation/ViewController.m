//
//  ViewController.m
//  CodeFragmentation
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//

#import "ViewController.h"
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
    
    [self setUI];
    
    // Do any additional setup after loading the view.
}

- (void)setUI{
    UIButton *btn_getmusic = [[UIButton alloc]init];
    
    btn_getmusic.backgroundColor = [UIColor colorWithRed:95 / 255.0 green:138 / 255.0 blue:136 / 255.0 alpha:1.0];
    btn_getmusic.titleLabel.font = [UIFont fontWithName:@"PingFang-SC" size:17];
    [btn_getmusic setTitle:@"测试" forState:UIControlStateNormal];
    btn_getmusic.layer.cornerRadius = 5;
    btn_getmusic.layer.shadowOffset = CGSizeMake(1, 1);
    btn_getmusic.layer.shadowOpacity = 0.1;
    btn_getmusic.layer.shadowColor = [[UIColor blackColor] CGColor];
    [btn_getmusic addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_getmusic];
    
    [btn_getmusic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(79);
        make.width.offset(345);
        make.height.offset(80);
    }];
}

- (void)btnClick{
    [self rsaEncryptAndDecrypt];
}

- (void)rsaEncryptAndDecrypt{
    NSString * str = [KIRSA encryptString:@"I am a Chinese"];
       
    NSLog(@"加密后:%@",str);
    NSLog(@"%@ 解密后:%@",str,[KIRSA decryptString:str]);
}

@end
