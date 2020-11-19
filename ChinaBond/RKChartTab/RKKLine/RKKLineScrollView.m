//
//  RKKLineScrollView.m
//  ChinaBond
//
//  Created by Jiaxiaobin on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "RKKLineScrollView.h"
#import "RKKLine.h"

@interface RKKLineScrollView ()

@property UIBezierPath *linePath;//曲线Path对象

@property (retain, nonatomic) CAShapeLayer* lineLayer;
@property (retain, nonatomic) CAShapeLayer* fillLayer;

@property (retain, nonatomic) CAShapeLayer *calVerLayer;//竖向的标准线
@property (retain, nonatomic) CAShapeLayer *calHorLayer;//横向的标准线
@property (retain, nonatomic) CALayer *crossingLayer;

@end

@implementation RKKLineScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(kLineLongPressed:)];
        longGesture.minimumPressDuration = .5;
        [self addGestureRecognizer:longGesture];
        
        UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kLineDoubleClicked:)];
        doubleGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleGesture];
    }
    return self;
}

- (void)refreshKLine
{
    //刷新ScrollView
    [self.lineLayer removeFromSuperlayer];
    [self.fillLayer removeFromSuperlayer];
    /////////////////////// 根据数据源画折线 /////////////////////////
    self.linePath = [UIBezierPath bezierPath];
    UIBezierPath* fillPath = [UIBezierPath bezierPath];
    if (self.dataSource && self.dataSource.count > 1) {
        for (NSInteger i = 0; i < self.dataSource.count-1; i++) {
            CGPoint startPoint = [self positionWithIndex:i];
            CGPoint endPoint = [self positionWithIndex:i+1];
            
            if(i > 0) {
                [self.linePath addLineToPoint:endPoint];
                [fillPath addLineToPoint:endPoint];
            } else {
                [self.linePath moveToPoint:startPoint];
                [self.linePath addLineToPoint:endPoint];
                [fillPath moveToPoint:startPoint];
                [fillPath addLineToPoint:endPoint];
            }
        }
    }
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.lineLayer.bounds = self.bounds;
    self.lineLayer.path = self.linePath.CGPath;
    self.lineLayer.strokeColor = RKLineColor.CGColor;
    self.lineLayer.fillColor = nil;
    self.lineLayer.lineWidth = 1;
    self.lineLayer.lineJoin = kCALineJoinRound;
    
    
    [fillPath addLineToPoint:self.rightBottomPoint];
    [fillPath addLineToPoint:self.originPoint];
    
    self.fillLayer = [CAShapeLayer layer];
    self.fillLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.fillLayer.bounds = self.bounds;
    self.fillLayer.path = fillPath.CGPath;
    self.fillLayer.strokeColor = nil;
    self.fillLayer.fillColor = RKFillColor.CGColor;
    self.fillLayer.lineWidth = 0;
    self.fillLayer.lineJoin = kCALineJoinRound;
    //[self.layer addSublayer:self.lineLayer];
    //[self.layer addSublayer:self.fillLayer];
    [self.kLineDelegate addMovingKLineLayer:self.lineLayer];
    [self.kLineDelegate addMovingKLineLayer:self.fillLayer];
}

#pragma mark - XY坐标系和视图坐标系的对应
- (CGFloat)xValueOfXInViewPosition:(CGFloat)xInView
{
    CGFloat sitePercent = (xInView-self.originPoint.x)/(self.rightBottomPoint.x-self.originPoint.x);
    CGFloat totalInValue = self.xMaxValue - self.xMinValue;
    CGFloat xValue = sitePercent *totalInValue;
    return xValue;
}
- (CGFloat)xInViewPositionOfXValue:(CGFloat)xValue
{
    CGFloat sitePercent = (xValue-self.xMinValue)/(self.xMaxValue-self.xMinValue);
    CGFloat totalInView = self.rightBottomPoint.x - self.originPoint.x;
    CGFloat xPosition = self.originPoint.x + sitePercent*totalInView;
    return xPosition;
}
- (CGFloat)yValueOfYInViewPosition:(CGFloat)yInView
{
    CGFloat sitePercent = (yInView-self.originPoint.y)/(self.leftTopPoint.y-self.originPoint.y);
    CGFloat totalInValue = self.yMaxValue - self.yMinValue;
    CGFloat yValue = sitePercent *totalInValue;
    return yValue;
}
- (CGFloat)yInViewPositionOfYValue:(CGFloat)yValue
{
    CGFloat sitePercent = (yValue-self.yMinValue)/(self.yMaxValue-self.yMinValue);
    CGFloat totalInView = self.leftTopPoint.y - self.originPoint.y;
    CGFloat yPosition = self.originPoint.y - sitePercent * fabs(totalInView);
    return yPosition;
}

//获得数据对应的折线上点的位置
- (CGPoint)positionWithIndex:(NSInteger)index
{
    CGPoint point = ((NSValue *)[self.dataSource objectAtIndex:index]).CGPointValue;
    CGFloat xValue  = point.x;
    CGFloat xPosition = [self xInViewPositionOfXValue:xValue];
    CGFloat yValue = point.y;
    CGFloat yPosition = [self yInViewPositionOfYValue:yValue];
    return CGPointMake(xPosition, yPosition);
}
#pragma mark - 手势交互
- (void)kLineDoubleClicked:(UITapGestureRecognizer *)sender
{
    if (self.kLineDelegate && [self.kLineDelegate respondsToSelector:@selector(kLineDoubleClicked)]) {
        [self.kLineDelegate kLineDoubleClicked];
    }
}

- (void)kLineLongPressed:(UILongPressGestureRecognizer *)sender
{
    CGPoint locationPoint = [sender locationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (locationPoint.x<self.originPoint.x || locationPoint.x>self.rightBottomPoint.x) {
            return;
        }
        if (locationPoint.y>self.originPoint.y || locationPoint.y<self.leftTopPoint.y) {
            return;
        }
        //添加竖向CAL线，精确到个位
        //根据self.xDataSource 找到此x值在value坐标系中对应的y值
        CGFloat xValue = [self xValueOfXInViewPosition:locationPoint.x];
        //找到该值应该对应的坐标系中整数，目前只对应到整数
        CGFloat xValueAfterCorrect = [self correctXValue:xValue];
        //找到矫正之后的值对应的坐标系位置
        CGFloat xInView = [self xInViewPositionOfXValue:xValueAfterCorrect];
        //画出矫正之后的竖向CAL线
        [self addCalVerLineOfXInView:xInView];
        
        //获得测量轴与曲线的交叉点
        CGPoint crossingPoint = [self pointCrossingOfXValue:xValueAfterCorrect];//这里必须传入矫正之后的值,返回的crossingPoint是Value值，不是InView值
        CGFloat yInView = [self yInViewPositionOfYValue:crossingPoint.y];
        
        //添加测量轴的横线
        [self addCalHorLineOfYInView:yInView];
        //添加交叉点UI显示
        [self addCrossingPointWithXInView:xInView andYInView:yInView];
        
        //刷新两条CAL线文字
        [self.kLineDelegate refreshCalTextOfXCorrectValue:crossingPoint.x YCorrectValue:crossingPoint.y];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        if (locationPoint.x<self.originPoint.x || locationPoint.x>self.rightBottomPoint.x) {
            return;
        }
        if (locationPoint.y>self.originPoint.y || locationPoint.y<self.leftTopPoint.y) {
            return;
        }
        CGPoint locationPoint = [sender locationInView:sender.view];
        //刷新横竖测量轴的位置
        
        CGFloat xValue = [self xValueOfXInViewPosition:locationPoint.x];
        //找到该值应该对应的坐标系中整数，目前只对应到整数
        CGFloat xValueAfterCorrect = [self correctXValue:xValue];
        //找到矫正之后的值对应的坐标系位置
        CGFloat xInView = [self xInViewPositionOfXValue:xValueAfterCorrect];
        //画出矫正之后的竖向CAL线
        [self refreshCalVerLineOfXInView:xInView];
        
        //获得测量轴与曲线的交叉点
        CGPoint crossingPoint = [self pointCrossingOfXValue:xValueAfterCorrect];//这里必须传入矫正之后的值,返回的crossingPoint是Value值，不是InView值
        CGFloat yInView = [self yInViewPositionOfYValue:crossingPoint.y];
        
        //刷新测量轴的横线
        [self refreshCalHorLineOfYInView:yInView];
        //刷新交叉点
        [self refreshCrossingPointWithXInView:xInView andYInView:yInView];
        
        //刷新两条CAL线文字
        [self.kLineDelegate refreshCalTextOfXCorrectValue:crossingPoint.x YCorrectValue:crossingPoint.y];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [self.calVerLayer removeFromSuperlayer];
        [self.calHorLayer removeFromSuperlayer];
        [self.crossingLayer removeFromSuperlayer];
        [self.kLineDelegate removeCalTextLayer];
    }
}

#pragma mark - 交叉点查找和x值矫正
//得到触摸点与曲线的交点，这个交点是根据datasource的值算出来的，不是纯粹的layer表示的图像交点
- (CGPoint)pointCrossingOfXValue:(CGFloat)xValue
{
    __block CGFloat yValue = 0;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((NSValue *)obj).CGPointValue.x == xValue) {
            *stop = YES;
            yValue = ((NSValue *)obj).CGPointValue.y;
        }
    }];
    return CGPointMake(xValue, yValue);
}
//x值矫正
- (CGFloat)correctXValue:(CGFloat)xValue
{
    int ret = xValue;
    int xTmp = (int)xValue;
    if (xValue-xTmp>0.5 || xValue-xTmp==0.5) {
        ret = xTmp+1;
    }else{
        ret = xTmp;
    }
    return ret;
}

- (void)addCrossingPointWithXInView:(CGFloat)xInView andYInView:(CGFloat)yInView
{
    self.crossingLayer = [[CALayer alloc] init];
    self.crossingLayer.frame = CGRectMake(xInView-4, yInView-4, 8, 8);
    self.crossingLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.crossingLayer.cornerRadius = 4.0;
    CALayer *crossingContentLayer = [[CALayer alloc] init];
    crossingContentLayer.frame = CGRectMake(1, 1, 6, 6);
    crossingContentLayer.backgroundColor = [UIColor colorWithRed:240/255.0 green:83/255.0 blue:64/255.0 alpha:1.0].CGColor;
    crossingContentLayer.cornerRadius = 3.0;
    [self.crossingLayer addSublayer:crossingContentLayer];
    [self.layer addSublayer:self.crossingLayer];
}

- (void)refreshCrossingPointWithXInView:(CGFloat)xInView andYInView:(CGFloat)yInView
{
    [CATransaction setDisableActions:YES];
    self.crossingLayer.frame = CGRectMake(xInView-4, yInView-4, 8, 8);
    [CATransaction setDisableActions:YES];
}
#pragma mark - 竖向CAL线的绘制
- (void)addCalVerLineOfXInView:(CGFloat)xInView
{
    UIBezierPath* calLinePath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(xInView, self.rightBottomPoint.y);
    CGPoint endPoint = CGPointMake(xInView, self.leftTopPoint.y);
    
    [calLinePath moveToPoint:startPoint];
    [calLinePath addLineToPoint:endPoint];
    
    self.calVerLayer = [CAShapeLayer layer];
    self.calVerLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.calVerLayer.bounds = self.bounds;
    self.calVerLayer.path = calLinePath.CGPath;
    self.calVerLayer.strokeColor = RKCalLineColor.CGColor;
    self.calVerLayer.fillColor = nil;
    self.calVerLayer.lineWidth = 1;
    self.calVerLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.calVerLayer];
    
    //添加竖向CAL线底端文字
    [self.kLineDelegate addCalVerTextLayerOfXInView:xInView];
}
- (void)refreshCalVerLineOfXInView:(CGFloat)xInView
{
    UIBezierPath* calLinePath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(xInView, self.rightBottomPoint.y);
    CGPoint endPoint = CGPointMake(xInView, self.leftTopPoint.y);
    
    [calLinePath moveToPoint:startPoint];
    [calLinePath addLineToPoint:endPoint];
    
    self.calVerLayer.path    = calLinePath.CGPath;
    
    //刷新竖向CAL线底端文字
    [self.kLineDelegate refreshCalVerTextLayerOfXInView:xInView];
}
#pragma mark - 横向CAL线的绘制
- (void)addCalHorLineOfYInView:(CGFloat)yInView
{
    UIBezierPath* calLinePath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(self.rightBottomPoint.x, yInView);
    CGPoint endPoint = CGPointMake(self.leftTopPoint.x, yInView);
    
    [calLinePath moveToPoint:startPoint];
    [calLinePath addLineToPoint:endPoint];
    
    self.calHorLayer = [CAShapeLayer layer];
    self.calHorLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.calHorLayer.bounds = self.bounds;
    self.calHorLayer.path = calLinePath.CGPath;
    self.calHorLayer.strokeColor = RKCalLineColor.CGColor;
    self.calHorLayer.fillColor = nil;
    self.calHorLayer.lineWidth = 1;
    self.calHorLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.calHorLayer];
    
    //添加横向CAL线左边文字
    [self.kLineDelegate addCalHorTextLayerOfYInView:yInView];
}
- (void)refreshCalHorLineOfYInView:(CGFloat)yInView
{
    UIBezierPath* calLinePath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(self.rightBottomPoint.x, yInView);
    CGPoint endPoint = CGPointMake(self.leftTopPoint.x, yInView);
    
    [calLinePath moveToPoint:startPoint];
    [calLinePath addLineToPoint:endPoint];
    
    self.calHorLayer.path = calLinePath.CGPath;
    
    //添加横向CAL线底端文字
    [self.kLineDelegate refreshCalHorTextLayerOfYInView:yInView];
    
}

@end
