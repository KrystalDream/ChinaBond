//
//  CBFocusDetailController.h
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBFocusDetailController : UIViewController
@property (nonatomic, strong) NSDictionary *infoDic;//资讯相关信息
@property (nonatomic, strong) NSString *tId;//资讯所属id
@property (nonatomic, strong) NSString *infoUrl;//资讯url
@property (nonatomic, strong) NSString *titleS;//资讯title
@end
