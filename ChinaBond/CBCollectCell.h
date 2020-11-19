//
//  CBCollectCell.h
//  ChinaBond
//
//  Created by wangran on 16/1/26.
//  Copyright © 2016年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCollectCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *newsForm;
@property (strong, nonatomic) IBOutlet UIView *lineView;
+(CBCollectCell *)collectCell;
@end
