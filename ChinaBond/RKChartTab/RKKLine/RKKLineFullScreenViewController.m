//
//  RKKLineFullScreenViewController.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/2.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKKLineFullScreenViewController.h"
#import "RKKLine.h"
#import "RKDataManager.h"

@interface RKKLineFullScreenViewController () <RKKLineDelegate>

@end

@implementation RKKLineFullScreenViewController

- (void)dealloc
{
    [[self.view viewWithTag:1001] removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *dataSource = [NSMutableArray array];
    
    NSArray *xArr  = @[@0.5, @3,   @5,   @9,   @15,  @20,  @30,  @50];
    NSArray *yArr  = @[@1.0, @1.5, @2.0, @2.5, @3.0, @3.5, @4.0, @4.5];
    NSArray *value = @[@1.6, @2.0, @2.6, @2.3, @3.0, @2.8, @3.7, @4.2];
    
    for (int i=0; i< 8; i++) {
        CGPoint point = CGPointMake([xArr[i] doubleValue], [value[i] doubleValue]);
        [dataSource addObject:[NSValue valueWithCGPoint:point]];
    }
    
    CGRect rect = CGRectMake(0, 0,
                             self.view.bounds.size.height, self.view.bounds.size.width);
    RKDataManager *manager = [RKDataManager sharedInstance];
    RKKLine *kLine = [[RKKLine alloc] initWithFrame:rect xArr:manager.model.xArr yArr:manager.model.yArr];
    kLine.tag = 1001;
    [self.view addSubview:kLine];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doubleClickedWithKLine:(RKKLine *)kLine
{
    
    [self.navigationController popViewControllerAnimated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
