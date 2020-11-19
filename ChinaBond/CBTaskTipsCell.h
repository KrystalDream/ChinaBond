//
//  CBTaskTipsCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/8.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTaskTipsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *taskImage;
@property (strong, nonatomic) IBOutlet UILabel *taskName;
@property (strong, nonatomic) IBOutlet UILabel *taskTime;
@property (strong, nonatomic) IBOutlet UILabel *taskCodeName;
@property (strong, nonatomic) IBOutlet UILabel *taskCode;

+(CBTaskTipsCell *)taskTipsCell;
@end
