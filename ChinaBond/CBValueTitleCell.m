//
//  CBValueTitleCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBValueTitleCell.h"

@implementation CBValueTitleCell

+(CBValueTitleCell *)valueTitleCell
{
    CBValueTitleCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBValueTitleCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.sectionView.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    
    self.sectionLineOne.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x1e1e1e);
    
    self.sectionLineTwo.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x1e1e1e);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
