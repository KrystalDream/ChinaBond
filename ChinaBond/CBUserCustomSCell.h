//
//  CBUserCustomSCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUserCustomSCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userCustomImage;
@property (strong, nonatomic) IBOutlet UILabel *userCustomLab;
@property (strong, nonatomic) IBOutlet UISwitch *userCustomSwitch;
@property (strong, nonatomic) IBOutlet UIView *lineView;
+(CBUserCustomSCell *)userCustomCell;
@end
