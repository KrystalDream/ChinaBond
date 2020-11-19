//
//  CBSearchChannel.h
//  ChinaBond
//
//  Created by wangran on 15/12/4.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBChannelChoseDelegate <NSObject>

- (void)changeChannel:(NSString *)channelName;

@end


@interface CBSearchChannel : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) id<CBChannelChoseDelegate> channelDelegate;

@end

