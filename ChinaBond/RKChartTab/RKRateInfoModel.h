//
//  RKRateInfoModel.h
//  ChinaBond
//
//  Created by Jiaxiaobin on 15/12/28.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKRateInfoModel : NSObject
@property (nonatomic, copy) NSString *rateTitle;
@property (nonatomic, copy) NSString *rateID;
@property (nonatomic, copy) NSString *ratePID;
@property (nonatomic, retain) NSArray *subInfos;
@end
