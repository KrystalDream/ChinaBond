//
//  CBMyCollectController.m
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBMyCollectController.h"
#import "CBCollectionController.h"
#import "CBProductController.h"
#import "CBSearchController.h"

@interface CBMyCollectController ()

@property (nonatomic, strong) UIButton *collection;
@property (nonatomic, strong) UIButton *product;

@property (nonatomic, strong) CBCollectionController *collectVC;
@property (nonatomic, strong) CBProductController *productVC;

@end

@implementation CBMyCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self configueNac];
    
    self.productVC = [[CBProductController alloc] init];
    [self addChildViewController:self.productVC];
    
    [self.view addSubview:self.productVC.view];
    
    self.collectVC = [[CBCollectionController alloc] init];
    [self addChildViewController:self.collectVC];
    
    [self.view addSubview:self.collectVC.view];
    
    [self.view bringSubviewToFront:self.collectVC.view];
}

//配置导航栏
- (void)configueNac
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 28)];
    self.navigationItem.titleView = titleView;
    
    self.collection = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 81, 28)];
    self.collection.layer.cornerRadius = 2;
    self.collection.layer.borderWidth = 1.;
    self.collection.layer.borderColor = UIColorFromRGB(0xe53d3d).CGColor;
    [self.collection setTitle:@"我的收藏" forState:UIControlStateNormal];
    self.collection.titleLabel.font = Font(14);
    [self.collection setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.collection.backgroundColor = UIColorFromRGB(0xe53d3d);
    [self.collection addTarget:self action:@selector(Buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.collection];
    
    self.product = [[UIButton alloc] initWithFrame:CGRectMake(79, 0, 81, 28)];
    self.product.layer.cornerRadius = 2;
    self.product.layer.borderWidth = 1.;
    self.product.layer.borderColor = UIColorFromRGB(0xe53d3d).CGColor;
    [self.product setTitle:@"我的产品" forState:UIControlStateNormal];
    self.product.titleLabel.font = Font(14);
    [self.product setTitleColor:UIColorFromRGB(0xe53d3d) forState:UIControlStateNormal];
    self.product.backgroundColor = [UIColor whiteColor];
    [self.product addTarget:self action:@selector(Buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.product];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - button click method

- (void)Buttonclick:(UIButton *)sender
{
    if (sender == self.collection) {
        
        self.product.backgroundColor = [UIColor whiteColor];
        [self.product setTitleColor:UIColorFromRGB(0xe53d3d) forState:UIControlStateNormal];
        
        self.collection.backgroundColor = UIColorFromRGB(0xe53d3d);
        [self.collection setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.view bringSubviewToFront:self.collectVC.view];
        
    }
    else
    {
        self.collection.backgroundColor = [UIColor whiteColor];
        [self.collection setTitleColor:UIColorFromRGB(0xe53d3d) forState:UIControlStateNormal];
        
        self.product.backgroundColor = UIColorFromRGB(0xe53d3d);
        [self.product setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.view addSubview:self.productVC.view];
        
    }
}

- (void)rightButtonClick
{
    CBSearchController *search = [[CBSearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
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
