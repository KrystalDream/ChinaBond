//
//  CBZNSearchResultCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/4.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBZNSearchResultCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *resultTitle;
@property (strong, nonatomic) IBOutlet UILabel *resultTime;
@property (strong, nonatomic) IBOutlet UILabel *resultSource;
+(CBZNSearchResultCell *)searchResultCell;
@end
