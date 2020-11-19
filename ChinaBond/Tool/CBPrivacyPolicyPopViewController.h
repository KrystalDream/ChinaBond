//
//  JSBChannelPopViewController.h
//  jieshuibao
//
//  Created by 邵梦 on 2019/6/22.
//  Copyright © 2019年 com.jieshuibao1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnClickBlock)(void);
typedef void(^leftBtnClickBlock)(void);

@interface CBPrivacyPolicyPopViewController : UIViewController

+ (instancetype)shareInstance;

- (void)initViewWithTitle:(NSString *)title subTilte:(NSString *)subTitle rightBtnTitle:(NSString *)btnTitle BtnBlock:(BtnClickBlock)btnClickBlock;

- (void)initViewWithTitle:(NSString *)title subTilte:(NSString *)subTitle leftBtnTitle:(NSString *)leftBtnTitle leftBtnBlock:(leftBtnClickBlock)leftBtnBlock rightBtnTitle:(NSString *)btnTitle BtnBlock:(BtnClickBlock)btnClickBlock;

- (void)initViewWithTitle:(NSString *)title subAttributedTilte:(NSAttributedString *)subAttributedTitle rightBtnTitle:(NSString *)btnTitle BtnBlock:(BtnClickBlock)btnClickBlock;
@property (nonatomic, strong) UIButton *cancleBtn;

@end
