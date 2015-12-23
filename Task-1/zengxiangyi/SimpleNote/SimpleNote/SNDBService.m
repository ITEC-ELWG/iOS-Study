//
//  SNDBHelper.m
//  SimpleNote
//
//  Created by zxy on 15/11/18.
//  Copyright © 2015年 zxy. All rights reserved.
//


#import "SNDBService.h"
#import "SNDBHelper.h"
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

+ (void)getAllDataWithComplete:(updateItem)updateItemblock {
    NSString *sql = @"SELECT * FROM INFO";
    NSMutableArray * dbResults= [[NSMutableArray alloc] init];
    [SNDBHelper executeOperation:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            //从数据库中获取内容
            NSString *title = [result stringForColumn:DB_COLUMN_NAME_TITLE];
            NSString *dText = [result stringForColumn:DB_COLUMN_NAME_CONTENT];
            NSString *date = [result stringForColumn:DB_COLUMN_NAME_DATE];
            NSString *idNum = [result stringForColumn:DB_COLUMN_NAME_ID];
            NSString *isFavor = [result stringForColumn:DB_COLUMN_NAME_ISFAVOR];
            
            //将数据库的内容存到Item数组
            SNItem *newItem = [[SNItem alloc] initWithItemTitle:title
                                                     detailText:dText
                                                          idNum:idNum
                                                           date:date
                                                        isFavor:isFavor];
            
            [dbResults addObject:newItem];
        }
        updateItemblock(dbResults);
        [result close];
    }];
}

+ (void)addTitle:(NSString *)titleFieldText
         content:(NSString *)contentFieldText
            date:(NSString *)dateLabelText
         isFavor:(NSString *)isFavor
        complete:(void (^)())complete {
    NSString *sql = @"INSERT INTO INFO (TITLE, CONTENT, DATE, ISFAVOR) VALUES(?, ?, ?, ?)";
    [SNDBHelper executeOperation:^(FMDatabase *db) {
        [db executeUpdate: sql, titleFieldText, contentFieldText, dateLabelText, isFavor];
        complete();
    }];

}

+ (void)deleteDataById:(NSString *)idNum complete:(void (^)())complete {
    NSString *sql = @"DELETE FROM INFO WHERE ID = ?";

    [SNDBHelper executeOperation:^(FMDatabase *db) {
        [db executeUpdate:sql, idNum];
        complete();
    }];
}

+ (void)updateTitle:(NSString *)title
            content:(NSString *)content
            isFavor:(NSString *)isFavor
         byOldTitle:(NSString *)oldTitle
         oldContent:(NSString *)oldContent
           complete:(void (^)())complete {
    NSString *sql = @"UPDATE INFO SET TITLE = ?, CONTENT = ?, ISFAVOR = ? WHERE TITLE = ? AND CONTENT = ?";
    
    [SNDBHelper executeOperation:^(FMDatabase *db) {
        [db executeUpdate: sql, title, content, isFavor, oldTitle, oldContent];
        complete();
    }];
}


@end
