//
//  CBProductDetailCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/21.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBProductDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productTime;
@property (strong, nonatomic) IBOutlet UIView *lineView;
+(CBProductDetailCell *)productDetailCell;
@end
