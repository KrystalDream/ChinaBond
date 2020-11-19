//
//  CBSecondLevelButton.m
//  ChinaBond
//
//  Created by wangran on 15/12/7.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBSecondLevelButton.h"

@implementation CBSecondLevelButton

- (void)drawRect:(CGRect)rect {
    
    self.titleLabel.font = Font(14);
    //[self dk_setTitleColorPicker:DKColorWithRGB(0x6d6d6d, 0x7f7f7f) forState:UIControlStateNormal];
    
}

//-(void)setSelected:(BOOL)selected
//{
//    if (selected) {
//        [self dk_setTitleColorPicker:DKColorWithRGB(0xf95e5c, 0xad4343) forState:UIControlStateNormal];
//        self.layer.borderColor = UIColorFromRGB(0xf95e5c).CGColor;
//        self.layer.borderWidth = 1;
//        self.layer.cornerRadius = 3;
//    }
//    else
//    {
//        [self dk_setTitleColorPicker:DKColorWithRGB(0x6d6d6d, 0x7f7f7f) forState:UIControlStateNormal];
//        //[self setTitleColor:UIColorFromRGB(0x6d6d6d) forState:UIControlStateNormal];
//        self.layer.borderWidth = 0;
//    }
//}

@end
