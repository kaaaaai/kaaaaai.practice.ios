//
//  NSObject+Calculator.m
//  FunctionTest
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//

#import "NSObject+Calculator.h"

@implementation NSObject (Calculator)
+ (int)calculate:(void (^)(CalculatorMaker *))calculator {
    CalculatorMaker *maker = [[CalculatorMaker alloc] init];
    calculator(maker);
    return maker.result;
}
@end
