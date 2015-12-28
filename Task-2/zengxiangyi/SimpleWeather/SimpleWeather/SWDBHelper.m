//
//  SWDBHelper.m
//  SimpleWeather
//
//  Created by zxy on 15/12/14.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWDBHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
static NSString *const DB_NAME = @"weather.sqlite";

@interface SWDBHelper()
@property(strong) FMDatabaseQueue *dbQueue;
@property(strong) NSOperationQueue *operationQueue;
@end

@implementation SWDBHelper

+ (SWDBHelper *)privateDBHelper {
    static SWDBHelper *swdbHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swdbHelper = [SWDBHelper new];
        
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [doc stringByAppendingPathComponent:DB_NAME];
        NSLog(@"%@", dbPath);
        swdbHelper.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        swdbHelper.operationQueue = [[NSOperationQueue alloc] init];
        
        [swdbHelper.dbQueue inDatabase:^(FMDatabase *db) {
            for (NSString *createSql in [swdbHelper getCreateSql]) {
                [db executeUpdate:createSql];
            }
        }];
    });
    
    return swdbHelper;
}

//查询异步操作
+ (void)executeSelect:(db_block)block {
    SWDBHelper *dbHelper = [SWDBHelper privateDBHelper];
    
    [dbHelper.operationQueue addOperationWithBlock:^{
        [dbHelper.dbQueue inDatabase:^(FMDatabase *db) {
            if(block) {
                block(db);
            }
        }];
    }];
}

//增加，删除，修改同步操作
+ (void)executeUpdate:(db_block)block {
    SWDBHelper *dbHelper = [SWDBHelper privateDBHelper];
    [dbHelper.dbQueue inDatabase:^(FMDatabase *db) {
        if(block) {
            block(db);
        }
    }];
}

- (NSArray *)getCreateSql {
    static NSArray *sqls;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqls = @[@"CREATE TABLE IF NOT EXISTS LOCALCITIES (CITYCODE INTEGER PRIMARY KEY, CITYNAME)",
                @"CREATE TABLE IF NOT EXISTS ALLCITIES (CITYCODE INTEGER PRIMARY KEY, CITYNAME, PROVINCENAME, CITYPINYIN)"];
    });
    return sqls;
}

- (void)dealloc {
    [[SWDBHelper privateDBHelper].operationQueue cancelAllOperations];
    [[SWDBHelper privateDBHelper].dbQueue close];
}

@end

