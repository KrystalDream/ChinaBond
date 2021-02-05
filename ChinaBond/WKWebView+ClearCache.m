//
//  WKWebView+ClearCache.m
//  ChinaBond
//
//  Created by Krystal on 2021/2/5.
//  Copyright © 2021 chinaBond. All rights reserved.
//

#import "WKWebView+ClearCache.h"

@implementation WKWebView (ClearCache)
+ (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}
+ (void)customDeleteWebCache {
    /*
     在磁盘缓存上。
     WKWebsiteDataTypeDiskCache,
     
     html离线Web应用程序缓存。
     WKWebsiteDataTypeOfflineWebApplicationCache,
     
     内存缓存。
     WKWebsiteDataTypeMemoryCache,
     
     本地存储。
     WKWebsiteDataTypeLocalStorage,
     
     Cookies
     WKWebsiteDataTypeCookies,
     
     会话存储
     WKWebsiteDataTypeSessionStorage,
     
     IndexedDB数据库。
     WKWebsiteDataTypeIndexedDBDatabases,
     查询数据库。
       WKWebsiteDataTypeWebSQLDatabases
       */
      NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeOfflineWebApplicationCache];
      
      NSSet *websiteDataTypes= [NSSet setWithArray:types];
      NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
      
      [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
          
      }];
      
  }
@end
