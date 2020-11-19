//
//  CBHttpRequest.h
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBHttpRequest : NSObject
//HTTP请求成功Block
typedef void(^HttpRequestSuccessBlock)(id responseObject);

//HTTP请求失败Block
typedef void(^HttpRequestFailedBlock)(NSError *error);

+ (CBHttpRequest *)shareRequest;

-(void)getWithUrl:(NSString *)url Params:(NSDictionary *)params completionBlock:(HttpRequestSuccessBlock)success failBlock:(HttpRequestFailedBlock)filed;

-(void)postWithUrl:(NSString *)url Params:(NSDictionary *)params completionBlock:(HttpRequestSuccessBlock)success failBlock:(HttpRequestFailedBlock)filed;

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName;

@end
