//
//  CBValueView.h
//  ChinaBond
//
//  Created by wangran on 15/12/2.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBValueView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
- (void)reloadData:(NSArray *)array;
@end
