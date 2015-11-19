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
    //获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    //打开数据库
    self.db = db;
    self.dbPath = dbPath;
    if ([_db open])
    {
        //创表
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS INFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE, CONTENT, DATE)"];
        [_db close];
    }
}

#pragma mark 数据库增删改查

- (void)getAllData
{
    if ([_db open])
    {
        NSString *sql = @"SELECT * FROM INFO";
        FMResultSet *result = [_db executeQuery:sql];
        while ([result next])
        {
            NSString *title = [result stringForColumn:TITLE];
            NSString *content = [result stringForColumn:CONTENT];
            NSString *date = [result stringForColumn:DATE];
            NSString *idNum = [result stringForColumn:ID];
            
            SNItem *newItem = [[SNItem sharedStore] createItem];
            newItem.title = title;
            newItem.detailText = content;
            newItem.dateCreated = date;
            newItem.idNum = idNum;
            
        }
        [_db close];
    }
}

- (void)addTitle:(NSString *)titleFieldText content:(NSString *)contentFieldText date:(NSString *)dateLabelText
{
    if ([_db open])
    {
        NSString *sql = @"INSERT INTO INFO (title, content, date) VALUES(?, ?, ?)";
        [_db executeUpdate: sql, titleFieldText, contentFieldText, dateLabelText];
        [_db close];
    }
}

- (void)deleteData:(NSString *)deleteID
{
    if ([_db open])
    {
        NSString *sql = @"DELETE FROM INFO WHERE ID = ?";
        [_db executeUpdate:sql, deleteID];
        
        [_db close];
    }
}

- (void)updateTitle:(NSString *)title content:(NSString *)content by:(NSString *)ID
{
    if ([_db open])
    {
        NSString *sql = @"UPDATE INFO SET TITLE = ?, CONTENT = ? WHERE ID = ?";
        [_db executeUpdate: sql, title, content, ID];
        
    }
}


@end
