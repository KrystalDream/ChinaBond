//
//  CBCacheManager.h
//  ChinaBond
//
//  Created by wangran on 15/12/22.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBCacheManager : NSObject

@property (nonatomic, strong) NSString *fontNum;

@property (nonatomic, strong) NSMutableArray *searchRecordArr;

@property (nonatomic, strong) NSMutableArray *gdChannelArr;

@property (nonatomic, strong) NSMutableArray *zdyChannelArr;

@property (nonatomic, strong) NSDictionary *phoneDic;

+(CBCacheManager *)shareCache;
- (void)requestPhoneConfigue;

- (void)saveCacheWithArray:(NSArray *)arr;
- (NSMutableArray *)getCache;
- (void) addChannelWithDic:(NSDictionary *)channelDic atIndex:(NSInteger)index;
- (void) deleteChannel:(NSInteger)tag;

- (void) setObject:(id)obj andKey:(NSString *)key;
- (id) getObjectforKey:(NSString *)key;

@end
