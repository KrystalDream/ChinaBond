//
//  RKCateLevelModel.h
//  ChinaBond
//
//  Created by Jiaxiaobin on 15/12/10.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    RKLevelTypeA,
    RKLevelTypeB,
    RKLevelTypeC,
    RKLevelTypeD,
} RKLevelType;

@interface RKCateLevelModel : NSObject
@property (nonatomic, copy) NSString *levelTitle;
@property (nonatomic, copy) NSString *levelID;
@property (nonatomic, assign) RKLevelType levelType;
@property (nonatomic, retain) NSArray *subLevels;
@property (nonatomic, retain) NSArray *subListLevels;//用于存放子列表
@property (nonatomic, assign) BOOL levelIsList;
@end
