//
//  CBTaskTipHeadCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/22.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTaskTipHeadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
+(CBTaskTipHeadCell *)taskTipsHeadCell;
@end
