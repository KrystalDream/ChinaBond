//
//  NSDictionary+ModelParse.h
//  ChinaBond
//
//  Created by wangran on 15/12/28.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 *  用于HTTP控制层解析数据，封装报错处理
 *
 *  需要在这个类中添加对服务端返回的异常数据的处理
 */
@interface NSDictionary (ModelParse)
- (NSString *)stringValueForKey:(NSString *)key;
- (int)intValueForKey:(NSString *)key;
- (float)floatValueForKey:(NSString *)key;
- (BOOL)boolValueForKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key;
- (int)longValueForKey:(NSString *)key;
@end
