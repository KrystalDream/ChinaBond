//
//  CBFocusCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBFocusCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIImageView *foucsImage;
@property (strong, nonatomic) IBOutlet UILabel *newsForm;
@property (strong, nonatomic) IBOutlet UIView *lineView;
+(CBFocusCell *)focusCell;
@end
