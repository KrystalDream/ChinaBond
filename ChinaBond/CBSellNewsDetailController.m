//
//  CBSellNewsDetailController.m
//  ChinaBond
//
//  Created by wangran on 15/12/8.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBSellNewsDetailController.h"
#import "CBSellNewsDetailTitleCell.h"
#import "CBSellNewsDetailCell.h"
#import "CBMessageShareView.h"

@interface CBSellNewsDetailController ()<UITableViewDataSource,UITableViewDelegate,CBMessageShareDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) CBMessageShareView *shareView;
@end

@implementation CBSellNewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //navigationbar
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发行快报详情";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;

    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClick)];
    
    self.navigationItem.rightBarButtonItem = rightButton1;
    
//    NSString *zqjc = [NSString stringWithFormat:@"%@",self.infoDic[@"zqjc"]];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
//    NSString *str = [zqjc stringByAddingPercentEscapesUsingEncoding:enc];
    NSString *url = [NSString stringWithFormat:@"https://www.chinabond.com.cn/jsp/mb/kbcontent.jsp?zqdm=%@",self.infoDic[@"zqdm"]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //webView.scrollView.scrollEnabled = NO;
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        webView.opaque = NO;
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#000000‘"];
    }
    else
    {
        webView.opaque = YES;
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#ffffff‘"];
    }
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [webView reload];
    [self.view addSubview:webView];
    
    self.shadowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0.5;
    self.shadowView.hidden = YES;
    [self.view addSubview:self.shadowView];
    
    self.shareView = [[CBMessageShareView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257)];
    self.shareView.delegate = self;
    [self.view addSubview:self.shareView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(void)shareButtonClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
            
            break;
        case 1:
            break;
        case 2:
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

@end
