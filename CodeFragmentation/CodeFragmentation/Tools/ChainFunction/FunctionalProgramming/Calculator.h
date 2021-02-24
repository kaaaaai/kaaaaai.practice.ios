//
//  Calculator.h
//  FunctionTest
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculator : NSObject
@property (nonatomic, assign) int result;
- (Calculator *)calculate:(int (^)(int result))calculate;
- (BOOL)equal:(BOOL (^)(int result))operation;
@end

NS_ASSUME_NONNULL_END
