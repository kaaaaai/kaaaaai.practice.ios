//
//  LXAdpcmDeCoder.h
//  CGABluetoothDemo
//
//  Created by Kaaaaai on 2020/8/11.
//  Copyright © 2020 yhl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXAdpcmDeCoder : NSObject
+ (instancetype)shared;
/**
*  初始化解码库
*/
- (void)prepareDecoder;

- (NSData *)decode:(NSData *)adpcm;


@end

NS_ASSUME_NONNULL_END
