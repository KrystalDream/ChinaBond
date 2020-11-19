//
//  CBFocusDetailController.m
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBFocusDetailController.h"
#import "CBMessageShareView.h"
#import "CBDataBase.h"
#import "CBCacheManager.h"
#import <ShareSDK/ShareSDK.h>
#import <AFURLSessionManager.h>
#import "CBFileController.h"
#import "CBLoginController.h"
#import "NSURLProtocolCustom.h"

@interface CBFocusDetailController ()<CBMessageShareDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    UIView *bgView;
    UIImageView *imgView;
}
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) CBMessageShareView *shareView;
@property (nonatomic) BOOL isCollect;
@property (nonatomic, strong) UIButton *rightButton1;
@property (nonatomic, strong) UIView *guideView;

@end

@implementation CBFocusDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    //https://www.chinabond.com.cn/Info/155464739?sd=chinabond
    //https://www.chinabond.com.cn/Info/154688743?sd=chinabond
    
    self.infoUrl = @"https://www.chinabond.com.cn/Info/155464739?sd=chinabond";
    //1.注册自定义类
//    [NSURLProtocol registerClass:[NSURLProtocolCustom class]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleS;
    [self makeNavView];
    //self.isCollect = [[CBDataBase sharedDatabase] checkSeverNoteId:self.tId];

    [self checkInfo];
    
    

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self makeView];
}
- (void)makeView{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
       webView.scalesPageToFit = YES;
       webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      
       if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
            webView.opaque = NO;
           [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#000000‘"];
       }
       else
       {
            webView.opaque = YES;
           [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#ffffff‘"];
       }

       [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.infoUrl]]];
       webView.delegate = self;
       [self.view addSubview:webView];
       
       self.shadowView = [[UIView alloc] initWithFrame:self.view.frame];
       self.shadowView.backgroundColor = [UIColor blackColor];
       self.shadowView.alpha = 0.5;
       self.shadowView.hidden = YES;
       [self.view addSubview:self.shadowView];
       
       self.shareView = [[CBMessageShareView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257)];
       self.shareView.delegate = self;
       [self.view addSubview:self.shareView];
       
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

#pragma mark - web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *fontStr = [[NSUserDefaults standardUserDefaults] objectForKey:KWebFont];

    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",fontStr]];

//    [webView stringByEvaluatingJavaScriptFromString:@"alert('请于电脑端下载')"];

//    static  NSString * const jsGetImages =
//    @"function getImages(){\
//    var objs = document.getElementsByTagName(\"img\");\
//    for(var i=0;i<objs.length;i++){\
//    objs[i].onclick=function(){\
//    document.location=\"myweb:imageClick:\"+this.src;\
//    };\
//    };\
//    return objs.length;\
//    };";
//
//    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
//
//    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
//    NSString *resurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    //调用js方法
    //    NSLog(@"---调用js方法--%@  %s  jsMehtods_result = %@",self.class,__func__,resurlt);
 }
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    

//    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([request.URL.absoluteString hasPrefix:@"https://www.chinabond.com.cn/resource"]) {
        // 不允许跳转
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
        
        return NO;

    }
    return YES;
        
        
    
    
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
//                                                                         }
//                                                                completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//
//                                                                    CBFileController *file = [[CBFileController alloc] init];
//                                                                    file.fileUrl = filePath;
//                                                                    [self.navigationController pushViewController:file animated:YES];
//
//
//                                                                         }];
//
//        [downloadTask resume];
//
//    }
//    else if ([request.URL.absoluteString hasPrefix:@"myweb:imageClick:"]) {
//        NSString *imageUrl = [request.URL.absoluteString substringFromIndex:@"myweb:imageClick:".length];
//        //        NSLog(@"image url------%@", imageUrl);
//        
//        if (bgView) {
//            //设置不隐藏，还原放大缩小，显示图片
//            bgView.hidden = NO;
//            imgView.frame = CGRectMake(10, 10, SCREEN_WIDTH-40, 220);
//            [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
//        }
//        else
//            [self showBigImage:imageUrl];//创建视图并显示图片
//        
//        return NO;
//    }
//    return YES;
    return YES;
    
}

//#pragma mark 显示大图片
//-(void)showBigImage:(NSString *)imageUrl{
//    //创建灰色透明背景，使其背后内容不可操作
//    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [bgView setBackgroundColor:[UIColor colorWithRed:0.3
//                                               green:0.3
//                                                blue:0.3
//                                               alpha:0.7]];
//    [self.view addSubview:bgView];
//    
//    //创建边框视图
//    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 240)];
//    //将图层的边框设置为圆脚
//    borderView.layer.cornerRadius = 8;
//    borderView.layer.masksToBounds = YES;
//    //给图层添加一个有色边框
//    borderView.layer.borderWidth = 8;
//    borderView.layer.borderColor = [[UIColor colorWithRed:0.9
//                                                    green:0.9
//                                                     blue:0.9
//                                                    alpha:0.7] CGColor];
//    [borderView setCenter:bgView.center];
//    [bgView addSubview:borderView];
//    
//    //创建关闭按钮
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//    closeBtn.backgroundColor = [UIColor redColor];
//    [closeBtn addTarget:self action:@selector(removeBigImage) forControlEvents:UIControlEventTouchUpInside];
//    [closeBtn setFrame:CGRectMake(borderView.frame.origin.x+borderView.frame.size.width-20, borderView.frame.origin.y-6, 26, 27)];
//    [bgView addSubview:closeBtn];
//    
//    //创建显示图像视图
//    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
//    imgView.userInteractionEnabled = YES;
//    [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
//    [borderView addSubview:imgView];
//    
//    //添加捏合手势
//    [imgView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
//    
//}

////关闭按钮
//-(void)removeBigImage
//{
//    bgView.hidden = YES;
//}
//
//- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
//{
//    //缩放:设置缩放比例
//    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
//    recognizer.scale = 1;
//}

#pragma mark - button method

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClick
{
    self.shadowView.hidden = NO;
    
    [UIView animateWithDuration:.5f animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT-257, SCREEN_WIDTH, 257);
        
    }];
    
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
            
        }
        else
        {
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
            
        }
        else
        {
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
-(void)shareButtonClick:(NSInteger)tag
{
    switch (tag) {
        case 0://微博
        {

            id<ISSContent> content = [ShareSDK content:self.infoDic[@"title"]
                                        defaultContent:self.infoDic[@"title"]
                                                 image:nil
                                                 title:self.infoDic[@"title"]
                                                   url:@"www.baidu.com"
                                           description:self.infoDic[@"title"]
                                             mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK clientShareContent:content type:ShareTypeSinaWeibo statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                switch (state) {
                    case SSResponseStateSuccess:
                        [MBProgressHUD bwm_showTitle:@"分享成功" toView:self.view hideAfter:2];
                        break;
                    case SSResponseStateFail:
                        [MBProgressHUD bwm_showTitle:@"分享失败" toView:self.view hideAfter:2];
                        break;
                    default:
                        break;
                }
            }];
        }
            break;
        case 1://微信
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
            id<ISSContent> content = [ShareSDK content:self.infoDic[@"title"]
                                        defaultContent:self.infoDic[@"title"]
                                                 image:[ShareSDK imageWithPath:imagePath]
                                                 title:self.infoDic[@"title"]
                                                   url:self.infoUrl
                                           description:self.infoDic[@"title"]
                                             mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK clientShareContent:content type:ShareTypeWeixiSession statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                switch (state) {
                    case SSResponseStateSuccess:
                        [MBProgressHUD bwm_showTitle:@"分享成功" toView:self.view hideAfter:2];
                        break;
                    case SSResponseStateFail:
                        [MBProgressHUD bwm_showTitle:@"请安装最新版本的微信客户端" toView:self.view hideAfter:2];
                        break;
                    default:
                        break;
                }
            }];
        }
            break;
        case 2://微信好友
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
            id<ISSContent> content = [ShareSDK content:self.infoDic[@"title"]
                                        defaultContent:self.infoDic[@"title"]
                                                 image:[ShareSDK imageWithPath:imagePath]
                                                 title:self.infoDic[@"title"]
                                                   url:self.infoUrl
                                           description:self.infoDic[@"title"]
                                             mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK clientShareContent:content type:ShareTypeWeixiTimeline statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                switch (state) {
                    case SSResponseStateSuccess:
                        [MBProgressHUD bwm_showTitle:@"分享成功" toView:self.view hideAfter:2];
                        break;
                    case SSResponseStateFail:
                        [MBProgressHUD bwm_showTitle:@"请安装最新版本的微信客户端" toView:self.view hideAfter:2];
                        break;
                    default:
                        break;
                }
            }];
        }
            break;
        default:
            break;
    }
}

-(void)cancelBtnClick
{
    self.shadowView.hidden = YES;
    [UIView animateWithDuration:.5f animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257);
    }];
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
- (void)swipeGes:(UISwipeGestureRecognizer *)gesture
{
    [self.guideView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
