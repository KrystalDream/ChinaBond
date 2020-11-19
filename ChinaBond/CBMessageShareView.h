//
//  CBMessageShareView.h
//  ChinaBond
//
//  Created by wangran on 15/12/9.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBMessageShareDelegate <NSObject>

- (void)shareButtonClick:(NSInteger)tag;
- (void)cancelBtnClick;

@end

@interface CBMessageShareView : UIView
@property (nonatomic, strong) id<CBMessageShareDelegate> delegate;
@end
