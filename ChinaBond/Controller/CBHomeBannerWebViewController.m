//
//  CBHomeBannerWebViewController.m
//  ChinaBond
//
//  Created by Krystal on 2020/11/30.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import "CBHomeBannerWebViewController.h"

#import <WebKit/WebKit.h>

#import "NSURLProtocolCustom.h"
#import "NSURLProtocol+WKWebVIew.h"
#import <AFURLSessionManager.h>
#import "CBFileController.h"

@interface CBHomeBannerWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation CBHomeBannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.title = @"中国债券信息网";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    webView.delegate = self;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.infoUrl]];
//    [webView loadRequest:request];
    
    
    
    [NSURLProtocol registerClass:[NSURLProtocolCustom class]];
    
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    
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
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height - 64) configuration:config];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    
    NSURL *url = [NSURL URLWithString:self.infoUrl];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];
    _wkWebView = webView;
    
    
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        webView.opaque = NO;
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#000000‘"];
        
        NSString *jSString = @"document.getElementsByTagName(‘body‘)[0].style.background=‘#C0C0C0‘";
              //用于进行JavaScript注入
              WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
              [config.userContentController addUserScript:wkUScript];

    }
    else
    {
        webView.opaque = YES;
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#ffffff‘"];
        
        NSString *jSString = @"document.getElementsByTagName(‘body‘)[0].style.background=‘#ffffff‘";
              //用于进行JavaScript注入
              WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
              [config.userContentController addUserScript:wkUScript];
    }
    
    [self.view addSubview:webView];
}
//
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    if ([request.URL.absoluteString containsString:@"download="]) {
//
//        [webView stopLoading];
//
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL.absoluteString];
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
//                                                                         progress:nil
//                                                                      destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//
//                                                                          NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//                                                                          return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
//
//                                                                      }
//                                                                completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//
//                                                                    CBFileController *file = [[CBFileController alloc] init];
//                                                                    file.fileUrl = filePath;
//                                                                    [self.navigationController pushViewController:file animated:YES];
//
//
//                                                                }];
//
//        [downloadTask resume];
//
//    }
//    return YES;
//}
//
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -WKWebViewDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //接受传过来的消息从而决定app调用的方法
}


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

    if ([strRequest hasPrefix:@"https://www.chinabond.com.cn/resource"]) {
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        //显示弹窗去电脑端下载

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"APP中不支持此附件下载,如需下载，请访问网页版中国债券信息网！"
                                                                          preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:^{

        }];


    }else {
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
    
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
