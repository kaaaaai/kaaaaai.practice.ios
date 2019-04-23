//
//  NSObject+Calculator.h
//  FunctionTest
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorMaker.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Calculator)
+ (int)calculate:(void (^)(CalculatorMaker *maker))calculator;
@end

NS_ASSUME_NONNULL_END
