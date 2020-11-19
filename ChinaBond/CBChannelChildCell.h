//
//  CBChannelChildCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/6.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBChannelChildCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *channelChildName;
@property (strong, nonatomic) IBOutlet UIButton *channelChildAddBtn;
@property (strong, nonatomic) IBOutlet UIImageView *channelAdd;
@property (strong, nonatomic) IBOutlet UIImageView *channelArrow;
+(CBChannelChildCell *)channelChildCell;
@end
