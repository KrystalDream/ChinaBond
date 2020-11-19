//
//  CBZQSearchCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/4.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBZQSearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *zqTitle;
@property (strong, nonatomic) IBOutlet UIButton *zqDelete;
+(CBZQSearchCell *) zqSearchCell;
@end
