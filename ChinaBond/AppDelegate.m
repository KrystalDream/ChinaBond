//
//  AppDelegate.m
//  ChinaBond
//
//  Created by wangran on 15/11/30.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "AppDelegate.h"
#import "CBHomeController.h"
#import "RKChartViewController.h"
#import "CBMessageController.h"
#import "CBUserManageController.h"
#import "UITabBar+badge.h"
#import "RKBaseNavViewController.h"
#import "RKTabBarViewController.h"
#import "CBNavigationController.h"
#import "APService.h"
#import "CBCacheManager.h"
#import "RKDataManager.h"
#import <ImageIO/ImageIO.h>
#import "EAIntroView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
//#import "CBFocusDetailController.h"
#import "CSWebView.h"
#import "RNCachingURLProtocol.h"
#define KUMAPPKEY @"56a5888467e58ec8940010e3"

@interface AppDelegate ()<EAIntroDelegate>

@end



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   // [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KNotification];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    //推送
    [self configueNotificateWithOptions:launchOptions];
    //分享
    [self threeShare];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0xe53d3d)];
    [[UINavigationBar appearance] setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
       
       NSForegroundColorAttributeName:UIColorFromRGB(0xe53d3d)}];
    
    RKTabBarViewController *tab = [[RKTabBarViewController alloc] init];
    tab.tabBar.tintColor = UIColorFromRGB(0xff4e4e);
    self.window.rootViewController = tab;
    //首页
    CBHomeController *home = [[CBHomeController alloc] init];
    
    UIImage *homeImage = [UIImage imageNamed:@"tab_home"];
    homeImage = [homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *homeImageSel = [UIImage imageNamed:@"tab_home_select"];
    homeImageSel = [homeImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:homeImage selectedImage:homeImageSel];
    
    CBNavigationController *homeNav = [[CBNavigationController alloc] initWithRootViewController:home];
    //中债数据
    
    
    //资讯
    CBMessageController *message = [[CBMessageController alloc] init];
    
    UIImage *messageImage = [UIImage imageNamed:@"tab_message"];
    messageImage = [messageImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *messageImageSel = [UIImage imageNamed:@"tab_message_select"];
    messageImageSel = [messageImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    message.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"资讯" image:messageImage selectedImage:messageImageSel];
    
    //[tab.tabBar showBadgeOnItemIndex:2];
    CBNavigationController *messagenav = [[CBNavigationController alloc] initWithRootViewController:message];
    
    
    //用户
    CBUserManageController *userManage = [[CBUserManageController alloc] init];
    
    UIImage *userImage = [UIImage imageNamed:@"tab_user"];
    userImage = [userImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *userImageSel = [UIImage imageNamed:@"tab_user_select"];
    userImageSel = [userImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    userManage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"用户" image:userImage selectedImage:userImageSel];
    
    CBNavigationController *userNav = [[CBNavigationController alloc] initWithRootViewController:userManage];
    
    tab.viewControllers = @[homeNav,
                            [[RKBaseNavViewController alloc] init],
                            messagenav,
                            userNav];
    [[CBCacheManager shareCache] requestPhoneConfigue];
    [self.window makeKeyAndVisible];
    
    //启动动画
    NSString *path=[[NSBundle mainBundle]pathForResource:@"zhongzhai1" ofType:@"gif"];
    NSMutableArray *array =[self praseGIFDataToImageArray:[NSData dataWithContentsOfFile:path]];
    
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT)];
    gifImageView.tag = 10000;
    [self.window addSubview:gifImageView];
    [self.window bringSubviewToFront:gifImageView];
    
    gifImageView.animationImages = array; //动画图片数组
    gifImageView.animationDuration = 3.5; //执行一次完整动画所需的时长
    //gifImageView.animationRepeatCount = 999;  //动画重复次数
    [gifImageView startAnimating];
    
    dispatch_time_t adTime = dispatch_time(DISPATCH_TIME_NOW, 3.5*NSEC_PER_SEC);
    dispatch_after(adTime, dispatch_get_main_queue(), ^{
        [self removeAdView];
    });
    
    return YES;
}

- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:KUMAPPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
}

- (void)configueNotificateWithOptions:(NSDictionary *)launchOptions
{
    //JPush
    BOOL isNoti = [[NSUserDefaults standardUserDefaults] boolForKey:KNotification];
    
    if (isNoti) {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
        [APService setupWithOption:launchOptions];
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    //夜间模式
    
    BOOL nightModel = [[NSUserDefaults standardUserDefaults] boolForKey:KNightModel];
    
    if (nightModel) {
        [DKNightVersionManager nightFalling];
    }
    else
    {
        [DKNightVersionManager dawnComing];
    }
}

- (void)threeShare
{
    
    [ShareSDK registerApp:@"4b78d3a1baa7"];
    [ShareSDK importWeChatClass:[WXApi class]];

}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

- (void)applicationWillResignActivie:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    //NSLog(@"收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    //NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    RKTabBarViewController *tab = (RKTabBarViewController *)self.window.rootViewController;
    UINavigationController *nav = tab.viewControllers[0];
    
    CSWebView *focusDetail = [[CSWebView alloc] init];
    focusDetail.tId = userInfo[@"id"];
    focusDetail.infoUrl = userInfo[@"url"];
    focusDetail.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:focusDetail animated:YES];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    RKTabBarViewController *tab = (RKTabBarViewController *)self.window.rootViewController;
    return [tab supportedInterfaceOrientations];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

-(NSMutableArray *)agdChannelArr
{
    if (!_agdChannelArr) {
        _agdChannelArr = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _agdChannelArr;
}

//gif 转数组、
-(NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;
{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
}

- (void)removeAdView
{
 
    UIImageView *gifImage = (UIImageView *)[self.window viewWithTag:10000];
    [gifImage removeFromSuperview];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        
        //字体
        [[NSUserDefaults standardUserDefaults] setObject:@"100%" forKey:KWebFont];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //夜间模式
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KNightModel];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //自动下载
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KDownLoad];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [self showIntroWithCrossDissolve];
    }
}

//引导页
- (void)showIntroWithCrossDissolve {
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"2"];

    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"3"];
//
//    EAIntroPage *page4 = [EAIntroPage page];
//    page4.bgImage = [UIImage imageNamed:@"4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page1,page2,page3]];
    [intro setDelegate:self];
    [intro showInView:[UIApplication sharedApplication].keyWindow animateDuration:0.0];
}
@end
