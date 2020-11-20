//
//  RKTabBarViewController.m
//  ChinaBond
//
//  Created by Jiaxiaobin on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "RKTabBarViewController.h"
#import "RKBaseNavViewController.h"
#import "CBNavigationController.h"
#import "UITabBar+badge.h"
#import "CBHomeController.h"
#import "CBMessageController.h"
#import "CBUserManageController.h"


@interface RKTabBarViewController ()

@end

@implementation RKTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeView];
}
- (void)makeView{
    
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
    
    self.viewControllers = @[homeNav,
                            [[RKBaseNavViewController alloc] init],
                            messagenav,
                            userNav];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 横竖屏－base tab的设置
- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
@end
