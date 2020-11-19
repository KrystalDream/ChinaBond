//
//  CBChannelModel.h
//  ChinaBond
//
//  Created by wangran on 15/12/24.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBChannelModel : NSObject
//频道ID
@property (nonatomic, strong) NSString *channelD;
//频道名称
@property (nonatomic, strong) NSString *label;
//是否能搜索
@property (nonatomic, strong) NSString *canSearchable;
//频道类型
@property (nonatomic, strong) NSString *typeID;
//是否展开
@property (nonatomic) BOOL isExpand;
//节点类型
@property (nonatomic) int type;
//节点层次
@property (nonatomic) int nodeLevel;

@property (nonatomic, strong) NSMutableArray *childrens;

@property (nonatomic, strong) CBChannelModel *sonNodes;

//父节点名字或父父节点名字
@property (nonatomic, strong) NSString *parentName;
//所出层级位置
@property (nonatomic) int level1;
@property (nonatomic) int level2;
@property (nonatomic) int level3;

@end
