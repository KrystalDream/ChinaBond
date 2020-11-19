//
//  CBTaskTipHeadCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/22.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBTaskTipHeadCell.h"

@implementation CBTaskTipHeadCell
+(CBTaskTipHeadCell *)taskTipsHeadCell
{
    CBTaskTipHeadCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBTaskTipHeadCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
