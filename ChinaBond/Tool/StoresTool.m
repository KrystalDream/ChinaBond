//
//  StoresTool.m
//  ChinaBond
//
//  Created by Krystal on 2020/12/15.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import "StoresTool.h"


static NSString *const kUserInfoConfigFilePath            = @"usrInfoConfig";
static NSString *const kUserHomeDataFilePath            = @"usrHomeData";

/** 系统消息存储地址 */
static NSString *const kSystemMsgReadStatusPlistFilePath             = @"systemMsgReadStatus.plist";

/** 系统消息存储地址 */
static NSString *const kSystemMsgReadStatusDbPath             = @"systemMsgReadStatus.db";

@implementation StoresTool

+(instancetype)shareTool {
    
    static StoresTool *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return  _instance;
}

- (void)createDB {
    
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dbPath = [basePath stringByAppendingPathComponent:kSystemMsgReadStatusDbPath];
    
    FMDatabase *db = [[FMDatabase alloc] initWithPath:dbPath];
    if ([db open]) {
        NSString *sql = @"CREATE TABLE IF NOT EXIST msg_status(id TEXT NOT NULL, read INTEGER NOT NULL);";
        BOOL res = [db executeUpdate:sql];
        if (res) {
            CBLog(@"");
        }else {
            CBLog(@"");
        }
        [db close];
    }else {
        
        CBLog(@"数据库未打开！");
    }
    
}

- (void)store2LocalPath:(NSString *)path data:(NSData *)data {
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *homePath = [basePath stringByAppendingPathComponent:kUserHomeDataFilePath];
    [data writeToFile:[NSString stringWithFormat:@"%@/%@",homePath,path] atomically:YES];
}

- (NSData *)readFromLocalPath:(NSString *)path {
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *homePath = [basePath stringByAppendingPathComponent:kUserHomeDataFilePath];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:homePath];
    if (!exist) {
        BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:NULL];
        if (!create) {
            return nil;
        }
    }
    return [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",homePath,path]];
}

- (void)saveSystemMsgReadStatus:(NSDictionary *)otherDic {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *usrPath = [path stringByAppendingPathComponent:kUserInfoConfigFilePath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",usrPath,kSystemMsgReadStatusPlistFilePath]];
    NSMutableDictionary *statusDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [statusDic setValuesForKeysWithDictionary:otherDic];
    [statusDic.copy writeToFile:[NSString stringWithFormat:@"%@/%@",usrPath,kSystemMsgReadStatusPlistFilePath] atomically:YES];
}

- (NSDictionary *)getSystemMsgReadStatus {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *usrPath = [path stringByAppendingPathComponent:kUserInfoConfigFilePath];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:usrPath];
    if (!exist) {
        BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:usrPath withIntermediateDirectories:YES attributes:nil error:NULL];
        if (!create) {
            return @{};
        }
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",usrPath,kSystemMsgReadStatusPlistFilePath]];
    if (dic == nil) {
        dic = [NSDictionary dictionary];
    }
    return dic;
}

- (void)clearSystemMessageReadStatus {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:kSystemMsgReadStatusPlistFilePath];
    [@{} writeToFile:filePath atomically:YES];
}

@end
