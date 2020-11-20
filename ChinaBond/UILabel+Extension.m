//
//  UILabel+Extension.m
//  jieshuibao
//
//  Created by 张恭豪 on 2019/8/15.
//  Copyright © 2019 com.jieshuibao1. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (void)changeLineSpaceWithSpace:(float)space {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

- (void)changeWordSpaceWithSpace:(float)space {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

- (void)changeSpaceWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}


+ (UILabel *)labelWithFont:(UIFont * __nullable)font textColor:(UIColor * __nullable)textColor{
    return [self labelWithFont:font textColor:textColor text:nil];
}

/**
 快速设置Label常用属性

 @param font 字体
 @param textColor 颜色
 @param text 文字
 @return UILabel
 */
+ (UILabel *)labelWithFont:(UIFont * __nullable)font textColor:(UIColor * __nullable)textColor text:(NSString * __nullable)text{
    
    UILabel *label  = [[UILabel alloc] init];
    
    if (font) label.font = font;
    if (textColor) label.textColor = textColor;
    if (text) label.text = text;
    
    return label;
}


@end
