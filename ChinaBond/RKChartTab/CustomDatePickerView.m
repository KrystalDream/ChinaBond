//
//  CustomDatePickerView.m
//  DayDatePicker
//
//  Created by XiaobinJia on 15/12/13.
//  Copyright (c) 2015年 Hugh Bellamy. All rights reserved.
//

#import "CustomDatePickerView.h"
#import "DayDatePickerView.h"

@interface CustomDatePickerView()<DayDatePickerViewDataSource, DayDatePickerViewDelegate>


@property (strong, nonatomic) DayDatePickerView *picker;
@property (strong,nonatomic)NSDate *selectedDate;

@end

@implementation CustomDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    self.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 36)];
    titleLabel.dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x323232);
    titleLabel.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x8c8c8c);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"选择日期";
    [self addSubview:titleLabel];
    
    _picker = [[DayDatePickerView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+36, self.bounds.size.width, 134)];
    _picker.backgroundColor = [UIColor clearColor];
    [self stupDatePicker];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, self.bounds.size.height-38, self.bounds.size.width/2, 38);
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x323232);
    [cancelButton dk_setTitleColorPicker:DKColorWithRGB(0x6d6d6d, 0x8c8c8c) forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height-38, self.bounds.size.width/2, 38);
    [sureButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.dk_backgroundColorPicker = DKColorWithRGB(0xff4e4e, 0x98312f);
    [sureButton dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0x8c8c8c) forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self addSubview:sureButton];
}

-(void)stupDatePicker
{
    self.picker.delegate = self; //1: SET DELEGATE (optional)
    self.picker.dataSource = self; //2: SET DATA SOURCE (optional)
    [self.picker setup]; //3: CALL - [DayDatePickerView setup] (NOT optional)
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day  = 0;
    offsetComponents.month  = 0;
    offsetComponents.year  = -20;
    self.picker.minimumDate = [calendar dateByAddingComponents:offsetComponents toDate:today options:0]; //4: SET MINIMUM DATE (optional)
    //For Maximum Date
    offsetComponents.day  = 0;
    offsetComponents.month  = 0;
    offsetComponents.year  = 0;
    self.picker.maximumDate = [calendar dateByAddingComponents:offsetComponents toDate:today options:0]; //5: SET MINIMUM DATE (optional)
    self.picker.date = today; //6: SET DATE (NOT optional)
    [self addSubview:_picker];
}

#pragma function

-(void)cancel:(UIButton*)button
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}

-(void)sure:(UIButton*)button
{
    __block NSString* dateString = [self stringFromDate:_selectedDate];
    if (self.sureBlock) {
        self.sureBlock(dateString);
    }
    [self removeFromSuperview];
}


- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
#pragma DatePickerDelegate
- (void)dayDatePickerView:(DayDatePickerView *)dayDatePickerView didSelectDate:(NSDate *)date {
    self.selectedDate= date;
}

- (CGFloat)selectionViewOpacityForDayDatePickerView:(DayDatePickerView *)dayDatePickerView {
    return 0.5;
}

@end
