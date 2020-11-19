//
//  RKExponentView.h
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RKExponentViewTypeLeft,
    RKExponentViewTypeRight
} RKExponentViewType;

@interface RKNumberView : UIView
- (void)configDataWithTitle:(NSString *)title data:(NSString *)data rate:(NSString *)rate;
- (void)configTextColor:(UIColor *)color;
@end

@interface RKExponentView : UIView
@property (nonatomic, assign) RKExponentViewType type;
- (void)configDataWithArray:(NSArray *)arr;
@end
