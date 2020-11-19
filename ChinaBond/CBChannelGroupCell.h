//
//  CBChannelGroupCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/6.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBChannelGroupCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *channelGroupName;
@property (strong, nonatomic) IBOutlet UIButton *channelGroupAdd;
@property (strong, nonatomic) IBOutlet UIImageView *channelGroupState;
+(CBChannelGroupCell *)channelGroupCell;
@end
