//
//  CustomDatePickerView.h
//  DayDatePicker
//
//  Created by XiaobinJia on 15/12/13.
//  Copyright (c) 2015年 Hugh Bellamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePickerView : UIView

@property (nonatomic,copy)void (^sureBlock)(NSString* timeString);
@property (nonatomic,copy)void (^cancelBlock)();

@end
