//
//  CBSellNewsCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/8.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSellNewsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *newsTypeImage;
@property (strong, nonatomic) IBOutlet UILabel *newsName;
@property (strong, nonatomic) IBOutlet UIView *lineView;
+(CBSellNewsCell *)sellNewsCell;
@end
