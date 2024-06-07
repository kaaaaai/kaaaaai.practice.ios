//
//  KKPlaylistTool.m
//  CodeFragmentation
//
//  Created by Kaaaaai on 2020/7/8.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

#import "KKPlaylistTool.h"

@implementation KKPlaylistTool

///歌单获取
- (void)getSongList{
    //    分享猫科静物的歌单《填充物》http://music.163.com/playlist/1997538165/89292472/?userid=89292472 (@网易云音乐)
    
     //歌单id 1997538165
     
     //api 接口 http://music.163.com/api/playlist/detail?id=1997538165&updateTime=-1
     
     //酷狗歌单：分享故梦的歌单《‖G.E.M.邓紫棋‖:一路成长的铁肺女王》https://t4.kugou.com/song.html?id=5lXkc16wjV2（@酷狗音乐）
         
     NSURL *qqmusicUrl = [NSURL URLWithString:@"https://c.y.qq.com/base/fcgi-bin/u?__=uiZBPcc"];
     [self redirectForURL:qqmusicUrl];

     NSURL *kugouURL = [NSURL URLWithString:@"https://t.kugou.com/6xuWHf2wjV2"];
     [self redirectForURL:kugouURL];
}

- (void)redirectForURL:(NSURL*)url{
    
       NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
       quest.HTTPMethod = @"GET";
       NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
       config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
       NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue currentQueue]];
       
       NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:quest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
