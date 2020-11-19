//
//  CBChannelGroupCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/6.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBChannelGroupCell.h"

@implementation CBChannelGroupCell
+(CBChannelGroupCell *)channelGroupCell
{
    CBChannelGroupCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBChannelGroupCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    self.channelGroupName.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
};

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
