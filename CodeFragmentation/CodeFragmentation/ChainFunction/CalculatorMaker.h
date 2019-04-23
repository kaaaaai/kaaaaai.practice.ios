//
//  CalculatorMaker.h
//  FunctionTest
//
//  Created by Kaaaaai on 2019/4/23.
//  Copyright © 2019 Kaaaaai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorMaker : NSObject

@property (nonatomic, assign) int result;


- (CalculatorMaker *(^)(int))add;
- (CalculatorMaker *(^)(int))sub;
- (CalculatorMaker *(^)(int))multi;
- (CalculatorMaker *(^)(int))divide;
@end

NS_ASSUME_NONNULL_END
