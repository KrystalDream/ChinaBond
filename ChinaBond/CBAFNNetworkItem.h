//
//  CBAFNNetworkItem.h
//  ChinaBond
//
//  Created by wangran on 15/12/22.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBAFNNetworkDefine.h"
#import "CBAFNNetworkDelegate.h"

/**
 *  网络请求子项
 */
@interface CBAFNNetworkItem : NSObject

/**
 *  网络请求方式
 */
@property (nonatomic, assign) CBAFNNetWorkType networkType;

/**
 *  网络请求URL
 */
@property (nonatomic, strong) NSString *url;

/**
 *  网络请求参数
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 *  网络请求的委托
 */
@property (nonatomic, assign) id<CBAFNNetworkDelegate>delegate;
/**
 *   target
 */
@property (nonatomic,assign) id tagrget;
/**
 *   action
 */
@property (nonatomic,assign) SEL select;

/**
 *  是否显示HUD
 */
@property (nonatomic, assign) BOOL showHUD;

#pragma mark - 创建一个网络请求项，开始请求网络
/**
 *  创建一个网络请求项，开始请求网络
 *
 *  @param networkType  网络请求方式
 *  @param url          网络请求URL
 *  @param params       网络请求参数
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param hashValue    网络请求的委托delegate的唯一标示
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return MHAsiNetworkItem对象
 */
- (CBAFNNetworkItem *)initWithtype:(CBAFNNetWorkType)networkType
                               url:(NSString *)url
                            params:(NSDictionary *)params
                          delegate:(id)delegate
                            target:(id)target
                            action:(SEL)action
                         hashValue:(NSUInteger)hashValue
                           showHUD:(BOOL)showHUD
                      successBlock:(MHAsiSuccessBlock)successBlock
                      failureBlock:(MHAsiFailureBlock)failureBlock;

@end
