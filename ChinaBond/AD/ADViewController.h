//
//  ADViewController.h
//  ChinaBond
//
//  Created by Krystal on 2021/1/11.
//  Copyright © 2021 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ADViewControllerDelegate <NSObject>

- (void)privacyPolicyPopViewExit;
//- (void)privacyPolicyPopViewAgree;



@end

@interface ADViewController : UIViewController
@property (nonatomic, weak) id<ADViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
