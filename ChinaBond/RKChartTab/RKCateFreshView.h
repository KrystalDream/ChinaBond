//
//  RKCateFreshView.h
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/4.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKCateLevelModel.h"

@class RKCateFreshView;

@protocol RKCateFreshViewDelegate <NSObject>
- (void)freshViewDidRefresh:(RKCateFreshView *)view;
- (void)freshViewSelectModel:(RKCateLevelModel *)model;
@end

@interface RKCateFreshView : UIView
@property (nonatomic, weak) id<RKCateFreshViewDelegate> delegate;
- (CGFloat)heightOfCurrent;
- (void)resetWithData:(NSArray *)data;
@end
