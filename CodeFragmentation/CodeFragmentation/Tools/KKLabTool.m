//
//  KKLabTool.m
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/7/8.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

#import "KKLabTool.h"

@implementation KKLabTool
KKSingletonM(LabTool)

///取出相同的对象
-(void)takeOutSameItem{
    NSArray *arr = [NSArray arrayWithObjects:@"1",@"2",@"1",@"7",@"4",@"5",@"2", @"6",@"5",nil];
    NSMutableArray *arrmu = [[NSMutableArray alloc]init];// 过滤
    NSMutableArray *sameArray = [[NSMutableArray alloc]init];//找出相同的
    for (int i = 0 ; i < [arr count]; i++) {
        id str = [arr objectAtIndex:i];
        if ([arrmu count] == 0) {
            [arrmu addObject:str];
        } else{
            BOOL flag = NO;
            for (int j = 0; j < [arrmu count]; j++ ) {
                if ([str isEqual:[arrmu objectAtIndex:j]]) {
                    [sameArray addObject:str];
                    flag =YES;
                    break;
                }else{
                    flag =NO;
                }}
            if (flag == NO) {
                [ arrmu addObject:str];
            }
        }
    }
    NSLog(@"sameArray : %@",sameArray);
}

@end
