//
//  RKExponentViewController.h
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    RKExponentPageTypeChoice = 0, // 0 单列或者双列
    RKExponentPageTypeInfoPage = 1,
}RKExponentPageType;

@class RKExponentViewController;
@class RKCateLevelModel;

@protocol RKExponentChoiceDelegate <NSObject>
@required
- (void)exponentPage:(RKExponentViewController *)page didChoiceData:(RKCateLevelModel *)choice;

@end

@interface RKExponentViewController : UIViewController
@property (nonatomic, assign) RKExponentPageType pageType;
@property (nonatomic, assign) id<RKExponentChoiceDelegate> delegate;
@end
