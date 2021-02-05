//
//  CSWebView.m
//  ChinaBond
//
//  Created by 邵梦 on 2020/11/9.
//  Copyright © 2020 chinaBond. All rights reserved.
//

//#import "CSWebView.h"
//
//@interface CSWebView ()
//
//@end
//
//@implementation CSWebView

#import "CSWebView.h"
#import <WebKit/WebKit.h>
#import "CBMessageShareView.h"
#import "CBDataBase.h"
#import "CBCacheManager.h"
//#import <ShareSDK/ShareSDK.h>
#import "CustomActivity.h"
#import <AFURLSessionManager.h>
#import "CBFileController.h"
#import "CBLoginController.h"
#import "NSURLProtocolCustom.h"
#import "NSURLProtocol+WKWebVIew.h"

@interface CSWebView ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
{
    UIView *bgView;
    UIImageView *imgView;
}

@property (nonatomic, strong) WKWebView *wkWebView;
//@property (nonatomic, strong) UIView *shadowView;
//@property (nonatomic, strong) CBMessageShareView *shareView;
@property (nonatomic) BOOL isCollect;
@property (nonatomic, strong) UIButton *rightButton1;
@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation CSWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.infoUrl = @"https://www.chinabond.com.cn/Info/155464739?sd=chinabond";
//    self.infoUrl = @"https://www.chinabond.com.cn/Info/154688743?sd=chinabond";

    self.title = self.titleS;
    
    //设置背景颜色
//    self.view.backgroundColor = [UIColor whiteColor];
    UIColor *backColor;

    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        backColor =  [UIColor lightGrayColor];
    }else{
        backColor =  [UIColor whiteColor];
    }
    self.view.backgroundColor = backColor;

    
   [NSURLProtocol registerClass:[NSURLProtocolCustom class]];

    
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    
    [self addWKWebView];
    
    
    [self makeNavView];
    //self.isCollect = [[CBDataBase sharedDatabase] checkSeverNoteId:self.tId];
    
    [self checkInfo];
    [self makeView];
    
    [self.wkWebView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.wkWebView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH, 2)];
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
    wkWebView.backgroundColor = [UIColor clearColor];
//    _infoUrl = [_infoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        wkWebView.opaque = NO;

    }else{
        wkWebView.opaque = YES;
    }
    
    if(self.isLocalHtml){
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:self.localHtmlName ofType:@"html"];
        NSURL *pathURL = [NSURL fileURLWithPath:filePath];
        [wkWebView loadRequest:[NSURLRequest requestWithURL:pathURL]];
        
    }else{
        
        NSURL *url = [NSURL URLWithString:self.infoUrl];
        [wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }

    [self.view addSubview:wkWebView];
    _wkWebView = wkWebView;
    
}
- (void)makeView{
    
//    self.shadowView = [[UIView alloc] initWithFrame:self.view.frame];
//    self.shadowView.backgroundColor = [UIColor blackColor];
//    self.shadowView.alpha = 0.5;
//    self.shadowView.hidden = YES;
//    [self.view addSubview:self.shadowView];
//
//    self.shareView = [[CBMessageShareView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257)];
//    self.shareView.delegate = self;
//    [self.view addSubview:self.shareView];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"focusDetailFirst"]) {
        self.guideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.guideView.backgroundColor = UIColorFromRGB(0x000000);
        self.guideView.alpha = .7;
        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
        
        UIImageView *guideImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 195, 200, 155)];
        guideImage.image = [UIImage imageNamed:@"guide_youhua"];
        [self.guideView addSubview:guideImage];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGes:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.guideView addGestureRecognizer:swipe];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"focusDetailFirst"];
    }
    
}
- (void)makeNavView{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIView *rightToolbar = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 0, 55, 44)];
    
    self.rightButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 11, 20, 20)];
    [self.rightButton1 setBackgroundImage:[UIImage imageNamed:self.isCollect ? @"collect_select" : @"collect"] forState:UIControlStateNormal];
    [self.rightButton1 addTarget:self action:@selector(collectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightToolbar addSubview:self.rightButton1];
    
    UIButton *rightButton2 = [[UIButton alloc] initWithFrame:CGRectMake(35, 11, 20, 20)];
    [rightButton2 setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightToolbar addSubview:rightButton2];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightToolbar];
    
    //添加到navigationbar中
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}
//判断收藏状态
- (void)checkInfo
{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    if (infoDic) {
        
        [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                          Params:@{@"SID":@"17",
                                                   @"userName":[infoDic objectForKey:@"userName"],
                                                   @"infoId":self.tId}
                                 completionBlock:^(id responseObject) {
            
            
            if ([responseObject[@"infoCount"] isEqualToString:@"0"]) {
                self.isCollect = NO;
            }
            else
            {
                self.isCollect = YES;
            }
            
            [self.rightButton1 setBackgroundImage:[UIImage imageNamed:self.isCollect ? @"collect_select" : @"collect"] forState:UIControlStateNormal];
            
        } failBlock:^(NSError *error) {
            CBLog(@"%@",error);
        }];
    }
    else
    {
        self.isCollect = NO;
        
        [self.rightButton1 setBackgroundImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        
    }
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

- (void)collectButtonClick
{
    if (self.isCollect) {
        
        //取消收藏
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        
        NSString *isLogStr = [userDic objectForKey:@"isLog"];
        
        if ([isLogStr isEqualToString:@"1"]) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                              Params:@{@"SID":@"11",
                                                       @"userName":[userDic objectForKey:@"userName"],
                                                       @"infoId":self.tId}
             
                                     completionBlock:^(id responseObject) {
                
                if ([responseObject[@"state"] isEqualToString:@"0"]) {
                    self.isCollect = !self.isCollect;
                    [self.rightButton1 setBackgroundImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                }
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                
            } failBlock:^(NSError *error) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            [alert show];
        }
        
    }
    else
    {
        //添加
        
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        
        NSString *isLogStr = [userDic objectForKey:@"isLog"];
        
        if ([isLogStr isEqualToString:@"1"]) {
            
            [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                              Params:@{@"SID":@"08",
                                                       @"userName":[userDic objectForKey:@"userName"],
                                                       @"infoId":self.tId}
             
                                     completionBlock:^(id responseObject) {
                
                if ([responseObject[@"state"] isEqualToString:@"0"]) {
                    
                    self.isCollect = !self.isCollect;
                    
                    [self.rightButton1 setBackgroundImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateNormal];
                }
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                
            } failBlock:^(NSError *error) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            [alert show];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        CBLoginController *login = [[CBLoginController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}
#pragma mark -Share
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
    NSURL *shareUrl = [NSURL URLWithString:@"https://www.chinabond.com.cn/Info/155464739?sd=chinabond"];
    NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];
    
    // 自定义的CustomActivity，继承自UIActivity
//    CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:shareText ActivityImage:[UIImage imageNamed:@"shareLogo"] URL:shareUrl ActivityType:@"Custom"];
//    NSArray *activityArray = @[customActivity];
    
    // 2、创建分享的控制器
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
-(void)shareButtonClick:(NSInteger)tag
{
    
//    switch (tag) {
//        case 0://微博
//        {
//
//            id<ISSContent> content = [ShareSDK content:self.infoDic[@"title"]
//                                        defaultContent:self.infoDic[@"title"]
//                                                 image:nil
//                                                 title:self.infoDic[@"title"]
//                                                   url:@"www.baidu.com"
//                                           description:self.infoDic[@"title"]
//                                             mediaType:SSPublishContentMediaTypeNews];
//            [ShareSDK clientShareContent:content type:ShareTypeSinaWeibo statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                switch (state) {
//                    case SSResponseStateSuccess:
//                        [MBProgressHUD bwm_showTitle:@"分享成功" toView:self.view hideAfter:2];
//                        break;
//                    case SSResponseStateFail:
//                        [MBProgressHUD bwm_showTitle:@"分享失败" toView:self.view hideAfter:2];
//                        break;
//                    default:
//                        break;
//                }
//            }];
//        }
//            break;
//        case 1://微信
//        {
//            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
//            id<ISSContent> content = [ShareSDK content:self.infoDic[@"title"]
//                                        defaultContent:self.infoDic[@"title"]
//                                                 image:[ShareSDK imageWithPath:imagePath]
//                                                 title:self.infoDic[@"title"]
//                                                   url:self.infoUrl
//                                           description:self.infoDic[@"title"]
//                                             mediaType:SSPublishContentMediaTypeNews];
//            [ShareSDK clientShareContent:content type:ShareTypeWeixiSession statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                switch (state) {
//                    case SSResponseStateSuccess:
//                        [MBProgressHUD bwm_showTitle:@"分享成功" toView:self.view hideAfter:2];
//                        break;
//                    case SSResponseStateFail:
//                        [MBProgressHUD bwm_showTitle:@"请安装最新版本的微信客户端" toView:self.view hideAfter:2];
//                        break;
//                    default:
//                        break;
//                }
//            }];
//        }
//            break;
//        case 2://微信好友
//        {
//            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
//            id<ISSContent> content = [ShareSDK content:self.infoDic[@"title"]
//                                        defaultContent:self.infoDic[@"title"]
//                                                 image:[ShareSDK imageWithPath:imagePath]
//                                                 title:self.infoDic[@"title"]
//                                                   url:self.infoUrl
//                                           description:self.infoDic[@"title"]
//                                             mediaType:SSPublishContentMediaTypeNews];
//            [ShareSDK clientShareContent:content type:ShareTypeWeixiTimeline statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                switch (state) {
//                    case SSResponseStateSuccess:
//                        [MBProgressHUD bwm_showTitle:@"分享成功" toView:self.view hideAfter:2];
//                        break;
//                    case SSResponseStateFail:
//                        [MBProgressHUD bwm_showTitle:@"请安装最新版本的微信客户端" toView:self.view hideAfter:2];
//                        break;
//                    default:
//                        break;
//                }
//            }];
//        }
//            break;
//        default:
//            break;
//    }
    
    
    
}

//-(void)cancelBtnClick
//{
//    self.shadowView.hidden = YES;
//    [UIView animateWithDuration:.5f animations:^{
//        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257);
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
- (void)swipeGes:(UISwipeGestureRecognizer *)gesture
{
    [self.guideView removeFromSuperview];
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
        
        //如果是跳转一个新页面
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
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



