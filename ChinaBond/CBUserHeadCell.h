//
//  CBUserHeadCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/11.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUserHeadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;

+(CBUserHeadCell *)userHeadCell;
@end
