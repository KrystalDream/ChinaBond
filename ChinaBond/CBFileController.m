//
//  CBFileController.m
//  ChinaBond
//
//  Created by wangran on 16/1/12.
//  Copyright © 2016年 chinaBond. All rights reserved.
//

#import "CBFileController.h"

@interface CBFileController ()<UIWebViewDelegate>

@end

@implementation CBFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    UIWebView *fileWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //fileWeb.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.fileUrl];
    [fileWeb loadRequest:request];
    [self.view addSubview:fileWeb];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
