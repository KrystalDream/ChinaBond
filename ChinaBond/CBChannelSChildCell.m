//
//  CBChannelSChildCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/25.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBChannelSChildCell.h"

@implementation CBChannelSChildCell
+(CBChannelSChildCell *)channelSChildCell
{
    CBChannelSChildCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBChannelSChildCell" owner:self options:nil] objectAtIndex:0];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
