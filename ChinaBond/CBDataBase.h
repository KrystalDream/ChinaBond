//
//  CBDataBase.h
//  ChinaBond
//
//  Created by wangran on 15/12/21.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import <FMDatabaseQueue.h>
#import "CBNewsModel.h"

@interface CBDataBase : NSObject

/**
 *  创建数据库，返回一个单例
 *
 *  @return LocalDatabase的单例
 */
+ (CBDataBase *)sharedDatabase;
/**
 *  初始化当前用户的news信息数据库
 */
- (void)initialData;

/**
 *  插入多条数据
 *
 *  @param Month 0000-00
 *
 *  @return 数组
 */
- (void)insertAllNewsList:(NSArray *)newsList;
/**
 *  查询new是否存在
 *
 *  @param Month 0000-00
 *
 *  @return bool
 */
- (BOOL)checkSeverNoteId:(NSString *)tId;

/**
 *  添加单条Note数据
 *
 *  @param dataModel Note数据模板对象
 */
- (void)addItemWithNewsModel:(CBNewsModel *)newsModel;
/**
 *  删除单条new数据
 *
 *  @param dataModel news数据模板对象
 */
- (void)deleteNewsWithTid:(NSString *)tId;

//删除本地数据库
- (void)deleteAllNote;

@end
