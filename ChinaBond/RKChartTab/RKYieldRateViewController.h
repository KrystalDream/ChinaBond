//
//  RKYieldRateViewController.h
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    RKYieldRatePageTypeChoice = 0, // 0 单列或者双列
    RKYieldRatePageTypeInfoPage = 1,
}RKYieldRatePageType;

@class RKRateInfoModel;
@class RKYieldRateViewController;

@protocol RKYieldChoiceDelegate <NSObject>
@required
- (void)yieldRatePage:(RKYieldRateViewController *)page didChoiceData:(RKRateInfoModel *)choice;

@end

@interface RKYieldRateViewController : UIViewController
@property (nonatomic, assign) RKYieldRatePageType pageType;
@property (nonatomic, assign) id<RKYieldChoiceDelegate> delegate;
@end
