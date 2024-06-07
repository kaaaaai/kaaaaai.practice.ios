//
//  KKLabTool.h
//  CodeFragmentation
//
//  Created by Kaaaaai on 2020/7/8.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLabTool : NSObject
KKSingletonH(LabTool)

/*!
 *  @method 取出相同的元素-测试方法
 *
 */
-(void)takeOutSameItem;
@end

NS_ASSUME_NONNULL_END
