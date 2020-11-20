//
//  UILabel+Extension.h
//  jieshuibao
//
//  Created by 张恭豪 on 2019/8/15.
//  Copyright © 2019 com.jieshuibao1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Extension)

/**
 *  改变行间距
 */
- (void)changeLineSpaceWithSpace:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordSpaceWithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpaceWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;



/**
 快速设置Label常用属性
 
 @param font 字体
 @param textColor 颜色
 @param text 文字
 @return UILabel
 */
+ (UILabel *)labelWithFont:(UIFont * __nullable)font textColor:(UIColor * __nullable)textColor text:(NSString * __nullable)text;
+ (UILabel *)labelWithFont:(UIFont * __nullable)font textColor:(UIColor * __nullable)textColor;

@end

NS_ASSUME_NONNULL_END
