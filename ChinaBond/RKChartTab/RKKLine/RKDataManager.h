//
//  RKDataManager.h
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/2.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RKKLineModel.h"

#define kApiRateInfo @"http://yield.chinabond.com.cn/cbweb-mn/GetSelectIndics"
#define kApiRateData @"http://yield.chinabond.com.cn/cbweb-mn/GetIndicsServletV2"
#define kApiExponentList @"http://yield.chinabond.com.cn/cbweb-mn/GetSelectIndex"
#define kApiExponentData @"http://yield.chinabond.com.cn/cbweb-mn/GetIndexServlet"
#define kApiStatistics @"http://www.chinabond.com.cn/QueryZqForPhone"
#define kApiValuation @"http://yield.chinabond.com.cn/cbweb-mn/GetIndexServlet/d2s"

@interface RKDataManager : NSObject
+ (RKDataManager *)sharedInstance;
@property (readwrite, nonatomic, copy) NSString * data1;
@property (readwrite, nonatomic, copy) NSString * data2;
@property (readwrite, nonatomic, copy) NSString * data3;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;//yyyy-mm-dd
@property (nonatomic, retain) NSDateFormatter *dateFormatter2;


@property (readonly, nonatomic, retain) RKKLineModel *model;
@property (readonly, nonatomic, retain) RKKLineModel *timeModel;

- (NSDate *)twoMonthAgo:(NSDate *)nowDate;
- (NSString *)subRateString:(NSString *)data;
@end
