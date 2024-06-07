//
//  KKSingleton.h
//  CodeFragmentation
//
//  Created by Kaaaaai on 2020/7/8.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

#ifndef KKSingleton_h
#define KKSingleton_h

// .h文件
#define KKSingletonH(name) + (instancetype)shared##name;

// .m文件
#define KKSingletonM(name) \
static id _instance; \
 \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
 \
+ (instancetype)shared##name \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
} \
 \
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instance; \
}

#endif /* KKSingleton_h */
