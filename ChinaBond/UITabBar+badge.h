//
//  UITabBar+badge.h
//  ChinaBond
//
//  Created by wangran on 15/12/1.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index; //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
