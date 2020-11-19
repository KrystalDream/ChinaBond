//
//  CBSellNewsDetailCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/9.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSellNewsDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *detailName;
@property (strong, nonatomic) IBOutlet UILabel *detailContent;
@property (strong, nonatomic) IBOutlet UIView *backgroudView;
+(CBSellNewsDetailCell *)sellNewsDetailCell;
@end
