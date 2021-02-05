//
//  NSURLProtocolCustom.m
//  ChinaBond
//
//  Created by 邵梦 on 2020/11/5.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import "NSURLProtocolCustom.h"

static NSString* const FilteredKey = @"FilteredKey";

@implementation NSURLProtocolCustom
 
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
    //https://www.chinabond.com.cn/Info/155464739?sd=chinabond
    
    //absoluteString： 绝对路径   资源文件
    //https://www.chinabond.com.cn/static/mobile/css/main.css
    //https://www.chinabond.com.cn/static/mobile/images/zdgz_down_btn.png

    //pathExtension：  路径扩展
    //css
    //png
    
    //isSource        YES   才走其他方法

    NSString *extension = request.URL.pathExtension;
        BOOL isSource = [@[@"css"] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [extension compare:obj options:NSCaseInsensitiveSearch] == NSOrderedSame;
        }] != NSNotFound;
    return [NSURLProtocol propertyForKey:FilteredKey inRequest:request] == nil && isSource;

}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSString *fileName = [super.request.URL.absoluteString componentsSeparatedByString:@"/"].lastObject;
       NSLog(@"fileName is %@",fileName);
       //这里是获取本地资源路径 如:png,js等
       NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
       if (!path) {
           [self sendResponseWithData:[NSData data] mimeType:nil];
           return;
       }
       
       //根据路径获取MIMEType
       CFStringRef pathExtension = (__bridge_retained CFStringRef)[path pathExtension];
       CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
       CFRelease(pathExtension);
       
       //The UTI can be converted to a mime type:
       NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
       if (type != NULL)
           CFRelease(type);
    
    //加载本地资源
       NSData *data = [NSData dataWithContentsOfFile:path];
       [self sendResponseWithData:data mimeType:mimeType];

}
- (void)stopLoading
{
//    if (self.task != nil)
//    {
//        [self.task  cancel];
//    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    [self.client URLProtocolDidFinishLoading:self];
}
- (void)sendResponseWithData:(NSData *)data mimeType:(nullable NSString *)mimeType
{
    // 这里需要用到MIMEType
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:super.request.URL
                                                        MIMEType:mimeType
                                           expectedContentLength:-1
                                                textEncodingName:nil];
    
    //硬编码 开始嵌入本地资源到web中
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

@end

