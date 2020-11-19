//
//  CBFontSetView.h
//  ChinaBond
//
//  Created by wangran on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBFontViewDelegate <NSObject>

- (void)hideFontView;

@end

@interface CBFontSetView : UIView

@property (nonatomic, strong) id<CBFontViewDelegate> delegate;

@end
