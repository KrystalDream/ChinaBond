//
//  CBFeedSuccessView.m
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBFeedSuccessView.h"

@implementation CBFeedSuccessView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        
    }
    return self;
}

- (void)createUI
{
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = .5;
    [self addSubview:shadow];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-235)/2, 189, 235, 125)];
    contentView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    contentView.layer.cornerRadius = 5;
    [self addSubview:contentView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(83, 13, 69, 60)];
    imageView.dk_imagePicker = DKImageWithNames(@"iconfont-xinxi", @"iconfont-xinxi_night");
    [contentView addSubview:imageView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 235, 13)];
    label1.font = [UIFont fontWithName:@"PingFang SC" size:12];
    label1.textColor = UIColorFromRGB(0x323232);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"已提交!";
    [contentView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 103, 235, 13)];
    label2.font = [UIFont fontWithName:@"PingFang SC" size:12];
    label2.textColor = UIColorFromRGB(0x323232);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"感谢您的反馈";
    [contentView addSubview:label2];
}

@end
