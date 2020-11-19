//
//  CBFunction.h
//  ChinaBond
//
//  Created by wangran on 15/11/30.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#ifndef CBFunction_h
#define CBFunction_h
//用户设备系统版本
#define IOS7_OR_LATER                   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER                   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )


//屏幕宽高
#define SCREEN_HEIGHT                    (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])?([[UIScreen mainScreen] bounds].size.width):([[UIScreen mainScreen] bounds].size.height))
#define SCREEN_WIDTH                     (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])?([[UIScreen mainScreen] bounds].size.height):([[UIScreen mainScreen] bounds].size.width))

//RGB值读取颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define Font(F) [UIFont systemFontOfSize:(F)]

#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define CBRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]



//配置2
#define kAppDebug 1

#if kAppDebug
#define CBLog(fmt, ...)                             NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
#define CBLog(...)

#endif

#define SHOW_ALERT(_msg_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];

//键值
#define KNightModel   @"nightModel"
#define KNotification @"notificationS"
#define KDownLoad     @"downLoad"
#define KWebFont      @"webFont"
#define KSearchRecord @"searchRecord"

#endif /* CBFunction_h */
