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
    
    UIColor *backColor;

    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        backColor =  [UIColor lightGrayColor];
    }else{
        backColor =  [UIColor whiteColor];
    }
    self.view.backgroundColor = backColor;
    
//    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.title = @"中国债券信息网";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
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

    }else{
        webView.opaque = YES;
    }
    
    [self.view addSubview:webView];
}

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
    
    
//    //设置JS。@"document.getElementsByTagName(‘body‘)[0].style.background=‘#000000‘"
//        NSString *inputValueJS = @"document.getElementsByName('body')[0].style.background='#00FF00'";
//        //执行JS
//        [webView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//            NSLog(@"value: %@ error: %@", response, error);
//        }];
    
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
