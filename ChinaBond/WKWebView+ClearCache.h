//
//  WKWebView+ClearCache.h
//  ChinaBond
//
//  Created by Krystal on 2021/2/5.
//  Copyright © 2021 chinaBond. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (ClearCache)
// 自定义清除缓存
+(void)customDeleteWebCache;

// 清除全部缓存
+(void)deleteWebCache;


@end

NS_ASSUME_NONNULL_END
