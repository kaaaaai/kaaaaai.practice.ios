//
//  Calculator.m
//  FunctionTest
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator
- (Calculator *)calculate:(int (^)(int result))calculate {
    self.result = calculate(self.result);
    return self;
}

- (BOOL)equal:(BOOL (^)(int result))operation {
    return operation(self.result);
}
@end
