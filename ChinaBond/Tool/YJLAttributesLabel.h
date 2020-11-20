//
//  YJLAttributesLabel.h
//  ChinaBond
//
//  Created by Krystal on 2020/11/20.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJLAttributesLabel : UITextView

/**
 
 @param text 传入富文本类型的字符串
 @param actionText 要响应事件的字符串
 */
- (void)setAttributesText: (NSMutableAttributedString *)text
               actionText: (NSMutableArray *)actionText
              actionRange:(NSMutableArray *)actionrange;

/**
 点击事件回调
 */
@property (nonatomic , copy) void(^YJLAttributesBlock)(NSString *clicktext);


@end

NS_ASSUME_NONNULL_END
