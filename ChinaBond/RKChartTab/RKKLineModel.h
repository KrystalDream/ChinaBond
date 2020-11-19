//
//  RKKLineModel.h
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/7.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKRateInfoModel;
@class RKCateLevelModel;

@interface RKKLineModel : NSObject
@property (nonatomic, retain) NSArray *xArr;
@property (nonatomic, retain) NSArray *yArr;
@property (nonatomic, retain) NSArray *zArr;//指数曲线特有
@property (nonatomic, retain) RKRateInfoModel *rateInfoModel;//收益率曲线特有
@property (nonatomic, retain) RKCateLevelModel *exponentModel;//指数曲线特有
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *name;
@end
