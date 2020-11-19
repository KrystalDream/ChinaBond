//
//  CBUserHeadCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/11.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBUserHeadCell.h"

@implementation CBUserHeadCell
+(CBUserHeadCell *)userHeadCell
{
    CBUserHeadCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBUserHeadCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self.userAvatar.layer.cornerRadius = 25;
    self.userAvatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
