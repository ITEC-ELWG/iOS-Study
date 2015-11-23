//
//  SNDBHelper.m
//  SimpleNote
//
//  Created by zxy on 15/11/18.
//  Copyright © 2015年 zxy. All rights reserved.
//


#import "SNDBHelper.h"

//数据库名和列名
static NSString *const DB_NAME = @"note.sqlite";
static NSString *const TITLE = @"title";
static NSString *const CONTENT = @"content";
static NSString *const DATE = @"date";
static NSString *const ID = @"id";
static NSString *const ISFAVOR = @"isfavor";

@implementation SNDBHelper

+ (id)sharedDataBase
{
    static SNDBHelper *sharedDataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataBase = [self alloc];
    });
    
    return sharedDataBase;
}

- (void)createTable
{
    //获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [doc stringByAppendingPathComponent:DB_NAME];
    
    self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    self.dispachQueue = dispatch_queue_create("newThread", NULL);
    
    dispatch_async(_dispachQueue, ^{
        [_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS INFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE, CONTENT, DATE, ISFAVOR)"];
        }];
    });
}

#pragma mark 数据库增删改查

- (void)getAllData
{
    dispatch_async(_dispachQueue, ^{
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"SELECT * FROM INFO";
            FMResultSet *result = [db executeQuery:sql];
            
            while ([result next])
            {
                //从数据库中获取内容
                NSString *title = [result stringForColumn:TITLE];
                NSString *content = [result stringForColumn:CONTENT];
                NSString *date = [result stringForColumn:DATE];
                NSString *idNum = [result stringForColumn:ID];
                NSString *isFavor = [result stringForColumn:ISFAVOR];
                
                //将数据库的内容存到Item数组
                SNItem *newItem = [[SNItem sharedStore] createItem];
                newItem.title = title;
                newItem.detailText = content;
                newItem.dateCreated = date;
                newItem.idNum = idNum;
                newItem.isFavor = isFavor;
            }
        }];
    });
}

- (void)addTitle:(NSString *)titleFieldText content:(NSString *)contentFieldText date:(NSString *)dateLabelText isFavor:(NSString *)isFavor
{
    dispatch_async(_dispachQueue, ^{
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"INSERT INTO INFO (TITLE, CONTENT, DATE, ISFAVOR) VALUES(?, ?, ?, ?)";
            [db executeUpdate: sql, titleFieldText, contentFieldText, dateLabelText, isFavor];

        }];
    });
}

- (void)deleteDataByTitle:(NSString *)title content:(NSString *)content
{
    dispatch_async(_dispachQueue, ^{
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"DELETE FROM INFO WHERE TITLE = ? AND CONTENT = ?";
            [db executeUpdate:sql, title, content];
        }];
    });
}

- (void)updateTitle:(NSString *)title content:(NSString *)content isFavor:(NSString *)isFavor byOldTitle:(NSString *)oldTitle oldContent:(NSString *)oldContent
{
    dispatch_async(_dispachQueue, ^{
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"UPDATE INFO SET TITLE = ?, CONTENT = ?, ISFAVOR = ? WHERE TITLE = ? AND CONTENT = ?";
            [db executeUpdate: sql, title, content, isFavor, oldTitle, oldContent];
        
        }];
    });
}


@end
