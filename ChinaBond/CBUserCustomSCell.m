//
//  CBUserCustomSCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBUserCustomSCell.h"

@implementation CBUserCustomSCell
+(CBUserCustomSCell *)userCustomCell
{
    CBUserCustomSCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBUserCustomSCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
    
    self.userCustomSwitch.dk_onTintColorPicker = DKColorWithRGB(0x4dd964, 0x5b731e);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
