//
//  CBDataBase.m
//  ChinaBond
//
//  Created by wangran on 15/12/21.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBDataBase.h"

@interface CBDataBase()
{
     FMDatabaseQueue *_queue;
}
@end

@implementation CBDataBase

-(instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _queue = [FMDatabaseQueue databaseQueueWithPath:[[self class] pri_dataBasePath]];
    [self pri_createTableWithSQL:@"create table if not exists CBTable(uid integer primary key autoincrement,cName text,imgUrl text,infoUrl text,tId text,title text,vTime text)"];
    
    return self;
}

- (void)initialData
{
    if (!_queue) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:[[self class] pri_dataBasePath]];
        [self pri_createTableWithSQL:@"create table if not exists CBTable(uid integer primary key autoincrement,cName text,imgUrl text,infoUrl text,tId text,title text,vTime text)"];
    }
}

#pragma mark - 创建数据库单例方法
static CBDataBase *_sharedDatabase = nil;
+ (CBDataBase *)sharedDatabase
{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        _sharedDatabase = [[CBDataBase alloc] init];
    });
    return _sharedDatabase;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        _sharedDatabase = [super allocWithZone:zone];
    });
    return _sharedDatabase;
}

#pragma mark - 返回数据库的本地沙盒路径
+ (NSString *)pri_dataBasePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask,
                                                          YES)objectAtIndex:0];
    NSString *dbPath = [path stringByAppendingPathComponent:@"CBTable.db"];
    return dbPath;
}

#pragma mark - 删除数据库
- (void)deleteAllNote
{
    // 删除Note数据库
    NSString *path = [CBDataBase pri_dataBasePath];
    BOOL hasPath = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (hasPath) {
        NSError *err;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&err];

    }
}

#pragma mark - 创建表格
- (BOOL)pri_createTableWithSQL:(NSString *)tableSql
{
    __block BOOL isSucess;
    [_queue inDatabase:^(FMDatabase *db){
        if ([db executeUpdate:tableSql]) {
            CBLog(@"创建Note表成功");
            isSucess = YES;
        }else {
            CBLog(@"创建Note表失败：%@",[db lastErrorMessage]);
            isSucess = NO;
        }
    }];
    return isSucess;
}



/**
 *  插入多条数据
 *
 *  @param Month 0000-00
 *
 *  @return 数组
 */
- (void)insertAllNewsList:(NSArray *)newsList
{
    if ([newsList count]) {
        NSString * sqlStr = [NSMutableString stringWithString:@"insert into CBTable (cName,imgUrl,infoUrl,tId,title,vTime) select "];
        int i = 0;
        int number = 0;
        for (NSDictionary *newsDic in newsList) {
            number ++;
            NSString *temp = @"";
            CBNewsModel *model = [[CBNewsModel alloc] init];
            model.cName =  [newsDic objectForKey:@"cName"];
            model.imgUrl = [newsDic objectForKey:@"imgUrl"];
            model.infoUrl = [newsDic objectForKey:@"infoUrl"];
            model.tId = [newsDic objectForKey:@"tId"];
            model.title = [newsDic objectForKey:@"title"];
            model.vTime =  [newsDic objectForKey:@"vTime"];
           
            
            if ([self checkSeverNoteId:model.tId]) {
                continue;
            }
            
            if (i > 0) {
                temp = @" union all select ";
            }
            i ++;
            NSString *tmp2 = [NSString stringWithFormat:@"%@ '%@','%@','%@','%@','%@','%@'",temp, model.cName,model.imgUrl,model.infoUrl,model.tId,model.title,model.vTime];
            
            sqlStr = [NSString stringWithFormat:@"%@%@",sqlStr,tmp2];
            if (i >450) {
                [_queue inDatabase:^(FMDatabase *db){
                    [db executeUpdate:sqlStr];
                }];
                //%%数据库插入多条数据之后刷新界面

                sqlStr = @"";
                sqlStr = [NSMutableString stringWithString:@"insert into CBTable (cName,imgUrl,infoUrl,tId,title,vTime) select "];
                i = 0;
            }
            

            
        }
        if (![sqlStr isEqualToString:@""] && i != 0) {
            [_queue inDatabase:^(FMDatabase *db){
                [db executeUpdate:sqlStr];
            }];

        }
  }
}

- (BOOL)checkSeverNoteId:(NSString *)tId
{
    __block BOOL ret = NO;
    [_queue inDatabase:^(FMDatabase *db){
        FMResultSet *res = [db executeQuery:@"select count(1) as count from CBTable where tId = ?",tId];
        while ([res next]) {
            if ([res intForColumn:@"count"]) {
                ret = YES;
            }
        }
        [res close];
    }];
    
    return ret;
}

#pragma mark - 向数据库写入数据
- (void)addItemWithNewsModel:(CBNewsModel *)newsModel;
{
    
    if ([self checkSeverNoteId:newsModel.tId]) {
     
        // 向表中插入数据
        if ([self pri_insertTableDataWithTable:@"CBTable" andDataModel:newsModel]) {
            CBLog(@"插入表成功");
            [_queue inDatabase:^(FMDatabase *db){
                
            }];
            
        }else{
            CBLog(@"插入失败");
        };
        
    }
}

#pragma mark - 向表中插入数据
- (BOOL)pri_insertTableDataWithTable:(NSString *)tableName andDataModel:(CBNewsModel *)newsModel
{
    __block BOOL insertSucced = NO;
    [_queue inDatabase:^(FMDatabase *db){
        insertSucced = [db executeUpdate:@"insert into CBTable (cName,imgUrl,infoUrl,tId,title,vTime) values(?,?,?,?,?,?)",newsModel.cName,newsModel.imgUrl,newsModel.infoUrl,newsModel.tId,newsModel.title,newsModel.vTime];
        if(insertSucced){
            CBLog(@"插入数据成功");
            
        }else{
            CBLog(@"数据库中已经存在");
        }
    }];
    return insertSucced;//
}

- (void)deleteNewsWithTid:(NSString *)tId
{
    __block BOOL dateba = NO;
    [_queue inDatabase:^(FMDatabase *db){
        dateba = [db executeUpdate:@"DELETE FROM CBTable WHERE tId = ?",tId];
        if (dateba) {
            CBLog(@"数据库更新成功");
        }else{
            CBLog(@"数据库更新不成");
        }
    }];
}

@end
