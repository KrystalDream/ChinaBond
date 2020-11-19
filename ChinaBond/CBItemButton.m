//
//  CBItemButton.m
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBItemButton.h"
#import <UIButton+WebCache.h>

@implementation CBItemButton

@synthesize itemButton = _itemButton,itemLabel = _itemLabel;

-(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)imageStr andTitle:(NSString *)title andIndex:(int)index andDic:(NSDictionary *)dic
{
    self = [self initWithFrame:frame];
    if (self) {
        
        _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemButton.frame = CGRectMake((frame.size.width-53)/2, 5, 53, 53);
        _itemButton.layer.cornerRadius = 10;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, 32, 32);
        imageView.center = _itemButton.center;
        [self addSubview:imageView];
        
        if (index<4) {
            [_itemButton sd_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]] forState:UIControlStateNormal];
          
        }
        else
        {
            if ([title isEqualToString:@"添加自定义"]) {
                [_itemButton setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            }
            else
            {
                if (index==4) {
                    _itemButton.backgroundColor = UIColorFromRGB(0xfd8d38);
                }
                if (index == 5) {
                    _itemButton.backgroundColor = UIColorFromRGB(0x2ac382);
                }
                if (index == 6) {
                    _itemButton.backgroundColor = UIColorFromRGB(0xc261ff);
                }
                NSString *name = [self zhuanhua:dic[@"parentName"]];
                imageView.image = [UIImage imageNamed:[name stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
        }
        
        
        [_itemButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_itemButton];
        [self bringSubviewToFront:imageView];
        
        _itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, frame.size.width, 15)];
       
        if ([title isEqualToString:@"添加自定义"]) {
       
            _itemLabel.text = @"";
        
        }
        else
        {
            _itemLabel.text = title;
        }
        
        _itemLabel.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x999999);
        _itemLabel.font = [UIFont systemFontOfSize:12];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_itemLabel];
        
    }
    return self;
}

-(NSString *)zhuanhua:(NSString *)str
{
    NSString *string = [[NSString alloc] init];
    if ([str length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            string = ms;
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            string = ms;
        }  
    } 

    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (void)buttonClick:(UIButton *)sender
{
    self.clickBlock(self.tag);
}

@end
