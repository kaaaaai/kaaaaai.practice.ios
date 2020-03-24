//
//  ViewController.m
//  CodeFragmentation
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "Calculator.h"
#import "NSObject+Calculator.h"

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

- (void)CaculatorMethod{
    /**
       代码剖析：
       1. ^(CaculatorMaker *maker) {
       
                maker.add(1).add(2).add(3).add(4).divide(5);
       
          }];
       传递一个block给calculate方法，在calculate方法中创建一个CaculatorMaker对象，然后作为输入参数传递给block的maker，这个block内部进行相应的计算工作，即步奏2所作的工作。最后调用return maker.result;将计算结果返回。
       
       2. maker.add这个方法获取在add中定义的block:
       
          ^(int num){
       
              self.result += num;
       
              return self;
       
          }; 然后传递参数1给block中的num，再进行计算工作，最后将这个block整体返回回去，然后重复调用后面的add和divide方法。
       链式编程的代表：masonry框架。
       */
       int result = [NSObject calculate:^(CalculatorMaker * _Nonnull maker) {
           maker.add(1).add(2).add(3).add(4).sub(1);
       }];
       NSLog(@"Result:%d",result);
       
       /**
           代码剖析：
           1. calculate方法中可以完成自己想要的计算，得出结果并且返回Calculator对象。
           
           2. 用返回的Calculator实例对象紧接着调用equal方法完成判等操作。
           
           函数式编程的代表：ReactiveCocoa框架。
           */
       Calculator *calc = [[Calculator alloc] init];
       BOOL isEqual = [[calc calculate:^int(int result) {
           result += 2;
           result *= 5;
           return result;
       }] equal:^BOOL(int result) {
           return result == 10;
       }];
       
       NSLog(@"isEqual:%d", isEqual);
}

- (void)btnClick{
    //    分享猫科静物的歌单《填充物》http://music.163.com/playlist/1997538165/89292472/?userid=89292472 (@网易云音乐)
   
    //歌单id 1997538165
    
    //api 接口 http://music.163.com/api/playlist/detail?id=1997538165&updateTime=-1
    
    //酷狗歌单：分享故梦的歌单《‖G.E.M.邓紫棋‖:一路成长的铁肺女王》https://t4.kugou.com/song.html?id=5lXkc16wjV2（@酷狗音乐）
     //拿到urlString
        NSString *urlString = @"http://music.163.com/playlist/1997538165/89292472/?userid=89292472";
        
        //编码
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        //转换成NSURL
        NSURL *url = [NSURL URLWithString:urlString];
        

    
    NSURL *questUrl = [NSURL URLWithString:@"https://c.y.qq.com/base/fcgi-bin/u?__=uiZBPcc"];
    [self redirectForURL:questUrl];

}

- (void)redirectForURL:(NSURL*)url{
    
       NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
       quest.HTTPMethod = @"GET";
       NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
       config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
       NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
       
       NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:quest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
          NSLog(@"%ld",urlResponse.statusCode);
          NSLog(@"%@",urlResponse.allHeaderFields);
           
          NSDictionary *dic = urlResponse.allHeaderFields;
          NSLog(@"%@",dic[@"Location"]);
           
           
       }];
       [task resume];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler{
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%ld",urlResponse.statusCode);
    NSLog(@"%@",urlResponse.allHeaderFields);
    
    NSDictionary *dic = urlResponse.allHeaderFields;
    NSLog(@"location url:%@",dic[@"Location"]);
    completionHandler(request);
    
    if (dic[@"Location"] != nil) {
         NSURL *questUrl = [NSURL URLWithString:dic[@"Location"]];
        [self redirectForURL:questUrl];
    }
}


@end
