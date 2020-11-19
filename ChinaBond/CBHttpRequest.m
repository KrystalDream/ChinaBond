//
//  CBHttpRequest.m
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBHttpRequest.h"
#import <AFNetworking.h>
#import "CBHttpManager.h"

@implementation CBHttpRequest

static CBHttpRequest *_shareRequest = nil;
+(CBHttpRequest *)shareRequest
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareRequest = [[CBHttpRequest alloc] init];
    });
    
    return _shareRequest;
}

-(void)getWithUrl:(NSString *)url Params:(NSDictionary *)params completionBlock:(HttpRequestSuccessBlock)success failBlock:(HttpRequestFailedBlock)filed
{
    [self requestWithUrl:url Params:params completionBlock:^(id responseObject) {
        success(responseObject);
    } failBlock:^(NSError *error) {
        filed(error);
    }];
    
}

-(void)requestWithUrl:(NSString *)url Params:(NSDictionary *)params completionBlock:(HttpRequestSuccessBlock)success failBlock:(HttpRequestFailedBlock)filed
{
    
    NSString *paramStr = @"";
    
    for (NSString *key in params) {
        
        if ([paramStr isEqualToString:@""]) {
            paramStr = [NSString stringWithFormat:@"%@=%@",key,params[key]];
        }
        else
        {
            paramStr = [NSString stringWithFormat:@"%@&%@=%@",paramStr,key,params[key]];
        }
    }
    NSLog(@"\n\n\n\n\n\n%@\n\n\n\n\n\n",[NSString stringWithFormat:@"%@?%@",url,paramStr]);

    CBHttpManager *manager = [CBHttpManager sharedManager];

    
    //------------- https--------------------
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    manager.securityPolicy = securityPolicy;
    //------------- https--------------------

    [manager GET:url
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        filed(error);
    }];
    
}

-(void)postWithUrl:(NSString *)url Params:(NSDictionary *)params completionBlock:(HttpRequestSuccessBlock)success failBlock:(HttpRequestFailedBlock)filed
{
        [self requestForPostWithUrl:url Params:params completionBlock:^(id responseObject) {
                success(responseObject);
        } failBlock:^(NSError *error) {
                filed(error);
        }];
}
+(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


-(void)requestForPostWithUrl:(NSString *)url Params:(NSDictionary *)params completionBlock:(HttpRequestSuccessBlock)success failBlock:(HttpRequestFailedBlock)filed
{
    CBHttpManager *manager = [CBHttpManager sharedManager];

    
    //------------- https--------------------
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    manager.securityPolicy = securityPolicy;
    //------------- https--------------------

    [manager POST:url
       parameters:params
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        filed(error);
    }];

}

/**
 * 下载文件
 */
- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                          NSUserDomainMask,
//                                                          YES)objectAtIndex:0];
//    //检查本地文件是否已存在
//    NSString *fileName = [NSString stringWithFormat:@"%@/%@", path, aFileName];
//    
//    //检查附件是否存在
//    if ([fileManager fileExistsAtPath:fileName]) {
//        //NSData *audioData = [NSData dataWithContentsOfFile:fileName];
//        //[self requestFinished:[NSDictionary dictionaryWithObject:audioData forKey:@"res"] tag:aTag];
//    }else{
//        //创建附件存储目录
//        if (![fileManager fileExistsAtPath:aSavePath]) {
//            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        
//        //下载附件
//        NSURL *url = [[NSURL alloc] initWithString:aUrl];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
//        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
//        
//        //下载进度控制
//        /*
//         [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//         NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
//         }];
//         */
//        
//        //已完成下载
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            //NSData *audioData = [NSData dataWithContentsOfFile:fileName];
//            
//           // NSString *string = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
//            
//           // NSLog(@"%@",string);
//
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            //NSLog(@"%@",error);
//        }];
//        
//        [operation start];
//    }
}
@end
