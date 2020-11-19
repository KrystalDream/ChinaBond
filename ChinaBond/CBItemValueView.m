//
//  CBItemValueView.m
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBItemValueView.h"

@interface CBItemValueView()

@property (nonatomic, strong) NSDictionary *tmpDic;

@end

@implementation CBItemValueView

-(instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dataDic
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x333333);
        _tmpDic = dataDic;
        
        UIImageView *shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-15, 0, 15, 15)];
        shadowImage.image = [UIImage imageNamed:@"home_shadow"];
        [self addSubview:shadowImage];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 17)];
        name.font = Font(15);
        name.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
        name.text = dataDic[@"zqjc"];
        [self addSubview:name];

        UILabel *jingJiaLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 25, 13)];
        jingJiaLab.font = Font(12);
        jingJiaLab.dk_textColorPicker = DKColorWithRGB(0x5abef8, 0x2690ce);
        jingJiaLab.text = @"净价";
        [self addSubview:jingJiaLab];
        
        UILabel *jingJiaValue = [[UILabel alloc] initWithFrame:CGRectMake(35, 34, frame.size.width-10-35, 20)];
        jingJiaValue.dk_textColorPicker = DKColorWithRGB(0x5abef8, 0x2690ce);
        jingJiaValue.font = Font(22);
        jingJiaValue.textAlignment = NSTextAlignmentRight;
        jingJiaValue.text = dataDic[@"gzjz"];
        [self addSubview:jingJiaValue];
        
        UILabel *year = [[UILabel alloc] initWithFrame:CGRectMake(10, 58, frame.size.width-20, 10)];
        year.dk_textColorPicker = DKColorWithRGB(0x5abef8, 0x2690ce);
        year.font = Font(11);
        year.textAlignment = NSTextAlignmentRight;
        year.text = [NSString stringWithFormat:@"%@年",dataDic[@"dcq"]];
        [self addSubview:year];
        
        UILabel *percent = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, frame.size.width-20, 10)];
        percent.dk_textColorPicker = DKColorWithRGB(0x5abef8, 0x2690ce);
        percent.font = Font(11);
        percent.textAlignment = NSTextAlignmentRight;
        percent.text = [NSString stringWithFormat:@"%@%@",dataDic[@"gzsyl"],@"%"];
        [self addSubview:percent];
    }
    return self;
}

@end
