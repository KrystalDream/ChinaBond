//
//  CBUerCustomCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/11.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBUerCustomCell.h"

@implementation CBUerCustomCell
+(CBUerCustomCell *)userCustomCell
{
    CBUerCustomCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBUerCustomCell" owner:self options:nil] objectAtIndex:0];
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
