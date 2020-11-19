//
//  CBThreeLevelButton.m
//  ChinaBond
//
//  Created by wangran on 15/12/8.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBThreeLevelButton.h"

@implementation CBThreeLevelButton

- (void)drawRect:(CGRect)rect {
    
    self.titleLabel.font = Font(14);
    //[self dk_setTitleColorPicker:DKColorWithRGB(0x868686, 0x7f7f7f) forState:UIControlStateNormal];
    
}

//-(void)setSelected:(BOOL)selected
//{
//    if (selected) {
//        [self dk_setTitleColorPicker:DKColorWithRGB(0xfd8d38, 0xd47b37) forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self dk_setTitleColorPicker:DKColorWithRGB(0x868686, 0x7f7f7f) forState:UIControlStateNormal];
//    }
//}


@end
