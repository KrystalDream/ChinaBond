//
//  CBFontSetView.m
//  ChinaBond
//
//  Created by wangran on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBFontSetView.h"
#import "CBCacheManager.h"

@interface CBFontSetView()

@property (nonatomic, strong) UISlider *slider;

@end

@implementation CBFontSetView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        shadow.backgroundColor = [UIColor blackColor];
        shadow.alpha = .6;
        [self addSubview:shadow];
        
        UIView *fontView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150-168, SCREEN_WIDTH, 168)];
        fontView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x323232);
        [self addSubview:fontView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH-20, 19)];
        label.font = [UIFont fontWithName:@"PingFang SC" size:18];
        label.text = @"字体设置";
        label.textAlignment = NSTextAlignmentCenter;
        label.dk_textColorPicker = DKColorWithRGB(0x808080, 0x8c8c8c);
        [fontView addSubview:label];
        
        UILabel *xiao = [[UILabel alloc] initWithFrame:CGRectMake(42, 59, 15, 15)];
        xiao.font = [UIFont fontWithName:@"PingFang SC" size:15];
        xiao.dk_textColorPicker = DKColorWithRGB(0x808080, 0x8c8c8c);
        xiao.text = @"小";
        [fontView addSubview:xiao];
        
        UILabel *zhong = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-15)/2, 59, 15, 15)];
        zhong.font = [UIFont fontWithName:@"PingFang SC" size:15];
        zhong.dk_textColorPicker = DKColorWithRGB(0x808080, 0x8c8c8c);
        zhong.text = @"中";
        [fontView addSubview:zhong];
        
        UILabel *da = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-42-15, 59, 15, 15)];
        da.font = [UIFont fontWithName:@"PingFang SC" size:15];
        da.dk_textColorPicker = DKColorWithRGB(0x808080, 0x8c8c8c);
        da.text = @"大";
        [fontView addSubview:da];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 97, SCREEN_WIDTH-100, 1)];
        line.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x484848);
        [fontView addSubview:line];
        
        //滑块设置
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(38, 85, SCREEN_WIDTH-76 , 24)];
        _slider.minimumValue = 1;
        _slider.maximumValue = 3;
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        
        NSString *fontStr = [[NSUserDefaults standardUserDefaults] objectForKey:KWebFont];
        
        if ([fontStr isEqualToString:@"70%"]) {
            [_slider setValue:1.0];
        }
        else if ([fontStr isEqualToString:@"100%"])
        {
            [_slider setValue:2.0];
        }
        else if ([fontStr isEqualToString:@"130%"])
        {
            [_slider setValue:3.0];
        }
        
        UIImage *thumbImage = nil;
        
        if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
            thumbImage = [UIImage imageNamed:@"slider_night"];
        }
        else
        {
            thumbImage = [UIImage imageNamed:@"slider"];
        }
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
        [_slider setThumbImage:thumbImage forState:UIControlStateNormal];

        [fontView addSubview:_slider];
        
        //添加点击手势和滑块滑动事件响应
        [_slider addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventValueChanged];
        
        UIView *longLine = [[UIView alloc] initWithFrame:CGRectMake(0, 127, SCREEN_WIDTH, 1)];
        longLine.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
        [fontView addSubview:longLine];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 138, SCREEN_WIDTH-20, 16);
        button.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [fontView addSubview:button];
    }
    return self;
}

- (void)valueChanged:(UISlider *)sender
{
    //只取整数值，固定间距
    NSString *tempStr = [self numberFormat:sender.value];
    [sender setValue:tempStr.floatValue];
    
    if (tempStr.intValue == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"70%" forKey:KWebFont];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (tempStr.intValue == 2)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"100%" forKey:KWebFont];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (tempStr.intValue == 3)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"130%" forKey:KWebFont];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)cancelButtonClick
{
    [self.delegate hideFontView];
}

/**
 *  四舍五入
 *
 *  @param num 待转换数字
 *
 *  @return 转换后的数字
 */
- (NSString *)numberFormat:(float)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

@end
