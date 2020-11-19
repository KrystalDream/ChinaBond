//
//  CBCacheManager.m
//  ChinaBond
//
//  Created by wangran on 15/12/22.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBCacheManager.h"

@implementation CBCacheManager

static  CBCacheManager*_sharedCache = nil;
+(CBCacheManager *)shareCache
{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        _sharedCache = [[self alloc] init];
    });
    return _sharedCache;
}

- (id)init {
    if (self = [super init]) {
        
        if (!_searchRecordArr) {
            _searchRecordArr = [[NSMutableArray alloc] initWithCapacity:100];
        }

        if (!_gdChannelArr) {
            _gdChannelArr = [[NSMutableArray alloc] initWithCapacity:100];
        }
    }
    return self;
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}
+ (id)retain
{
    return self;
}
+ (oneway void)release
{
    //do nothing
}
+ (id)autorelease
{
    return self;
}

- (void)saveCacheWithArray:(NSArray *)arr;
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = @"channelCache";
    
    NSArray *value = [setting objectForKey:key];
    
    NSMutableArray *channelArr = [[NSMutableArray alloc] initWithArray:value];
    
    //处理首页快捷入口按钮
    if (channelArr.count>4) {
        
        for (int i=0; i<4; i++) {
            [channelArr replaceObjectAtIndex:i withObject:arr[i]];
        }
        
    }
    else
    {
        [channelArr addObjectsFromArray:arr];
    }
    
    NSDictionary *lastName = [channelArr lastObject];
    if (![lastName[@"name"] isEqualToString:@"添加自定义"]) {
        [channelArr addObject:@{@"imgUrl":@"home_7",
                                          @"id":@"1000",
                                          @"name":@"添加自定义",
                                          @"typeId":@"7"}
         ];
    }
    
    [setting setObject:channelArr forKey:key];
    [setting synchronize];
}

- (NSArray *)getCache
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = @"channelCache";
    
    NSArray *value = [settings objectForKey:key];
    return value;
}

-(void) addChannelWithDic:(NSDictionary *)channelDic atIndex:(NSInteger)index
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = @"channelCache";
    
    NSMutableArray *value = [[settings objectForKey:key] mutableCopy];
    
    [value insertObject:channelDic atIndex:index];
    
    [settings setObject:value forKey:key];
}

- (void) deleteChannel:(NSInteger)tag
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = @"channelCache";
    
    NSMutableArray *value = [[settings objectForKey:key] mutableCopy];
    [value removeObjectAtIndex:tag];
    
    [settings setObject:value forKey:key];
    [settings synchronize];
}


-(void)setObject:(id)obj andKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(id) getObjectforKey:(NSString *)key
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return obj;
}

-(NSDictionary *)phoneDic
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneConfigue"];
    return dic;
}

- (void)requestPhoneConfigue
{
    [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                      Params:@{@"SID":@"14"}
                             completionBlock:^(id responseObject) {
                                 NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
                                 if ([state isEqualToString:@"0"]) {
                                     
                                     NSDictionary *dic = responseObject[@"phoneList"][0];
                                     
                                     [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"phoneConfigue"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     
                                 }
                             } failBlock:^(NSError *error) {
                                 CBLog(@"%@",error);
                             }];
    
}

@end
