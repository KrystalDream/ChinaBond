//
//  NSDictionary+ModelParse.m
//  ChinaBond
//
//  Created by wangran on 15/12/28.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "NSDictionary+ModelParse.h"

@implementation NSDictionary (ModelParse)
- (NSString *)stringValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }else{
        NSString *des = [NSString stringWithFormat:@"在解析服务端数据时候，某个字符串内容为:%@",[obj class]];
        CBLog(@"%@",des);
        return [NSString stringWithFormat:@"%@",obj];
    }
}
- (int)longValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if (obj) {
        return [obj longValue];
    }else{
        CBLog(@"在解析服务端数据时候，某个整形内容为(null)");
        return 0;
    }
}
- (int)intValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if (obj) {
        return [obj intValue];
    }else{
        CBLog(@"在解析服务端数据时候，某个整形内容为(null)");
        return 0;
    }
}
- (float)floatValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if (obj) {
        return [obj floatValue];
    }else{
        CBLog(@"在解析服务端数据时候，某个浮点型内容为(null)");
        return 0.0;
    }
}
- (double)doubleValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if (obj) {
        return [obj doubleValue];
    }else{
        CBLog(@"在解析服务端数据时候，某个浮点型内容为(null)");
        return 0.0;
    }
}
- (BOOL)boolValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if (obj) {
        return [obj boolValue];
    }else{
        CBLog(@"在解析服务端数据时候，某个布尔内容为(null)");
        return NO;
    }
}
@end
