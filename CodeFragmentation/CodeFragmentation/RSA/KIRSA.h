//
//  KIRSA.h
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/3/27.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KIRSA : NSObject
/**
 *
 * 加密
 * originalString 原始字符串
 */
+(NSString *)encryptString:(NSString *) originalString;

/**
 *
 * 解密
 *
 * ciphertextString 加密字符串
 */
+(NSString *)decryptString:(NSString *) ciphertextString;

@end

NS_ASSUME_NONNULL_END
