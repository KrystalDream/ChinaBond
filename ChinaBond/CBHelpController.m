//
//  CBHelpController.m
//  ChinaBond
//
//  Created by wangran on 16/1/6.
//  Copyright © 2016年 chinaBond. All rights reserved.
//

#import "CBHelpController.h"

@interface CBHelpController ()

@end

@implementation CBHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"帮助说明";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xEBECF1, 0x0f0f0f);
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        webView.opaque = NO;
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#000000‘"];
    }
    else
    {
        webView.opaque = YES;
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#ffffff‘"];
    }
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.chinabond.com.cn/jsp/mb/bzsm.jsp"]]];
    
    [self.view addSubview:webView];
}
- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
