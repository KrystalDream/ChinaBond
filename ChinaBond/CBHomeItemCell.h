//
//  CBHomeItemCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBHomeChannelChoseDelegate <NSObject>

- (void) choseChannel:(NSDictionary *)dic;

@end

@interface CBHomeItemCell : UITableViewCell

@property (nonatomic, strong) id<CBHomeChannelChoseDelegate> delegate;

+(CBHomeItemCell *)homeItemCell;

- (void)setItemArr:(NSArray *)arr;

- (void)reloaData;

@end
