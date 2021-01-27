//
//  RKValuationFooterView.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/5.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKValuationFooterView.h"

@interface RKValuationFooterView()
@property (nonatomic, strong) NSString *telStr;

@end

@implementation RKValuationFooterView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    NSDictionary *dic = [CBCacheManager shareCache].phoneDic;
    
    UIView *garyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    garyView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x0f0f0f);
    [self addSubview:garyView];
    
    UILabel *labelLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 30)];
    labelLine1.backgroundColor = [UIColor clearColor];
    labelLine1.font = [UIFont systemFontOfSize:15];
    labelLine1.textAlignment = NSTextAlignmentCenter;
    labelLine1.text = @"更多数据请拨打订购电话";
    labelLine1.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x8c8c8c);
    [self addSubview:labelLine1];
    
    UILabel *labelLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 11+30, SCREEN_WIDTH, 30)];
    labelLine2.backgroundColor = [UIColor clearColor];
    labelLine2.font = [UIFont systemFontOfSize:15];
    labelLine2.textAlignment = NSTextAlignmentCenter;
    labelLine2.dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x595959);
    labelLine2.text = dic[@"varPhone"];
    labelLine2.userInteractionEnabled = YES;
    [self addSubview:labelLine2];
    
    self.telStr = labelLine2.text;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(telTap)];
    [labelLine2 addGestureRecognizer:tap];
    
    UILabel *labelLine3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 11+30+30, SCREEN_WIDTH, 30)];
    labelLine3.backgroundColor = [UIColor clearColor];
    labelLine3.font = [UIFont systemFontOfSize:15];
    labelLine3.textAlignment = NSTextAlignmentCenter;
    labelLine3.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x8c8c8c);
    labelLine3.text = @"估值业务咨询";
    [self addSubview:labelLine3];
    
    UILabel *labelLine4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 11+30+30+30, SCREEN_WIDTH, 30)];
    labelLine4.backgroundColor = [UIColor clearColor];
    labelLine4.font = [UIFont systemFontOfSize:15];
    labelLine4.textAlignment = NSTextAlignmentCenter;
    labelLine4.dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x595959);
    labelLine4.text = dic[@"varQueryPhone"];
   
    [self addSubview:labelLine4];
}
- (void)telTap{
    
    CBLog(@"%s",__func__);
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telStr];

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];

}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);//抗锯齿
    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:228/255.0 green:226/255.0  blue:232/255.0  alpha:1.0].CGColor);
//    CGContextSetLineWidth(context, 22);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), SCREEN_WIDTH, 0);
//    CGContextStrokePath(context);
    
    //实线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200/255.0 green:200/255.0  blue:200/255.0  alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, 10, 11+30+1+30);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),SCREEN_WIDTH-10, 11+30+1+30);
    CGContextStrokePath(context);
    
    //虚线
    CGFloat dashPattern[]= {1.5, 3};
    CGContextSetLineDash(context, 0.0, dashPattern, 2); //虚线效果
    CGContextMoveToPoint(context, 10, 11+30);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), SCREEN_WIDTH-10, 11+30);
    
    //虚线
    CGContextMoveToPoint(context, 10, 11+30+1+30+1+30);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), SCREEN_WIDTH-10, 11+30+1+30+1+30);
    CGContextStrokePath(context);
}

@end
