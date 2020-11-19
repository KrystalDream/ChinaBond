//
//  RKTimeKLine.m
//  ChinaBond
//
//  Created by Jiaxiaobin on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "RKTimeKLine.h"

#define kRKTimeKLineCalLineWidth 2

@interface RKTimeKLine ()<UIScrollViewDelegate>
@property (retain, nonatomic) NSDateFormatter *dateFormatter;

@property (assign, nonatomic) CGFloat chartScaleNum;
@property (retain, nonatomic) UIScrollView *kLineScrollView;
@property (strong, nonatomic) NSArray *xInputData;
@property (strong, nonatomic) NSArray *yInputData;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *xDataSource;
@property (strong, nonatomic) NSArray *yDataSource;

@property (assign, nonatomic) CGFloat marginLeft;
@property (assign, nonatomic) CGFloat marginBottom;

@property (strong, nonatomic) UIFont *xyTextFont;

@property (assign, nonatomic) CGPoint baseOriginPoint;
@property (assign, nonatomic) CGPoint baseLeftTopPoint;
@property (assign, nonatomic) CGPoint baseRightBottomPoint;

@property (assign, nonatomic) CGFloat baseXMinValue;
@property (assign, nonatomic) CGFloat baseXMaxValue;

@property (assign, nonatomic) CGFloat xMinValue;
@property (assign, nonatomic) CGFloat yMinValue;
@property (assign, nonatomic) CGFloat xMaxValue;
@property (assign, nonatomic) CGFloat yMaxValue;

@property (retain, nonatomic) CALayer *calVerTextLayer;
@property (retain, nonatomic) CALayer *calHorTextLayer;
@property (retain, nonatomic) CATextLayer *calVerTextContentLayer;
@property (retain, nonatomic) CATextLayer *calHorTextContentLayer;

@property (retain, nonatomic) CAShapeLayer *calVerLayer;
@property (retain, nonatomic) CAShapeLayer *calHorLayer;
@property (retain, nonatomic) CALayer *crossingLayer;


@property UIBezierPath *linePath;

@property (retain, nonatomic) CAShapeLayer* lineLayer;
@property (retain, nonatomic) CAShapeLayer* fillLayer;

@property (retain, nonatomic) NSDateFormatter *dayFormatter;
@property (retain, nonatomic) NSDateFormatter *yearFormatter;
@property (retain, nonatomic) NSDateFormatter *monthFormatter;
@property (retain, nonatomic) NSCalendar *myCal;

@end

@implementation RKTimeKLine

- (id)initWithFrame:(CGRect)frame
               xArr:(NSArray *)xArr
               yArr:(NSArray *)yArr;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.canScale = YES;
        self.dk_backgroundColorPicker = DKColorWithRGB(0xe1e5e8, 0x191919);
        self.xyTextFont = [UIFont systemFontOfSize:10];
        self.chartScaleNum = 1.0;
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(kLineLongPressed:)];
        longGesture.minimumPressDuration = .1;
        [self addGestureRecognizer:longGesture];
        
        UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kLineDoubleClicked:)];
        doubleGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kLineTapClicked:)];
        [tapGesture requireGestureRecognizerToFail:doubleGesture];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
//        UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(KLinePin:)];
//        [self addGestureRecognizer:pinGesture];

        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyyMMdd";
        self.dayFormatter = [[NSDateFormatter alloc] init];
        self.dayFormatter.dateFormat = @"dd";
        self.yearFormatter = [[NSDateFormatter alloc] init];
        self.yearFormatter.dateFormat = @"yyyy";
        self.monthFormatter = [[NSDateFormatter alloc] init];
        self.monthFormatter.dateFormat = @"MM";
        self.myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        self.kLineScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.kLineScrollView.backgroundColor = [UIColor clearColor];
        self.kLineScrollView.showsHorizontalScrollIndicator = NO;
        self.kLineScrollView.bounces = NO;
        self.kLineScrollView.delegate = self;
        [self addSubview:self.kLineScrollView];
        
        NSString *xMaxStr = @"2015-05-15";
        NSDictionary *attribute = @{NSFontAttributeName:self.xyTextFont};
        CGSize size = [xMaxStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
        self.marginBottom = size.height + 10;
        
        NSString *y1MaxStr = [NSString stringWithFormat:@"%.0lf", 1151.3f];
        size = [y1MaxStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:attribute
                                      context:nil].size;
        self.marginLeft = size.width + 10;
        
        NSMutableArray *xInputDataTmp = [NSMutableArray arrayWithCapacity:0];
        for (NSString *string in xArr) {
            NSDate *date = [self.dateFormatter dateFromString:string];
            NSTimeInterval time = [date timeIntervalSinceReferenceDate];
            time = time/(60*60*24);
            [xInputDataTmp addObject:[NSNumber numberWithFloat:(int)(time+1)]];
        }
       
        if (xInputDataTmp && yArr && [xInputDataTmp count]>0 && [yArr count]>0) {
            [self configWithXArr:xInputDataTmp yArr:yArr];
        }
        
        
    }
    return self;
}
- (void)refreshFrame:(CGRect)frame
{
    [self configWithXArr:self.xInputData yArr:self.yInputData];
}

- (void)configWithXArr:(NSArray *)xArr
                  yArr:(NSArray *)yArr
{
    self.xInputData = xArr;//将x轴的时间字符串转换为时间戳
    self.yInputData = yArr;
    
    self.baseOriginPoint = CGPointMake(self.marginLeft + 2, self.bounds.size.height - self.marginBottom - 2);
    self.baseLeftTopPoint = CGPointMake(self.baseOriginPoint.x, 0 + 2);
    self.baseRightBottomPoint = CGPointMake(self.bounds.size.width - 2, self.baseOriginPoint.y);
    
    self.kLineScrollView.frame = CGRectMake(self.baseOriginPoint.x, 2, self.baseRightBottomPoint.x-self.baseOriginPoint.x, self.baseOriginPoint.y-self.baseLeftTopPoint.y);
    
    [self refreshScrollViewWhenScale];
}

- (void)refreshScrollViewWhenScale
{
    NSArray *xInputDataAfterSort = [self.xInputData sortedArrayUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        return [obj1 floatValue] > [obj2 floatValue];
    }];
    
    self.baseXMinValue = [[xInputDataAfterSort firstObject] floatValue];
    self.baseXMaxValue = [[xInputDataAfterSort lastObject] floatValue];//最后一个日期（今天）是最大值
    //时间跨度,chartScaleNum=1时候，一屏跨度是2个月，＝2时候，一瓶跨度时1个月
    CGFloat timeWidth = (self.baseXMaxValue - self.baseXMinValue)/60*self.chartScaleNum;
    
    self.kLineScrollView.contentSize = CGSizeMake(self.kLineScrollView.bounds.size.width*timeWidth, self.kLineScrollView.bounds.size.height);
    
    CGFloat xMinInView = 0+self.kLineScrollView.contentOffset.x;
    CGFloat xMaxInView = self.kLineScrollView.bounds.size.width+self.kLineScrollView.contentOffset.x;
    
    CGFloat totalWidth = self.kLineScrollView.contentSize.width;
    CGFloat rateLeft = xMinInView/totalWidth;
    CGFloat rateRight = xMaxInView/totalWidth;
    CGFloat valueLeft = rateLeft*(self.baseXMaxValue-self.baseXMinValue)+self.baseXMinValue;
    CGFloat valueRight = rateRight*(self.baseXMaxValue-self.baseXMinValue)+self.baseXMinValue;
    
    [self refreshWithXMinValue:valueLeft xMaxValue:valueRight];
}

- (void)refreshWithXMinValue:(CGFloat)xMinValue xMaxValue:(CGFloat)xMaxValue
{
    NSMutableArray *dataPoints = [NSMutableArray array];
    NSMutableArray *yDataBeforeSort = [NSMutableArray array];
    for (int i=0; i< [self.xInputData count]; i++) {
        if (i==[self.yInputData count]) {
            break;
        }
        CGFloat xValue = [self.xInputData[i] floatValue];
        CGFloat yValue = [self.yInputData[i] floatValue];
        if (xValue<xMinValue || xValue>xMaxValue) {
            continue;
        }
        CGPoint point = CGPointMake(xValue, yValue);
        [dataPoints addObject:[NSValue valueWithCGPoint:point]];
        [yDataBeforeSort addObject:[NSNumber numberWithFloat:yValue]];
    }
    NSArray *dataSourceAfterSort = [dataPoints sortedArrayUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        return [obj1 CGPointValue].x > [obj2 CGPointValue].x;
    }];
    self.dataSource = dataSourceAfterSort;
    
    NSArray *yDataAfterSort = [yDataBeforeSort sortedArrayUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        return [obj1 floatValue] > [obj2 floatValue];
    }];
    float yFirst = floor([[yDataAfterSort firstObject] floatValue]);
    float yLast = ceil([[yDataAfterSort lastObject] floatValue]);
    NSMutableArray *yNeedDisplay = [NSMutableArray arrayWithCapacity:0];
    CGFloat yDValue = fabs(yLast-yFirst);//y轴上总差值
    CGFloat yDip = 0;
    if (yDValue<6) {
        yDip = 1;
    }
    yDip = fabs(yLast-yFirst)/6;
    for (float i=yFirst; i<yLast+0.1; i+=yDip) {
        [yNeedDisplay addObject:[NSNumber numberWithFloat:i]];
    }
    self.yDataSource = yNeedDisplay;
    
    NSMutableArray *xNeedArrTmp = [NSMutableArray arrayWithCapacity:0];
    //获得最开始的时间值
    NSDate *baseDateMinTmp = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self.xInputData firstObject] intValue]*(60*60*24)];
    int baseDayMinNum = [self.dayFormatter stringFromDate:baseDateMinTmp].intValue;
    
    NSDate *dateMaxTmp = [NSDate dateWithTimeIntervalSinceReferenceDate:xMaxValue*24*60*60];
    int maxMonthNum = [self.monthFormatter stringFromDate:dateMaxTmp].intValue;
    int maxYearNum = [self.yearFormatter stringFromDate:dateMaxTmp].intValue;
    
    NSDate *dateMinTmp = [NSDate dateWithTimeIntervalSinceReferenceDate:xMinValue*24*60*60];
    int minMonthNum = [self.monthFormatter stringFromDate:dateMinTmp].intValue;
    int minYearNum = [self.yearFormatter stringFromDate:dateMinTmp].intValue;
    
    if (maxYearNum>minYearNum) {
        for (int ii=minYearNum; ii<maxYearNum+1; ii++) {
            if (ii==minYearNum) {
                for (int jj=minMonthNum; jj<13; jj++) {
                    NSDateComponents *comp = [[NSDateComponents alloc]init];
                    [comp setMonth:jj];
                    [comp setDay:baseDayMinNum];
                    [comp setYear:ii];
                    NSDate *myDate1 = [self.myCal dateFromComponents:comp];
                    [xNeedArrTmp addObject:myDate1];
                    if (self.chartScaleNum==2) {
                        NSTimeInterval time = [myDate1 timeIntervalSinceReferenceDate];
                        time = time/(60*60*24);
                        NSDate *myDate2 = [NSDate dateWithTimeIntervalSinceReferenceDate:(time+1+15)*(60*60*24)];
                        [xNeedArrTmp addObject:myDate2];
                    }
                    
                }
            }else{
                for (int jj=1; jj<minMonthNum; jj++) {
                    NSDateComponents *comp = [[NSDateComponents alloc]init];
                    [comp setMonth:jj];
                    [comp setDay:baseDayMinNum];
                    [comp setYear:ii];
                    NSDate *myDate1 = [self.myCal dateFromComponents:comp];
                    [xNeedArrTmp addObject:myDate1];
                    if (self.chartScaleNum==2) {
                        NSTimeInterval time = [myDate1 timeIntervalSinceReferenceDate];
                        time = time/(60*60*24);
                        NSDate *myDate2 = [NSDate dateWithTimeIntervalSinceReferenceDate:(time+1+15)*(60*60*24)];
                        [xNeedArrTmp addObject:myDate2];
                    }
                }
            }
        }
    }else{
        for (int ii=minMonthNum; ii<maxMonthNum+1; ii++) {
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            [comp setMonth:ii];
            [comp setDay:baseDayMinNum];
            [comp setYear:minYearNum];
            NSDate *myDate1 = [self.myCal dateFromComponents:comp];
            [xNeedArrTmp addObject:myDate1];
            if (self.chartScaleNum==2) {
                NSTimeInterval time = [myDate1 timeIntervalSinceReferenceDate];
                time = time/(60*60*24);
                NSDate *myDate2 = [NSDate dateWithTimeIntervalSinceReferenceDate:(time+1+15)*(60*60*24)];
                [xNeedArrTmp addObject:myDate2];
            }
        }
    }
    
    NSMutableArray *xNeedTimeTmp = [NSMutableArray arrayWithCapacity:0];
    for (NSDate *dateTmp in xNeedArrTmp) {
        NSTimeInterval timeFloat = [dateTmp timeIntervalSinceReferenceDate]/(24*60*60);
        [xNeedTimeTmp addObject:[NSNumber numberWithDouble:timeFloat]];
    }
    
    
    self.xDataSource = xNeedTimeTmp;
    
    self.xMaxValue = [[self.dataSource lastObject] CGPointValue].x;
    self.yMaxValue = [[self.yDataSource lastObject] floatValue];
    self.xMinValue = [[self.dataSource firstObject] CGPointValue].x;
    self.yMinValue = [[self.yDataSource firstObject] floatValue];
    
    [self.lineLayer removeFromSuperlayer];
    [self.fillLayer removeFromSuperlayer];
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
    
    
    [fillPath addLineToPoint:self.baseRightBottomPoint];
    [fillPath addLineToPoint:self.baseOriginPoint];
    
    self.fillLayer = [CAShapeLayer layer];
    self.fillLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.fillLayer.bounds = self.bounds;
    self.fillLayer.path = fillPath.CGPath;
    self.fillLayer.strokeColor = nil;
    UIColor *color = RKFillColor;
    self.fillLayer.fillColor = color.CGColor;
    self.fillLayer.lineWidth = 0;
    self.fillLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.lineLayer];
    [self.layer addSublayer:self.fillLayer];
    [self setNeedsDisplay];
    
}

- (CGPoint)positionWithIndex:(NSInteger)index
{
    CGPoint point = ((NSValue *)[self.dataSource objectAtIndex:index]).CGPointValue;
    CGFloat xValue  = point.x;
    CGFloat xPosition = [self xInViewPositionOfXValue:xValue];
    CGFloat yValue = point.y;
    CGFloat yPosition = [self yInViewPositionOfYValue:yValue];
    return CGPointMake(xPosition, yPosition);
}

- (NSString *)titleForXTime:(CGFloat)time
{
    CGFloat timeTmp = time*(60*60*24);
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeTmp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *timeTitle = [formatter stringFromDate:date];
    return timeTitle;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSMutableParagraphStyle *paragraphStyleOfXYText= [[NSMutableParagraphStyle alloc] init];
    paragraphStyleOfXYText.lineBreakMode = NSLineBreakByClipping;
    paragraphStyleOfXYText.alignment = NSTextAlignmentRight;
    NSDictionary *attributesOfXYText = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.xyTextFont,                 NSFontAttributeName,
                                        paragraphStyleOfXYText,                  NSParagraphStyleAttributeName,
                                        RKNumberColor,                   NSForegroundColorAttributeName,
                                        nil];
    
    for (NSInteger index=0; index < self.xDataSource.count; index++) {
        NSNumber *num = [self.xDataSource objectAtIndex:index];
        NSString *valStr = [self titleForXTime:[num floatValue]];
        float xPosition = self.baseOriginPoint.x + (([num floatValue]-self.xMinValue)/(self.xMaxValue-self.xMinValue))*(self.baseRightBottomPoint.x - self.baseOriginPoint.x);
        
        if (!(xPosition < self.baseOriginPoint.x) && !(xPosition > self.baseRightBottomPoint.x)) {
            [RKNumberColor set];
            CGSize title1Size = [valStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)
                                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:attributesOfXYText
                                                     context:nil].size;
            
            CGFloat titleX = xPosition - (title1Size.width)/2;
            CGRect titleRect1 = CGRectMake(titleX,
                                           self.baseOriginPoint.y + 7,
                                           title1Size.width,
                                           title1Size.height);
            if (![valStr isEqualToString:@"0"]) {
                [valStr drawInRect:titleRect1 withAttributes:attributesOfXYText];
            }
            
            CGFloat dashPattern[]= {1.5, 5};
            CGContextSetLineDash(context, 0.0, dashPattern, 2);
            [self drawLine:context
                startPoint:CGPointMake(xPosition, self.baseOriginPoint.y)
                  endPoint:CGPointMake(xPosition, self.baseLeftTopPoint.y)
                 lineColor:RKXYlineColor];
            
        }
    }
    for (NSInteger i = 0; i < self.yDataSource.count; i++) {
        NSNumber *num = [self.yDataSource objectAtIndex:i];
        NSString *valStr = [NSString stringWithFormat:@"%.1lf", [num floatValue]];
        
        CGFloat y1Position = self.baseOriginPoint.y + (([num floatValue]-self.yMinValue)/(self.yMaxValue-self.yMinValue))*(self.baseLeftTopPoint.y - self.baseOriginPoint.y);
        
        if (!(y1Position > self.baseOriginPoint.y) && !(y1Position < self.baseLeftTopPoint.y)) {
            [RKNumberColor set];
            CGSize title1Size = [valStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)
                                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:attributesOfXYText
                                                     context:nil].size;
            CGFloat titleY = y1Position - (title1Size.height)/2;
            if (i==[self.yDataSource count]-1) {
                titleY = y1Position;
            }
            CGRect titleRect1 = CGRectMake(self.baseOriginPoint.x-7-title1Size.width,
                                           titleY,
                                           title1Size.width,
                                           title1Size.height);
            [valStr drawInRect:titleRect1 withAttributes:attributesOfXYText];
            
            CGFloat dashPattern[]= {1.5, 5};
            CGContextSetLineDash(context, 0.0, dashPattern, 2);
            [self drawLine:context
                startPoint:CGPointMake(self.baseOriginPoint.x, y1Position)
                  endPoint:CGPointMake(self.baseRightBottomPoint.x, y1Position)
                 lineColor:RKXYlineColor];
        }
    }
}

#pragma mark - 刷新CAL线底端文字
- (void)refreshCalTextOfXCorrectValue:(CGFloat)xCorrectValue YCorrectValue:(CGFloat)yCorrectValue
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:xCorrectValue*60*60*24];
    NSString *xString = [formatter stringFromDate:date];
    self.calVerTextContentLayer.string = xString;
    self.calHorTextContentLayer.string = [NSString stringWithFormat:@"%.2f",yCorrectValue];
}
#pragma mark - 竖向CAL线底端文字的绘制
- (void)addCalVerTextLayerOfXInView:(CGFloat)xInView
{
    self.calVerTextLayer = [CALayer layer];
    self.calVerTextLayer.frame = CGRectMake(xInView-63/2, self.baseOriginPoint.y+3, 63, 14);
    UIColor *color = RKFillColor;
    self.calVerTextLayer.backgroundColor = color.CGColor;
    self.calVerTextLayer.borderColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1.0].CGColor;
    self.calVerTextLayer.borderWidth = 1.0;
    self.calVerTextLayer.cornerRadius = 5.0;
    [self.layer addSublayer:self.calVerTextLayer];
    
    self.calVerTextContentLayer = [CATextLayer layer];
    self.calVerTextContentLayer.frame = self.calVerTextLayer.bounds;
    self.calVerTextContentLayer.string = @"1";
    self.calVerTextContentLayer.fontSize = 12;
    self.calVerTextContentLayer.contentsScale = 2;
    self.calVerTextContentLayer.foregroundColor = RKNumberColor.CGColor;
    UIColor *color1 = RKFillColor;
    self.calVerTextContentLayer.backgroundColor = color1.CGColor;
    self.calVerTextContentLayer.alignmentMode = @"center";
    [self.calVerTextLayer addSublayer:self.calVerTextContentLayer];
}
- (void)refreshCalVerTextLayerOfXInView:(CGFloat)xInView
{
    [CATransaction setDisableActions:YES];
    self.calVerTextLayer.frame = CGRectMake(xInView-63/2, self.baseOriginPoint.y+3, 63, 14);
    [CATransaction setDisableActions:NO];
}

#pragma mark - 横向CAL线左边文字的绘制
- (void)addCalHorTextLayerOfYInView:(CGFloat)yInView
{
    self.calHorTextLayer = [CALayer layer];
    self.calHorTextLayer.frame = CGRectMake(self.baseOriginPoint.x-3-38, yInView-14/2, 38, 14);
    UIColor *color = RKFillColor;
    self.calHorTextLayer.backgroundColor = color.CGColor;
    self.calHorTextLayer.borderColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1.0].CGColor;
    self.calHorTextLayer.borderWidth = 1.0;
    self.calHorTextLayer.cornerRadius = 5.0;
    [self.layer addSublayer:self.calHorTextLayer];
    
    self.calHorTextContentLayer = [CATextLayer layer];
    self.calHorTextContentLayer.frame = self.calHorTextLayer.bounds;
    self.calHorTextContentLayer.string = @"1";
    self.calHorTextContentLayer.foregroundColor = RKNumberColor.CGColor;
    self.calHorTextContentLayer.fontSize = 12;
    self.calHorTextContentLayer.contentsScale = 2;
    self.calHorTextContentLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.calHorTextContentLayer.alignmentMode = @"center";
    [self.calHorTextLayer addSublayer:self.calHorTextContentLayer];
}

- (void)refreshCalHorTextLayerOfYInView:(CGFloat)yInView
{
    [CATransaction setDisableActions:YES];
    self.calHorTextLayer.frame = CGRectMake(self.baseOriginPoint.x-3-38, yInView-14/2, 38, 14);
    [CATransaction setDisableActions:NO];
}

- (BOOL)isKLineCanScale
{
    return self.canScale;
}

- (CGFloat)kLineScaleNum
{
    return self.chartScaleNum;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (!self.canScale) {
//        return;
//    }
//    if (1==self.chartScaleNum) {
//        return;
//    }
    [self refreshScrollViewWhenScale];
}

- (void)addMovingKLineLayer:(CALayer *)layer
{
    [self.layer addSublayer:layer];
}

#pragma mark - 手势交互
- (void)kLineTapClicked:(UITapGestureRecognizer *)sender
{
    if (self.kLineDelegate && [self.kLineDelegate respondsToSelector:@selector(kLineDidTapClicked:)]) {
        [self.kLineDelegate kLineDidTapClicked:self];
    }
}
- (void)kLineDoubleClicked:(UITapGestureRecognizer *)sender
{
    if (self.xInputData.count == 0) {
        return;
    }
    if (![self isKLineCanScale]) {
        [self.kLineDelegate kLineDidDoubleTapClicked:self];
    }
    else
    {
        if (1==self.chartScaleNum) {
            self.chartScaleNum = 2;
        }else{
            self.chartScaleNum = 1;
        }
        [self refreshScrollViewWhenScale];
 
    }
}

//- (void)KLinePin:(UIPinchGestureRecognizer *)sender
//{
//    CGFloat scale = sender.scale;
//    
//    self.chartScaleNum = scale;
//    
//    [self refreshScrollViewWhenScale];
//    
//}

static bool getIt = NO;
- (void)kLineLongPressed:(UILongPressGestureRecognizer *)sender
{
    CGPoint locationPoint = [sender locationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (locationPoint.x<self.baseOriginPoint.x || locationPoint.x>self.baseRightBottomPoint.x) {
            return;
        }
        if (locationPoint.y>self.baseOriginPoint.y || locationPoint.y<self.baseLeftTopPoint.y) {
            return;
        }
        CGFloat xValue = [self xValueOfXInViewPosition:locationPoint.x];
        CGFloat xValueAfterCorrect = [self correctXValue:xValue];
        CGFloat xInView = [self xInViewPositionOfXValue:xValueAfterCorrect];
        CGPoint crossingPoint = [self pointCrossingOfXValue:xValueAfterCorrect];
        if (crossingPoint.y==-1) {
            return;
        }
        getIt = true;
        CGFloat yInView = [self yInViewPositionOfYValue:crossingPoint.y];
        
        [self addCalVerLineOfXInView:xInView];
        [self addCalHorLineOfYInView:yInView];
        [self addCrossingPointWithXInView:xInView andYInView:yInView];
        [self refreshCalTextOfXCorrectValue:crossingPoint.x YCorrectValue:crossingPoint.y];
        if (self.kLineDelegate && [self.kLineDelegate respondsToSelector:@selector(kLine:refreshDataWithX:andY:)]) {
            [self.kLineDelegate kLine:self refreshDataWithX:xValueAfterCorrect andY:crossingPoint.y];
        }
    }else if (sender.state == UIGestureRecognizerStateChanged){
        if (locationPoint.x<self.baseOriginPoint.x || locationPoint.x>self.baseRightBottomPoint.x) {
            return;
        }
        if (locationPoint.y>self.baseOriginPoint.y || locationPoint.y<self.baseLeftTopPoint.y) {
            return;
        }
        CGPoint locationPoint = [sender locationInView:sender.view];
        
        CGFloat xValue = [self xValueOfXInViewPosition:locationPoint.x];
        CGFloat xValueAfterCorrect = [self correctXValue:xValue];
        CGFloat xInView = [self xInViewPositionOfXValue:xValueAfterCorrect];
        
        CGPoint crossingPoint = [self pointCrossingOfXValue:xValueAfterCorrect];
        if (crossingPoint.y==-1) {
            //找不到对应的y值就返回不画图了
            return;
        }
        CGFloat yInView = [self yInViewPositionOfYValue:crossingPoint.y];
        
        if (getIt) {
            [self refreshCalVerLineOfXInView:xInView];
            [self refreshCalHorLineOfYInView:yInView];
            [self refreshCrossingPointWithXInView:xInView andYInView:yInView];
        }else{
            [self addCalVerLineOfXInView:xInView];
            [self addCalHorLineOfYInView:yInView];
            [self addCrossingPointWithXInView:xInView andYInView:yInView];
            getIt = true;
        }
        [self refreshCalTextOfXCorrectValue:crossingPoint.x YCorrectValue:crossingPoint.y];
        if (self.kLineDelegate && [self.kLineDelegate respondsToSelector:@selector(kLine:refreshDataWithX:andY:)]) {
            [self.kLineDelegate kLine:self refreshDataWithX:xValueAfterCorrect andY:crossingPoint.y];
        }
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [self.calVerLayer removeFromSuperlayer];
        [self.calHorLayer removeFromSuperlayer];
        [self.crossingLayer removeFromSuperlayer];
        [self.calVerTextLayer removeFromSuperlayer];
        [self.calHorTextLayer removeFromSuperlayer];
        getIt= false;
    }
}

#pragma mark - 交叉点查找和x值矫正
- (CGPoint)pointCrossingOfXValue:(CGFloat)xValue
{
    __block CGFloat yValue = -1;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((NSValue *)obj).CGPointValue.x == xValue) {
            *stop = YES;
            yValue = ((NSValue *)obj).CGPointValue.y;
        }
    }];
    return CGPointMake(xValue, yValue);
}
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
    CGPoint startPoint = CGPointMake(xInView, self.baseRightBottomPoint.y);
    CGPoint endPoint = CGPointMake(xInView, self.baseLeftTopPoint.y);
    
    [calLinePath moveToPoint:startPoint];
    [calLinePath addLineToPoint:endPoint];
    
    self.calVerLayer = [CAShapeLayer layer];
    self.calVerLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.calVerLayer.bounds = self.bounds;
    self.calVerLayer.path = calLinePath.CGPath;
    self.calVerLayer.strokeColor = RKCalLineColor.CGColor;
    self.calVerLayer.fillColor = nil;
    self.calVerLayer.lineWidth = kRKTimeKLineCalLineWidth;
    self.calVerLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.calVerLayer];
    
    [self addCalVerTextLayerOfXInView:xInView];
}
- (void)refreshCalVerLineOfXInView:(CGFloat)xInView
{
    UIBezierPath* calLinePath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(xInView, self.baseRightBottomPoint.y);
    CGPoint endPoint = CGPointMake(xInView, self.baseLeftTopPoint.y);
    
    [calLinePath moveToPoint:startPoint];
    [calLinePath addLineToPoint:endPoint];
    
    self.calVerLayer.path    = calLinePath.CGPath;
    
    [self refreshCalVerTextLayerOfXInView:xInView];
}
#pragma mark - 横向CAL线的绘制
- (void)addCalHorLineOfYInView:(CGFloat)yInView
{
    UIBezierPath* calLinePath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(self.baseRightBottomPoint.x, yInView);
    CGPoint endPoint = CGPointMake(self.baseLeftTopPoint.x, yInView);
    
    [calLinePath moveToPoint:startPoint];
    [calLinePath addLineToPoint:endPoint];
    
    self.calHorLayer = [CAShapeLayer layer];
    self.calHorLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.calHorLayer.bounds = self.bounds;
    self.calHorLayer.path = calLinePath.CGPath;
    self.calHorLayer.strokeColor = RKCalLineColor.CGColor;
    self.calHorLayer.fillColor = nil;
    self.calHorLayer.lineWidth = kRKTimeKLineCalLineWidth;
    self.calHorLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.calHorLayer];
    
    [self addCalHorTextLayerOfYInView:yInView];
}
- (void)refreshCalHorLineOfYInView:(CGFloat)yInView
{
    UIBezierPath* calLinePath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(self.baseRightBottomPoint.x, yInView);
    CGPoint endPoint = CGPointMake(self.baseLeftTopPoint.x, yInView);
    
    [calLinePath moveToPoint:startPoint];
    [calLinePath addLineToPoint:endPoint];
    
    self.calHorLayer.path = calLinePath.CGPath;
    
    [self refreshCalHorTextLayerOfYInView:yInView];
    
}

- (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color{
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Pointcolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Pointcolorspace1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, point.x,point.y);
    CGContextAddArc(context, point.x, point.y, 2, 0, 360, 0);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    CGColorSpaceRelease(Pointcolorspace1);
}
- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor{
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}

#pragma mark - XY坐标系和视图坐标系的对应
- (CGFloat)xValueOfXInViewPosition:(CGFloat)xInView
{
    CGFloat sitePercent = (xInView-self.baseOriginPoint.x)/(self.baseRightBottomPoint.x-self.baseOriginPoint.x);
    CGFloat totalInValue = self.xMaxValue - self.xMinValue;
    CGFloat xValue = sitePercent * totalInValue + self.xMinValue;
    return xValue;
}
- (CGFloat)xInViewPositionOfXValue:(CGFloat)xValue
{
    CGFloat sitePercent = (xValue-self.xMinValue)/(self.xMaxValue-self.xMinValue);
    CGFloat totalInView = self.baseRightBottomPoint.x - self.baseOriginPoint.x;
    CGFloat xPosition = self.baseOriginPoint.x + sitePercent*totalInView;
    return xPosition;
}
- (CGFloat)yValueOfYInViewPosition:(CGFloat)yInView
{
    CGFloat sitePercent = (yInView-self.baseOriginPoint.y)/(self.baseLeftTopPoint.y-self.baseOriginPoint.y);
    CGFloat totalInValue = self.yMaxValue - self.yMinValue;
    CGFloat yValue = sitePercent *totalInValue;
    return yValue;
}
- (CGFloat)yInViewPositionOfYValue:(CGFloat)yValue
{
    CGFloat sitePercent = (yValue-self.yMinValue)/(self.yMaxValue-self.yMinValue);
    CGFloat totalInView = self.baseLeftTopPoint.y - self.baseOriginPoint.y;
    CGFloat yPosition = self.baseOriginPoint.y - sitePercent * fabs(totalInView);
    return yPosition;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        });
    }
}

#pragma mark - String To Time

@end
