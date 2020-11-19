//
//  CBadController.m
//  ChinaBond
//
//  Created by wangran on 16/1/27.
//  Copyright © 2016年 chinaBond. All rights reserved.
//

#import "CBadController.h"
#import <AFURLSessionManager.h>
#import "CBFileController.h"
@interface CBadController ()<UIWebViewDelegate>

@end

@implementation CBadController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.title = @"中国债券信息网";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.infoUrl]];
    [webView loadRequest:request];
    
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        webView.opaque = NO;
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#000000‘"];
    }
    else
    {
        webView.opaque = YES;
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#ffffff‘"];
    }
    
    [self.view addSubview:webView];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString containsString:@"download="]) {
        
        [webView stopLoading];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL.absoluteString];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                         progress:nil
                                                                      destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                          
                                                                          NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                                          return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                          
                                                                      }
                                                                completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                    
                                                                    CBFileController *file = [[CBFileController alloc] init];
                                                                    file.fileUrl = filePath;
                                                                    [self.navigationController pushViewController:file animated:YES];
                                                                    
                                                                    
                                                                }];
        
        [downloadTask resume];
        
    }
    return YES;
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

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
