//
//  CBFocusCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBFocusCell.h"

@implementation CBFocusCell
+(CBFocusCell *)focusCell
{
    CBFocusCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBFocusCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    
//    self.titleLab.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
//    self.timeLab.dk_textColorPicker = DKColorWithRGB(0xBEBEBE, 0x404040);
//    self.newsForm.dk_textColorPicker = DKColorWithRGB(0xA8A8A8, 0x404040);
//    self.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xD9D9D9, 0x242424);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
