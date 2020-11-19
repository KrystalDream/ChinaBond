//
//  CBProductDetailCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/21.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBProductDetailCell.h"

@implementation CBProductDetailCell
+(CBProductDetailCell *)productDetailCell
{
    CBProductDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBProductDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
    
    self.productName.dk_textColorPicker = DKColorWithRGB(0x252526, 0x8c8c8c);
    self.productTime.dk_textColorPicker = DKColorWithRGB(0x252525, 0x8c8c8c);
    self.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xBCBDBE, 0x1e1c1d);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
