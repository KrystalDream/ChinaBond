//
//  RKRateDetailController.h
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/7.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKRateInfoModel;

@interface RKRateDetailController : UIViewController
@property (nonatomic, retain) IBOutlet UIView *horView;
@property (nonatomic, retain) RKRateInfoModel *rateModel;
@end
