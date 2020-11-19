//
//  CBFirstLevelButton.m
//  ChinaBond
//
//  Created by wangran on 15/12/7.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBFirstLevelButton.h"

@implementation CBFirstLevelButton

- (void)drawRect:(CGRect)rect {
    
    self.titleLabel.font = Font(15);
//    [self dk_setTitleColorPicker:DKColorWithRGB(0x4c4c4c, 0x999999) forState:UIControlStateNormal];
}

//-(void)setSelected:(BOOL)selected
//{
//    if (selected) {
////        [self dk_setTitleColorPicker:DKColorWithRGB(0xd64848, 0xad4343) forState:UIControlStateNormal];
//        if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
//            [self setBackgroundImage:[UIImage imageNamed:@"firstLevel_night"] forState:UIControlStateNormal];
//        }
//        else
//        {
//           [self setBackgroundImage:[UIImage imageNamed:@"firstLevel"] forState:UIControlStateNormal];
//        }
//    }
//    else
//    {
////        [self dk_setTitleColorPicker:DKColorWithRGB(0x4c4c4c, 0x999999) forState:UIControlStateNormal];
//        [self setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    }
//}

@end
