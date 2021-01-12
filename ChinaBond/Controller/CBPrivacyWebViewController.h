//
//  CBPrivacyWebViewController.h
//  ChinaBond
//
//  Created by Krystal on 2020/11/20.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPrivacyWebViewController : UIViewController
@property (nonatomic, strong) NSString *localHtmlName;
@property (nonatomic, copy) void (^CBPrivacyWebViewClickBlock) ();
@end

NS_ASSUME_NONNULL_END
