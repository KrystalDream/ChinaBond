//
//  CBHttpManager.h
//  ChinaBond
//
//  Created by 邵梦 on 2020/11/2.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBHttpManager : AFHTTPSessionManager
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
