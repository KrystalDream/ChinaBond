//
//  CBSellNewsDetailTitleCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/8.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBSellNewsDetailTitleCell.h"

@implementation CBSellNewsDetailTitleCell
+(CBSellNewsDetailTitleCell *)sellNewsDetailTitleCell
{
    CBSellNewsDetailTitleCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBSellNewsDetailTitleCell" owner:self options:nil] objectAtIndex:0];
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
