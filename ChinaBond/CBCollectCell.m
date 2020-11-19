//
//  CBCollectCell.m
//  ChinaBond
//
//  Created by wangran on 16/1/26.
//  Copyright © 2016年 chinaBond. All rights reserved.
//

#import "CBCollectCell.h"

@implementation CBCollectCell
+(CBCollectCell *)collectCell
{
    CBCollectCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBCollectCell" owner:self options:nil] objectAtIndex:0];
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
