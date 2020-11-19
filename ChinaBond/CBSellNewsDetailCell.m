//
//  CBSellNewsDetailCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/9.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBSellNewsDetailCell.h"

@implementation CBSellNewsDetailCell
+(CBSellNewsDetailCell *)sellNewsDetailCell
{
    CBSellNewsDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBSellNewsDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
    
    self.detailName.dk_textColorPicker = DKColorWithRGB(0x868686, 0x8c8c8c);
    self.detailContent.dk_textColorPicker = DKColorWithRGB(0x868686, 0x8c8c8c);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
