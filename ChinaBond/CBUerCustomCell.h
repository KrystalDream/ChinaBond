//
//  CBUerCustomCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/11.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUerCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userCustomImage;
@property (strong, nonatomic) IBOutlet UILabel *userCustomLab;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrow;
@property (strong, nonatomic) IBOutlet UILabel *rightLab;
@property (strong, nonatomic) IBOutlet UIView *lineView;
+(CBUerCustomCell *)userCustomCell;
@end
