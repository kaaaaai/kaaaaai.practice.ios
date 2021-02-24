//
//  KKMethodChainStyle.m
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/7/8.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

#import "KKMethodChainStyle.h"

@implementation KKMethodChainStyle

///链式编程、函数式编程
- (void)CaculatorMethod{
    /**
       代码剖析：
       1. ^(CaculatorMaker *maker) {
       
                maker.add(1).add(2).add(3).add(4).divide(5);
       
          }];
       传递一个 block 给 calculate 方法，在 calculate 方法中创建一个CaculatorMaker对象，然后作为输入参数传递给block的maker，这个block内部进行相应的计算工作，即步奏2所作的工作。最后调用return maker.result;将计算结果返回。
       
       2. maker.add这个方法获取在add中定义的block:
       
          ^(int num){
       
              self.result += num;
       
              return self;
       
          }; 然后传递参数1给block中的num，再进行计算工作，最后将这个block整体返回回去，然后重复调用后面的add和divide方法。
       链式编程的代表：masonry框架。
       */
       int result = [NSObject calculate:^(CalculatorMaker * _Nonnull maker) {
           maker.add(1).add(2).add(3).add(4).sub(1);
       }];
       NSLog(@"Result:%d",result);
       
       /**
           代码剖析：
           1. calculate方法中可以完成自己想要的计算，得出结果并且返回Calculator对象。
           
           2. 用返回的Calculator实例对象紧接着调用equal方法完成判等操作。
           
           函数式编程的代表：ReactiveCocoa框架。
           */
       Calculator *calc = [[Calculator alloc] init];
       BOOL isEqual = [[calc calculate:^int(int result) {
           result += 2;
           result *= 5;
           return result;
       }] equal:^BOOL(int result) {
           return result == 10;
       }];
       
       NSLog(@"isEqual:%d", isEqual);
}

@end
