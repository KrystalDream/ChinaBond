//
//  CBSearchController.m
//  ChinaBond
//
//  Created by wangran on 15/12/4.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBSearchController.h"
#import "CBZNSearchController.h"
#import "CBZQSearchController.h"

@interface CBSearchController ()

@property (nonatomic, strong) UIButton *znSearch;//站内搜索button
@property (nonatomic, strong) UIButton *zqSearch;//债券搜索button

@property (nonatomic, strong) CBZNSearchController *znSearchVC;//站内搜索vc
@property (nonatomic, strong) CBZQSearchController *zqSearchVC;//债券搜索vc

@end

@implementation CBSearchController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configueNac];
    
    self.znSearchVC = [[CBZNSearchController alloc] init];
    [self addChildViewController:self.znSearchVC];
    
    [self.view addSubview:self.znSearchVC.view];
    
    self.zqSearchVC = [[CBZQSearchController alloc] init];
    [self addChildViewController:self.zqSearchVC];
    
    [self.view addSubview:self.zqSearchVC.view];
    
    [self.view bringSubviewToFront:self.znSearchVC.view];
}

//配置导航栏
- (void)configueNac
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 28)];
    self.navigationItem.titleView = titleView;
    
    self.znSearch = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 81, 28)];
    self.znSearch.layer.cornerRadius = 2;
    self.znSearch.layer.borderWidth = 1.;
    self.znSearch.layer.borderColor = UIColorFromRGB(0xe53d3d).CGColor;
    [self.znSearch setTitle:@"站内搜索" forState:UIControlStateNormal];
    self.znSearch.titleLabel.font = Font(14);
    [self.znSearch dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
    self.znSearch.dk_backgroundColorPicker = DKColorWithRGB(0xe53d3d, 0x963232);
    [self.znSearch addTarget:self action:@selector(searchButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.znSearch];
    
    self.zqSearch = [[UIButton alloc] initWithFrame:CGRectMake(79, 0, 81, 28)];
    self.zqSearch.layer.cornerRadius = 2;
    self.zqSearch.layer.borderWidth = 1.;
    self.zqSearch.layer.borderColor = UIColorFromRGB(0xe53d3d).CGColor;
    [self.zqSearch setTitle:@"债券查询" forState:UIControlStateNormal];
    self.zqSearch.titleLabel.font = Font(14);
    [self.zqSearch dk_setTitleColorPicker:DKColorWithRGB(0xe53d3d, 0x963232) forState:UIControlStateNormal];
    self.zqSearch.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0xbebebe);
    [self.zqSearch addTarget:self action:@selector(searchButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.zqSearch];
}

#pragma mark - button click method

- (void)searchButtonclick:(UIButton *)sender
{
    if (sender == self.znSearch) {
        
        self.zqSearch.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0xbebebe);
        [self.zqSearch dk_setTitleColorPicker:DKColorWithRGB(0xe53d3d, 0x963232) forState:UIControlStateNormal];
        
        self.znSearch.dk_backgroundColorPicker = DKColorWithRGB(0xe53d3d, 0x963232);
        [self.znSearch dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
        
        [self.view bringSubviewToFront:self.znSearchVC.view];
        
    }
    else
    {
        self.znSearch.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0xbebebe);
        [self.znSearch dk_setTitleColorPicker:DKColorWithRGB(0xe53d3d, 0x963232) forState:UIControlStateNormal];
        
        self.zqSearch.dk_backgroundColorPicker = DKColorWithRGB(0xe53d3d, 0x963232);
        [self.zqSearch dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
        
        [self.view addSubview:self.zqSearchVC.view];

    }
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
