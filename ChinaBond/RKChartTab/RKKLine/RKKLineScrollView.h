//
//  RKKLineScrollView.h
//  ChinaBond
//
//  Created by Jiaxiaobin on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RKKLineScrollViewDelegate <NSObject>
//CAL线两端文字的实时显示
@required
- (void)refreshCalTextOfXCorrectValue:(CGFloat)xCorrectValue YCorrectValue:(CGFloat)yCorrectValue;
- (void)addCalVerTextLayerOfXInView:(CGFloat)xInView;
- (void)refreshCalVerTextLayerOfXInView:(CGFloat)xInView;
- (void)addCalHorTextLayerOfYInView:(CGFloat)yInView;
- (void)refreshCalHorTextLayerOfYInView:(CGFloat)yInView;
- (void)removeCalTextLayer;
//双击事件的回调
- (void)kLineDoubleClicked;
//双击后放大的倍数
- (CGFloat)kLineScaleNum;
//添加和刷新Layer
- (void)addMovingKLineLayer:(CALayer *)layer;
- (void)removeMovingKLineLayer:(CALayer *)layer;


@end

@interface RKKLineScrollView : UIScrollView

//用于绘制曲线
@property (assign, nonatomic) CGPoint originPoint;
@property (assign, nonatomic) CGPoint leftTopPoint;
@property (assign, nonatomic) CGPoint rightBottomPoint;
@property (strong, nonatomic) NSArray *dataSource;

@property (assign, nonatomic) CGFloat xMinValue;//x轴上原点的x值
@property (assign, nonatomic) CGFloat yMinValue;//y轴上原点的y值
@property (assign, nonatomic) CGFloat xMaxValue;//x轴上最右边点上的x值
@property (assign, nonatomic) CGFloat yMaxValue;//y轴上最上边点的y值

@property (weak, nonatomic) id<RKKLineScrollViewDelegate> kLineDelegate;
- (void)refreshKLine;

@end
