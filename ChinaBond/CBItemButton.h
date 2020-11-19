//
//  CBItemButton.h
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^itemButtonClickBlock)(NSInteger tag);

@interface CBItemButton : UIView

@property (strong, nonatomic) UIButton *itemButton;
@property (strong, nonatomic) UILabel *itemLabel;
@property (strong, nonatomic) itemButtonClickBlock clickBlock;

-(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)imageStr andTitle:(NSString *)title andIndex:(int)index andDic:(NSDictionary *)dic;

@end
