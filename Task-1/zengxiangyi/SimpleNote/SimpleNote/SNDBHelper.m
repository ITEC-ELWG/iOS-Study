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

@property(strong) NSRecursiveLock *writeQueueLock;
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
        sndbHelper.operationQueue = [NSOperationQueue new];
        [sndbHelper.operationQueue setMaxConcurrentOperationCount:1];
        sndbHelper.writeQueueLock = [NSRecursiveLock new];
        
        [sndbHelper.dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:createSql];
        }];
    });
    
    return sndbHelper;
}

- (NSString *)getCreateSql {
    static NSString *sql;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sql = @"CREATE TABLE IF NOT EXISTS INFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE, CONTENT, DATE, ISFAVOR)";
    });
    return sql;
}

+ (void)executeDBRead:(db_block)block {
    SNDBHelper *sndbHelper = [SNDBHelper privateDBHelper];
    
    [sndbHelper.writeQueueLock lock];
    [sndbHelper.dbQueue inDatabase:^(FMDatabase *db) {
        if (block != nil) {
            block(db);
        }
    }];
    [sndbHelper.writeQueueLock unlock];
}

+ (void)executeDBWriteInTransaction:(db_block)block {
    SNDBHelper *sndbHelper = [SNDBHelper privateDBHelper];
    
    [sndbHelper.operationQueue addOperationWithBlock:^{
        [sndbHelper.writeQueueLock lock];
        [sndbHelper.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            if (block != nil) {
                block(db);
            }
        }];
        [sndbHelper.writeQueueLock unlock];
    }];

}

- (void)dealloc {
    [[SNDBHelper privateDBHelper].operationQueue cancelAllOperations];
    [[SNDBHelper privateDBHelper].dbQueue close];
}

@end
