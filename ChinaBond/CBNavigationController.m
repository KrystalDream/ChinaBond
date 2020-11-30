//
//  CBNavigationController.m
//  ChinaBond
//
//  Created by wangran on 15/11/30.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBNavigationController.h"

@interface CBNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"中国债券信息网";
    //设置title字体颜色、字号
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
       
       NSForegroundColorAttributeName:UIColorFromRGB(0xe53d3d)}];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    [self setGes];
}

- (void)setGes
{
    self.fSGesEnabled = YES;
    
    id target = self.interactivePopGestureRecognizer.delegate;
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (!self.fSGesEnabled) {
        return NO;
    }
    
    if ([self topViewController] != self.visibleViewController) {
        return NO;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 横竖屏－仅竖屏
- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
@end
