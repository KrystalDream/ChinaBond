//
//  CBSellNewsDetailController.m
//  ChinaBond
//
//  Created by wangran on 15/12/8.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBSellNewsDetailController.h"
#import "CBSellNewsDetailTitleCell.h"
#import "CBSellNewsDetailCell.h"
#import <WebKit/WebKit.h>

//#import "CBMessageShareView.h"

@interface CBSellNewsDetailController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) WKWebView *wkWebView;

//@property (nonatomic, strong) UIView *shadowView;
//@property (nonatomic, strong) CBMessageShareView *shareView;
@end

@implementation CBSellNewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //navigationbar
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发行快报详情";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;

    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClick)];
    
    self.navigationItem.rightBarButtonItem = rightButton1;
    
//    NSString *zqjc = [NSString stringWithFormat:@"%@",self.infoDic[@"zqjc"]];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
//    NSString *str = [zqjc stringByAddingPercentEscapesUsingEncoding:enc];
    self.urlStr = [NSString stringWithFormat:@"https://www.chinabond.com.cn/jsp/mb/kbcontent.jsp?zqdm=%@",self.infoDic[@"zqdm"]];
    
    
    
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    //webView.scrollView.scrollEnabled = NO;
//    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
//        webView.opaque = NO;
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#000000‘"];
//    }
//    else
//    {
//        webView.opaque = YES;
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#ffffff‘"];
//    }
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
//    [webView reload];
//    [self.view addSubview:webView];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    //2.添加WKWebView
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height - 64) configuration:config];
    wkWebView.userInteractionEnabled = YES;
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    wkWebView.UIDelegate = self;
    wkWebView.navigationDelegate = self;
    wkWebView.backgroundColor = [UIColor clearColor];
//    _infoUrl = [_infoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //设置透明度  根据背景模式
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        wkWebView.opaque = NO;

    }else{
        wkWebView.opaque = YES;
    }
    NSURL *url = [NSURL URLWithString:self.urlStr];
    [wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:wkWebView];
    _wkWebView = wkWebView;
    
//    self.shadowView = [[UIView alloc] initWithFrame:self.view.frame];
//    self.shadowView.backgroundColor = [UIColor blackColor];
//    self.shadowView.alpha = 0.5;
//    self.shadowView.hidden = YES;
//    [self.view addSubview:self.shadowView];
//
//    self.shareView = [[CBMessageShareView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257)];
//    self.shareView.delegate = self;
//    [self.view addSubview:self.shareView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button method

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClick
{
//    self.shadowView.hidden = NO;
//    
//    [UIView animateWithDuration:.5f animations:^{
//        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT-257, SCREEN_WIDTH, 257);
//        
//    }];
    
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = @"中国债券信息网";
    UIImage *shareImage = [UIImage imageNamed:@"shareIcon"];
    NSURL *shareUrl = [NSURL URLWithString:self.urlStr];
    NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];

    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:nil];
    //3.设定不想显示的平台和功能
    activityVC.excludedActivityTypes = [self excludetypes];
    activityVC.modalInPopover = YES;
    
    //4. 设置操作回调,用户点击 菜单按钮后事件执行完成会回调这个block
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {

          if (completed) {
              [MBProgressHUD bwm_showTitle:@"分享成功" toView:self.view hideAfter:2];
          }else{

              [MBProgressHUD bwm_showTitle:@"分享失败" toView:self.view hideAfter:2];
          }

      };
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
-(NSArray *)excludetypes{
    
    NSMutableArray *excludeTypeM = [NSMutableArray arrayWithArray:@[//UIActivityTypePostToFacebook,
        
        UIActivityTypePostToTwitter,
        
        UIActivityTypePostToWeibo,
        
        UIActivityTypeMessage,
        
        UIActivityTypeMail,
        
        UIActivityTypePrint,
        
        UIActivityTypeCopyToPasteboard,
        
        UIActivityTypeAssignToContact,
        
        UIActivityTypeSaveToCameraRoll,
        
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        
        UIActivityTypePostToVimeo,
        
        UIActivityTypePostToTencentWeibo,
        
        UIActivityTypeAirDrop,
        
        UIActivityTypeOpenInIBooks]];
    
    if (@available(iOS 11.0, *)) {
        
        [excludeTypeM addObject:UIActivityTypeMarkupAsPDF];
        
    } else {
        
        // Fallback on earlier versions
        
    }

return excludeTypeM;

}
//-(void)shareButtonClick:(NSInteger)tag
//{
//    switch (tag) {
//        case 0:
//
//            break;
//        case 1:
//            break;
//        case 2:
//            break;
//        default:
//            break;
//    }
//}

//-(void)cancelBtnClick
//{
//    self.shadowView.hidden = YES;
//    [UIView animateWithDuration:.5f animations:^{
//        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257);
//
//    }];
//}

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
}

//WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {// 类似UIWebView的 -webViewDidStartLoad:
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似UIWebView 的 －webViewDidFinishLoad:
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
}


// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}

//WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction*)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // 接口的作用是打开新窗口委托
//    [self createNewWebViewWithURL:webView.URL.absoluteString config:Web];
//    return _wkWebView;

    if (navigationAction.request.URL) {
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:webView.frame configuration:configuration];
        wkWebView.UIDelegate = self;
        wkWebView.navigationDelegate = self;
        [webView loadRequest:navigationAction.request];
        return wkWebView;
    }
     return nil;

}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{    // js 里面的alert实现，如果不实现，网页的alert函数无效
   
    
}

//  js 里面的alert实现，如果不实现，网页的alert函数无效
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString*)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
  
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void(^)(NSString *))completionHandler {
    
    completionHandler(@"Client Not handler");
    
}

@end
