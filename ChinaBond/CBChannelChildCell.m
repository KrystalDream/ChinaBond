//
//  CBChannelChildCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/6.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBChannelChildCell.h"

@implementation CBChannelChildCell
+(CBChannelChildCell *)channelChildCell
{
    CBChannelChildCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBChannelChildCell" owner:self options:nil] objectAtIndex:0];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
    self.channelChildName.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
