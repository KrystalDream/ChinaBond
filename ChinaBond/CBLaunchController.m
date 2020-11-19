//
//  CBLaunchController.m
//  ChinaBond
//
//  Created by wangran on 15/12/24.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBLaunchController.h"

@interface CBLaunchController ()

@end

@implementation CBLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    self.navigationController.navigationBarHidden = YES;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zhongzhaiGai" ofType:@"gif"];
    
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    webViewBG.userInteractionEnabled = NO;
    
    [self.view addSubview:webViewBG];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
