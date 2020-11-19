//
//  CSWebView.h
//  ChinaBond
//
//  Created by 邵梦 on 2020/11/9.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSWebView : UIViewController
@property (nonatomic, strong) NSDictionary *infoDic;//资讯相关信息
@property (nonatomic, strong) NSString *tId;//资讯所属id
@property (nonatomic, strong) NSString *infoUrl;//资讯url
@property (nonatomic, strong) NSString *titleS;//资讯title

@end

NS_ASSUME_NONNULL_END
