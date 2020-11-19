//
//  RKTimeKLine.h
//  ChinaBond
//
//  Created by Jiaxiaobin on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKKLine.h"

@interface RKTimeKLine : UIView
@property (nonatomic, assign) id<RKKLineDelegate> kLineDelegate;
@property (assign, nonatomic) BOOL canScale;//缩放开关

//构造函数，必须使用
- (id)initWithFrame:(CGRect)frame
               xArr:(NSArray *)xArr
               yArr:(NSArray *)yArr;
@end
