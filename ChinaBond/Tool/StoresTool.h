//
//  StoresTool.h
//  ChinaBond
//
//  Created by Krystal on 2020/12/15.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <fmdb/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoresTool : NSObject
+ (instancetype) shareTool;

- (NSDictionary *)getSystemMsgReadStatus;

- (void)store2LocalPath:(NSString *)path data:(id)data;

- (id)readFromLocalPath:(NSString *)path;

- (void)saveSystemMsgReadStatus:(NSDictionary *)otherDic;

- (void)clearSystemMessageReadStatus;

- (void)createDB;

//- (void)createMessageTable;
@end

NS_ASSUME_NONNULL_END
