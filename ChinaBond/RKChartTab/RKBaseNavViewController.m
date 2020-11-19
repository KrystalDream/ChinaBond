//
//  RKBaseNavViewController.m
//  ChinaBond
//
//  Created by Jiaxiaobin on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "RKBaseNavViewController.h"
#import "RKChartViewController.h"

@interface RKBaseNavViewController ()

@end

@implementation RKBaseNavViewController

- (id)init
{
    RKChartViewController *dataVC = [[RKChartViewController alloc] init];
    
    UIImage *dataImage = [UIImage imageNamed:@"tab_data"];
    dataImage = [dataImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *dataImageSel = [UIImage imageNamed:@"tab_data_select"];
    dataImageSel = [dataImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    dataVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"中债数据" image:dataImage selectedImage:dataImageSel];
    
    if (self = [self initWithRootViewController:dataVC]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - 横竖屏－base nav的设置
- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
