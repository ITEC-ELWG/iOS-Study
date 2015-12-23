//
//  SNDBHelper.m
//  SimpleNote
//
//  Created by zxy on 15/11/18.
//  Copyright © 2015年 zxy. All rights reserved.
//


#import "SNDBHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

static NSString *const DB_NAME = @"note.sqlite";


@interface SNDBHelper()
@property(strong) FMDatabaseQueue *dbQueue;
@property(strong) NSOperationQueue *operationQueue;
@end

@implementation SNDBHelper

+ (SNDBHelper *)privateDBHelper {
    static SNDBHelper *sndbHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sndbHelper = [SNDBHelper new];
        NSString *createSql = [sndbHelper getCreateSql];

        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [doc stringByAppendingPathComponent:DB_NAME];
    
        sndbHelper.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        sndbHelper.operationQueue = [[NSOperationQueue alloc] init];
        [sndbHelper.dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:createSql];
        }];
    });
    
    return sndbHelper;
}

//异步数据库操作
+ (void)executeOperation:(db_block)block {
    SNDBHelper *dbHelper = [SNDBHelper privateDBHelper];
    
    [dbHelper.operationQueue addOperationWithBlock:^{
        [dbHelper.dbQueue inDatabase:^(FMDatabase *db) {
            if(block) {
                block(db);
            }
        }];
    }];
}


- (NSString *)getCreateSql {
    static NSString *sql;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sql = @"CREATE TABLE IF NOT EXISTS INFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE, CONTENT, DATE, ISFAVOR)";
    });
    return sql;
}

- (void)dealloc {
    [[SNDBHelper privateDBHelper].operationQueue cancelAllOperations];
    [[SNDBHelper privateDBHelper].dbQueue close];
}

@end
