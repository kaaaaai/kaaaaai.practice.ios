//
//  CalculatorMaker.m
//  FunctionTest
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//


#import "CalculatorMaker.h"

@implementation CalculatorMaker
-(CalculatorMaker * _Nonnull (^)(int))add{
    return ^(int num){
        self.result += num;
        return self;
    };
}

- (CalculatorMaker *(^)(int))sub {
    return ^(int num){
        self.result -= num;
        return self;
    };
}

- (CalculatorMaker *(^)(int))multi {
    return ^(int num){
        self.result *= num;
        return self;
    };
}

- (CalculatorMaker *(^)(int))divide {
    return ^(int num){
        self.result /= num;
        return self;
    };
}

@end
