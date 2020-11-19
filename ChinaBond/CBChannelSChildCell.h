//
//  CBChannelSChildCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/25.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBChannelSChildCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *channelAddButton;
@property (strong, nonatomic) IBOutlet UILabel *channelName;
+(CBChannelSChildCell *)channelSChildCell;
@end
