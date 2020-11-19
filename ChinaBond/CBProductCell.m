//
//  CBProductCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBProductCell.h"

@implementation CBProductCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    self.productName.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
    self.productNum.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x242424);
    self.productLevel.dk_textColorPicker = DKColorWithRGB(0xffffff, 0xbebebe);
}

@end
