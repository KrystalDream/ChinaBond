//
//  CBMessageShareView.m
//  ChinaBond
//
//  Created by wangran on 15/12/9.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBMessageShareView.h"

@interface CBMessageShareView()



@end
@implementation CBMessageShareView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x323232);
        
        CGFloat gap = (SCREEN_WIDTH-49*3)/4;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, SCREEN_WIDTH-20, 18)];
        label.text = @"分享到";
        label.dk_textColorPicker = DKColorWithRGB(0x808080, 0x8c8c8c);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFang SC" size:18];
        [self addSubview:label];
        
        NSArray *nameArr = @[@"新浪微博",@"微信好友",@"朋友圈"];
        
        for (int i=0; i<3; i++) {
            
            UIImageView *shareImage = [[UIImageView alloc] initWithFrame:CGRectMake(gap*(i+1)+49*i, 46, 49, 49)];
            shareImage.dk_imagePicker = DKImageWithNames([NSString stringWithFormat:@"share_%d",i],
                                                         [NSString stringWithFormat:@"share_night_%d",i]);
            [self addSubview:shareImage];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(gap*(i+1)+49*i, 46, 49, 49);
            //[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"share_%d",i]] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            UILabel *shareLab = [[UILabel alloc] initWithFrame:CGRectMake(gap*(i+1)+49*i, 105, 49, 13)];
            shareLab.text = nameArr[i];
            //shareLab.adjustsFontSizeToFitWidth = YES;
            shareLab.textAlignment = NSTextAlignmentCenter;
            shareLab.dk_textColorPicker = DKColorWithRGB(0x262626, 0x8c8c8c);
            shareLab.font = [UIFont fontWithName:@"PingFang SC" size:10];
            [self addSubview:shareLab];
            
        }
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 1)];
        line1.dk_backgroundColorPicker = DKColorWithRGB(0xcbcccd, 0x262626);
        [self addSubview:line1];
        
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, 146, 50, 31)];
        if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
            switchButton.on = YES;
        }
        else
        {
            switchButton.on = NO;
        }
        switchButton.dk_onTintColorPicker = DKColorWithRGB(0x4dd964, 0x5b731e);
        [switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:switchButton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, 183, 70, 18)];
        imageView.image = [UIImage imageNamed:@"model"];
        [self addSubview:imageView];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 216, SCREEN_WIDTH, 1)];
        line2.dk_backgroundColorPicker = DKColorWithRGB(0xcbcccd, 0x262626);
        [self addSubview:line2];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 230, SCREEN_WIDTH-20, 15)];
        [cancelButton dk_setTitleColorPicker:DKColorWithRGB(0x808080, 0x8c8c8c) forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
    return self;
}

-(void)shareButtonClick:(UIButton *)sender
{
    [self.delegate shareButtonClick:sender.tag];
}

- (void)switchButtonClick:(UISwitch *)sender
{
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal) {
        [DKNightVersionManager nightFalling];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KNightModel];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [DKNightVersionManager dawnComing];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KNightModel];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
}

- (void)cancelButtonClick
{
    [self.delegate cancelBtnClick];
}

@end
