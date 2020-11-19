//
//  RKExponentView.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKExponentView.h"
#import "RKExponentTopModel.h"

typedef enum {
    RKSegmentStateLeft = 0,
    RKSegmentStateRight = 1

}RKSegmentState;

#define RKButtonColor           [UIColor colorWithRed:212/255.0 green:211/255.0 blue:216/255.0 alpha:1.0]
#define RKButtonColorSelected   [UIColor colorWithRed:98/255.0 green:167/255.0 blue:242/255.0 alpha:1.0]

@implementation RKExponentView
{
    RKSegmentState _segmentState;
    NSArray *_dataArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 255);
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/2+50, 45);
        leftButton.tag = 12401;
        leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [leftButton setTitle:@"财富指数" forState:UIControlStateNormal];
        [leftButton dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
        leftButton.dk_backgroundColorPicker = DKColorWithRGB(0x23a8f5, 0x2979a7);
        [leftButton addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(leftButton.frame.size.width, 0, SCREEN_WIDTH/2-50, 45);
        rightButton.tag = 12402;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightButton dk_setTitleColorPicker:DKColorWithRGB(0x323232, 0x323232) forState:UIControlStateNormal];
        [rightButton setTitle:@"净价指数" forState:UIControlStateNormal];
        rightButton.dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0xa8a8a8);
        [rightButton addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        
        _segmentState = RKSegmentStateLeft;
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd日"];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45+10, SCREEN_WIDTH, 14)];
        timeLabel.text = [NSString stringWithFormat:@"更新时间:%@",[format stringFromDate:[NSDate date]]];
        timeLabel.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x404040);
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:timeLabel];
        
        self.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        
        float widthDip = (SCREEN_WIDTH-20)/3;
        for (int i=0;i<6;i++) {
            RKNumberView *view = [[RKNumberView alloc] initWithFrame:CGRectMake(10+(widthDip)*i, 79, widthDip-1, 73)];
            view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
            view.tag = 12500+i;
            
            if (i>2) {
                view.frame = CGRectMake(10+widthDip*(i-3), 79+74+5, widthDip-1, 73);
            }
            [self addSubview:view];
        }
        
        UIView *gapLine = [[UIView alloc] initWithFrame:CGRectMake(0, 245, SCREEN_WIDTH, 10)];
        gapLine.dk_backgroundColorPicker = DKColorWithRGB(0xeff0f4, 0x0f0f0f);
        [self addSubview:gapLine];
    }
    return self;
}

- (void)segmentClicked:(UIButton *)sender
{
    if (sender.tag == 12401) {
        if (_segmentState == RKSegmentStateLeft) {
            return;
        }
        self.type = RKExponentViewTypeLeft;
        _segmentState = RKSegmentStateLeft;
        ((UIButton *)[self viewWithTag:12401]).dk_backgroundColorPicker = DKColorWithRGB(0x23a8f5, 0x2979a7);
        [(UIButton *)[self viewWithTag:12401] dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
        ((UIButton *)[self viewWithTag:12401]).frame = CGRectMake(0, 0, SCREEN_WIDTH/2+50, 45);
        ((UIButton *)[self viewWithTag:12402]).frame = CGRectMake(((UIButton *)[self viewWithTag:12401]).frame.size.width, 0, SCREEN_WIDTH/2-50, 45);
        ((UIButton *)[self viewWithTag:12402]).dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0xa8a8a8);
        [((UIButton *)[self viewWithTag:12402]) dk_setTitleColorPicker:DKColorWithRGB(0x323232, 0x323232) forState:UIControlStateNormal];
    }else{
        if (_segmentState == RKSegmentStateRight) {
            return;
        }
        self.type = RKExponentViewTypeRight;
        _segmentState = RKSegmentStateRight;
        ((UIButton *)[self viewWithTag:12401]).dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0xa8a8a8);
        [((UIButton *)[self viewWithTag:12401]) dk_setTitleColorPicker:DKColorWithRGB(0x323232, 0x323232) forState:UIControlStateNormal];
        ((UIButton *)[self viewWithTag:12401]).frame = CGRectMake(0, 0, SCREEN_WIDTH/2-50, 45);
        ((UIButton *)[self viewWithTag:12402]).frame = CGRectMake(((UIButton *)[self viewWithTag:12401]).frame.size.width, 0, SCREEN_WIDTH/2+50, 45);
        ((UIButton *)[self viewWithTag:12402]).dk_backgroundColorPicker = DKColorWithRGB(0x23a8f5, 0x2979a7);
        [(UIButton *)[self viewWithTag:12402] dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
    }
    sender.dk_backgroundColorPicker = DKColorWithRGB(0x23a8f5, 0x2979a7);
    [sender dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
    
    [self configDataWithArray:_dataArray];
}

- (void)configDataWithArray:(NSArray *)arr
{
    NSMutableArray *confirmArray = [NSMutableArray arrayWithArray:arr];
    if ([arr count]<6) {
        for (int i=0; i<6-[arr count]; i++) {
            RKExponentTopModel *model = [[RKExponentTopModel alloc] init];
            model.topNameTMD = @"";
            model.topcfzsTMD = @"";
            model.topcfzszdfTMD = @"";
            model.topjjzsTMD = @"";
            model.topjjzszdfTMD = @"";
            [confirmArray addObject:model];
        }
    }
    if (_dataArray != confirmArray) {
        _dataArray = confirmArray;
    }
    for (int i=12500; i<12506; i++) {
        RKExponentTopModel *model = [_dataArray objectAtIndex:i-12500];
        RKNumberView *view = [self viewWithTag:i];
        [view configDataWithTitle:model.topNameTMD
                             data:(self.type == RKExponentViewTypeLeft)?model.topcfzsTMD:model.topjjzsTMD
                             rate:(self.type == RKExponentViewTypeLeft)?model.topcfzszdfTMD:model.topjjzszdfTMD];
    }
}

- (void)drawRect:(CGRect)rect {
    float width = (SCREEN_WIDTH-20)/3;
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(context, 10, 153);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),SCREEN_WIDTH-10, 153);
    
    CGContextMoveToPoint(context, 10+width, 79);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),10+width, 235);
    
    CGContextMoveToPoint(context, 10+width*2, 79);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 10+width*2, 235);
    
    CGContextMoveToPoint(context, 0, 245);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), SCREEN_WIDTH, 245);
    CGContextStrokePath(context);
}


@end


@implementation RKNumberView
{
    UILabel *_titleLabel;
    UILabel *_dataLabel;
    UILabel *_rateLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, frame.size.width-4, 34)];
        _titleLabel.text = @"中债-公司信用类债券指数";
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
        [self addSubview:_titleLabel];
        
        _dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4+30+10, frame.size.width, 11)];
        _dataLabel.text = @"101.4419";
        _dataLabel.font = [UIFont systemFontOfSize:13];
        _dataLabel.backgroundColor = [UIColor clearColor];
        _dataLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dataLabel];
        
        _rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4+30+10+11+4, frame.size.width, 11)];
        _rateLabel.text = @"-0.0321%";
        _rateLabel.font = [UIFont systemFontOfSize:13];
        _rateLabel.backgroundColor = [UIColor clearColor];
        _rateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rateLabel];
    }
    return self;
}

- (void)configDataWithTitle:(NSString *)title data:(NSString *)data rate:(NSString *)rate
{
//    NSString *newTitle = nil;
//    if ([title hasPrefix:@"中债-"]) {
//        newTitle = [title substringFromIndex:3];
//    }else{
//        newTitle = title;
//    }
    _titleLabel.text = title;
    
    NSString *newData = nil;
    NSRange range = [data rangeOfString:@"."];
    if (range.location>0 && [data length]>range.location+5) {
        newData = [data substringToIndex:range.location+5];
    }else{
        newData = data;
    }
    _dataLabel.text = newData;
    
    NSString *newRate = nil;
    NSRange rangeRate = [rate rangeOfString:@"."];
    if (rangeRate.location>0 && [rate length]>rangeRate.location+5) {
        newRate = [rate substringToIndex:rangeRate.location+5];
    }else{
        newRate = rate;
    }
    if (![newRate isEqualToString:@""]) {
        _rateLabel.text = [NSString stringWithFormat:@"%@%%",newRate];
    }else{
        _rateLabel.text = @"";
    }
    
    if (![rate hasPrefix:@"-"]) {
        [self configTextColor:[UIColor colorWithRed:222/255.0 green:79/255.0 blue:79/255.0 alpha:1.0]];
    }else{
        [self configTextColor:[UIColor colorWithRed:0/255.0 green:193/255.0 blue:127/255.0 alpha:1.0]];
    }
    
}

- (void)configTextColor:(UIColor *)color;
{
    _titleLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    _dataLabel.textColor = color;
    _rateLabel.textColor = color;
}
@end
