//
//  CBPrivacyWebViewController.m
//  ChinaBond
//
//  Created by Krystal on 2020/11/20.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import "CBPrivacyWebViewController.h"
#import <WebKit/WebKit.h>

@interface CBPrivacyWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation CBPrivacyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self makeView];
}
- (void)makeView
{
    
    
    UIButton *backbtn = [UIButton new];
    backbtn.frame = CGRectMake(0, 0, 60, 30);
    [backbtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    backbtn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:backbtn];
    
    //1.创建配置项
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.selectionGranularity = WKSelectionGranularityDynamic;
    //
    //    //1.1 设置偏好
    //    config.preferences = [[WKPreferences alloc] init];
    //    config.preferences.minimumFontSize = 10;
    //    config.preferences.javaScriptEnabled = YES;
    //    //1.1.1 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    //    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //    config.processPool = [[WKProcessPool alloc] init];
    //
    //    config.userContentController = [[WKUserContentController alloc] init];
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //2.添加WKWebView
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height - 64) configuration:config];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    wkWebView.UIDelegate = self;
    wkWebView.navigationDelegate = self;
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:self.localHtmlName ofType:@"html"];
    NSURL *pathURL = [NSURL fileURLWithPath:filePath];
    [wkWebView loadRequest:[NSURLRequest requestWithURL:pathURL]];
    
    [self.view addSubview:wkWebView];
    _wkWebView = wkWebView;
    
    
    
}
- (void)btnClick{
    
    [self.view removeFromSuperview];
}
#pragma mark -WKWebViewDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //接受传过来的消息从而决定app调用的方法
//    NSDictionary *dict = message.body;
//    NSString *method = [dict objectForKey:@"method"];
//    if ([method isEqualToString:@"hello"]) {
//        [self hello:[dict objectForKey:@"param1"]];
//    }else if ([method isEqualToString:@"Call JS"]){
//        [self callJS];
//    }else if ([method isEqualToString:@"Call JS Msg"]){
//        [self callJSMsg:[dict objectForKey:@"param1"]];
//    }
}

//- (void)hello:(NSString *)param{
//    NSLog(@"hello");
//}
//
//- (void)callJS{
//    NSLog(@"callJS");
//}
//
//- (void)callJSMsg:(NSString *)msg{
//    NSLog(@"callJSMsg");
//}

//WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {// 类似UIWebView的 -webViewDidStartLoad:
    NSLog(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似UIWebView 的 －webViewDidFinishLoad:
    NSLog(@"didFinishNavigation");
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    NSLog(@"didFailProvisionalNavigation");
}


// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationAction %@",navigationAction.request);
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
        
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}

//WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction*)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // 接口的作用是打开新窗口委托
    //[self createNewWebViewWithURL:webView.URL.absoluteString config:Web];
    
    return _wkWebView;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

//  js 里面的alert实现，如果不实现，网页的alert函数无效
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString*)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
        completionHandler(NO);
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void(^)(NSString *))completionHandler {
    
    completionHandler(@"Client Not handler");
    
}

@end
