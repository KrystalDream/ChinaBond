//
//  AppDelegate.m
//  ChinaBond
//
//  Created by wangran on 15/11/30.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "AppDelegate.h"
#import "RKChartViewController.h"
#import "RKTabBarViewController.h"
//#import "APService.h"
#import "CBCacheManager.h"
#import "RKDataManager.h"
#import <ImageIO/ImageIO.h>
//#import "EAIntroView.h"
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
#import "CSWebView.h"
#import "RNCachingURLProtocol.h"
//#import "CBPrivacyPolicyPopViewController.h"
//#import "UILabel+YBAttributeTextTapAction.h"
//#import "CBPrivacyWebViewController.h"
#import "ADViewController.h"

#define KUMAPPKEY @"56a5888467e58ec8940010e3"

@interface AppDelegate ()<ADViewControllerDelegate>

@end



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Tag 2.0
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
//    [self configueNotificateWithOptions:launchOptions];
    
    //夜间模式
    [self isNightModel];
    //分享
//    [self threeShare];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0xe53d3d)];
    [[UINavigationBar appearance] setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
       
       NSForegroundColorAttributeName:UIColorFromRGB(0xe53d3d)}];
    
    ADViewController *adVC = [[ADViewController alloc] init];
    adVC.delegate = self;
    self.window.rootViewController = adVC;

    
    //如果想要在某个UIViewController中禁用深色模式
    if (@available(iOS 13.0, *)) {
        [self.window setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
    }
    
    [[CBCacheManager shareCache] requestPhoneConfigue];
    [self.window makeKeyAndVisible];
    
    //判断是否越狱
    [self isJailbreaking];
    
    return YES;
}
//判断是否越狱
- (BOOL)isJailbreaking {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]) {
        [MBProgressHUD bwm_showTitle:@"您正在越狱设备中操作" toView: self.window hideAfter:3];
        return YES;
    }

    return NO;
}
- (void)umengTrack {
//    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    //
//    [MobClick startWithAppkey:KUMAPPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
}

- (void)configueNotificateWithOptions:(NSDictionary *)launchOptions
{
    //JPush
    BOOL isNoti = [[NSUserDefaults standardUserDefaults] boolForKey:KNotification];
    
    if (isNoti) {
//        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                       UIRemoteNotificationTypeSound |
//                                                       UIRemoteNotificationTypeAlert)
//                                           categories:nil];
//        [APService setupWithOption:launchOptions];
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    
}
- (void)isNightModel{
    
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
    
//    [ShareSDK registerApp:@"4b78d3a1baa7"];
//    [ShareSDK importWeChatClass:[WXApi class]];

}

//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url wxDelegate:self];
//}

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
//}

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
//    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [APService handleRemoteNotification:userInfo];
    //NSLog(@"收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
//    [APService handleRemoteNotification:userInfo];
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
//    [APService showLocalNotificationAtFront:notification identifierKey:nil];
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

#pragma mark ADViewControllerDelegate
- (void)privacyPolicyPopViewExit{
    
    [self exitApplication];

}
- (void)exitApplication {
     
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
     
    [UIView animateWithDuration:0.35f animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
     
}

@end
