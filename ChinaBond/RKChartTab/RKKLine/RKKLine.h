//
//  SportLineChartContentView.h
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RKNumberColor   [UIColor colorWithRed:(float)96/255 green:(float)96/255 blue:(float)96/255 alpha:1.0]
#define RKLineColor     [UIColor colorWithRed:(float)151/255 green:(float)151/255 blue:(float)151/255 alpha:1.0]
#define RKCalLineColor  [UIColor colorWithRed:(float)0/255 green:(float)0/255 blue:(float)0/255 alpha:1.0]
#define RKXYlineColor   [DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal ? UIColorFromRGB(0xf6f6fb):UIColorFromRGB(0x252525)
#define RKFillColor     [DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal ? UIColorFromRGB(0xe9e8ed):UIColorFromRGB(0x1f1f1f)

@protocol RKKLineDelegate;

@interface RKKLine : UIView
@property (nonatomic, assign) id<RKKLineDelegate> kLineDelegate;
@property (assign, nonatomic) BOOL canScale;//缩放开关

//构造函数，必须使用
- (id)initWithFrame:(CGRect)frame
               xArr:(NSArray *)xArr
               yArr:(NSArray *)yArr;
- (void)refreshFrame:(CGRect)frame;
@end

@protocol RKKLineDelegate <NSObject>

@required
- (void)kLine:(id)kLine refreshDataWithX:(CGFloat)x andY:(CGFloat)y;
- (void)kLineDidTapClicked:(id)kLine;
- (void)kLineDidDoubleTapClicked:(id)kLine;
@end