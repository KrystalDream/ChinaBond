//
//  CBPrivacyWebViewController.m
//  ChinaBond
//
//  Created by Krystal on 2020/11/20.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import "CBPrivacyWebViewController.h"
#import <WebKit/WebKit.h>
#import "NSURLProtocolCustom.h"
#import "CBDataBase.h"
#import <AFURLSessionManager.h>
#import "NSURLProtocol+WKWebVIew.h"

@interface CBPrivacyWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
{
    UIView *bgView;
    UIImageView *imgView;
}

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation CBPrivacyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
   [NSURLProtocol registerClass:[NSURLProtocolCustom class]];

    
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    
    [self addWKWebView];
    
    
    [self makeNavView];
    
    [self makeView];
    
    [self.wkWebView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.wkWebView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH, 4)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.tintColor = [UIColor orangeColor];
    [self.view addSubview:self.progressView];
    
}

#pragma mark WKWebView
- (void)addWKWebView
{
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
    
//    _infoUrl = [_infoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:self.localHtmlName ofType:@"html"];
        NSURL *pathURL = [NSURL fileURLWithPath:filePath];
        [wkWebView loadRequest:[NSURLRequest requestWithURL:pathURL]];
        
    
//    NSString *htmlcontentstring = @"main.css";//这里是纯html内容没有加任何css的样式。
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"main" ofType:@".css"];
//
//    NSString *localcss = [NSString stringWithFormat:@"<head><link rel=\"stylesheet\" type=\"text/css\" href=\"%@\"></head>",path];
//    NSString * htmlcontent = [NSString stringWithFormat:@"%@%@",localcss, htmlcontentstring]; //拼接css
//
//    [self.wkWebView loadHTMLString:htmlcontent baseURL:[NSURL fileURLWithPath:path]]; //baseURL指定到css的路径.



    
    [self.view addSubview:wkWebView];
    _wkWebView = wkWebView;
    
    //3.注册js方法
//    [config.userContentController addScriptMessageHandler:self name:@"webViewApp"];
    
    
}
- (void)makeView{
    
   
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"focusDetailFirst"]) {
//        self.guideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        self.guideView.backgroundColor = UIColorFromRGB(0x000000);
//        self.guideView.alpha = .7;
//        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
//
//        UIImageView *guideImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 195, 200, 155)];
//        guideImage.image = [UIImage imageNamed:@"guide_youhua"];
//        [self.guideView addSubview:guideImage];
//
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGes:)];
//        swipe.direction = UISwipeGestureRecognizerDirectionRight;
//        [self.guideView addGestureRecognizer:swipe];
//
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"focusDetailFirst"];
    }
    
}
- (void)makeNavView{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIView *rightToolbar = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 0, 55, 44)];
    
   
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
    }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //        DeLog(@"progress: %f", self.webView.estimatedProgress);
        CGFloat progress = self.wkWebView.estimatedProgress;
        self.progressView.progress = progress;
        
        if (progress >= 0.99) {
            self.progressView.hidden = YES;
        }
    }
    
    
}
- (void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:@"loading"];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - button method

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)cancelBtnClick
{
    
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



