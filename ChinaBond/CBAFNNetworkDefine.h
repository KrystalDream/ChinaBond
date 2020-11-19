//
//  CBAFNNetworkDefine.h
//  ChinaBond
//
//  Created by wangran on 15/12/22.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#ifndef CBAFNNetworkDefine_h
#define CBAFNNetworkDefine_h

/**
 *  请求类型
 */
typedef enum {
   CBAFNNetWorkGET = 1,   /**< GET请求 */
    CBAFNNetWorkPOST       /**< POST请求 */
} CBAFNNetWorkType;

/**
 *  网络请求超时的时间
 */
#define MHAsi_API_TIME_OUT 20


#if NS_BLOCKS_AVAILABLE
/**
 *  请求开始的回调（下载时用到）
 */
typedef void (^MHAsiStartBlock)(void);

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void (^MHAsiSuccessBlock)(NSDictionary *responseObject);

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typedef void (^MHAsiFailureBlock)(NSError *error);

#endif

#endif /* CBAFNNetworkDefine_h */
