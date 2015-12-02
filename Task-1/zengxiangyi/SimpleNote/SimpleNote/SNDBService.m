//
//  SNDBHelper.m
//  SimpleNote
//
//  Created by zxy on 15/11/18.
//  Copyright © 2015年 zxy. All rights reserved.
//


#import "SNDBService.h"
#import "SNDBHelper.h"
#import "SNItemService.h"
#import "SNItem.h"

//数据库名和列名
static NSString *const DB_NAME = @"note.sqlite";
static NSString *const DB_COLUMN_NAME_TITLE = @"title";
static NSString *const DB_COLUMN_NAME_CONTENT = @"content";
static NSString *const DB_COLUMN_NAME_DATE = @"date";
static NSString *const DB_COLUMN_NAME_ID = @"id";
static NSString *const DB_COLUMN_NAME_ISFAVOR = @"isfavor";

@implementation SNDBService


#pragma mark 数据库增删改查

+ (void)getAllData {
    NSString *sql = @"SELECT * FROM INFO";
    
    [SNDBHelper executeDBRead:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            //从数据库中获取内容
            NSString *title = [result stringForColumn:DB_COLUMN_NAME_TITLE];
            NSString *content = [result stringForColumn:DB_COLUMN_NAME_CONTENT];
            NSString *date = [result stringForColumn:DB_COLUMN_NAME_DATE];
            NSString *idNum = [result stringForColumn:DB_COLUMN_NAME_ID];
            NSString *isFavor = [result stringForColumn:DB_COLUMN_NAME_ISFAVOR];
            
            //将数据库的内容存到Item数组
            SNItem *newItem = [SNItemService createItem];
            newItem.title = title;
            newItem.detailText = content;
            newItem.dateCreated = date;
            newItem.idNum = idNum;
            newItem.isFavor = isFavor;
        }
        [result close];
    }];
}

+ (void)addTitle:(NSString *)titleFieldText content:(NSString *)contentFieldText date:(NSString *)dateLabelText isFavor:(NSString *)isFavor {
    NSString *sql = @"INSERT INTO INFO (TITLE, CONTENT, DATE, ISFAVOR) VALUES(?, ?, ?, ?)";
    
    [SNDBHelper executeDBWriteInTransaction:^(FMDatabase *db) {
        [db executeUpdate: sql, titleFieldText, contentFieldText, dateLabelText, isFavor];
    }];
}

+ (void)deleteDataByTitle:(NSString *)title content:(NSString *)content {
    NSString *sql = @"DELETE FROM INFO WHERE TITLE = ? AND CONTENT = ?";
    
    [SNDBHelper executeDBWriteInTransaction:^(FMDatabase *db) {
        [db executeUpdate:sql, title, content];
    }];
}

+ (void)updateTitle:(NSString *)title content:(NSString *)content isFavor:(NSString *)isFavor byOldTitle:(NSString *)oldTitle oldContent:(NSString *)oldContent {
    NSString *sql = @"UPDATE INFO SET TITLE = ?, CONTENT = ?, ISFAVOR = ? WHERE TITLE = ? AND CONTENT = ?";
    
    [SNDBHelper executeDBWriteInTransaction:^(FMDatabase *db) {
        [db executeUpdate: sql, title, content, isFavor, oldTitle, oldContent];
    }];
}


@end
