//
//  SWDBService.m
//  SimpleWeather
//
//  Created by zxy on 15/12/14.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWLocalListsDBService.h"
#import "SWDBHelper.h"
#import "SWLocalLists.h"

//数据库名和列名
static NSString *const DB_NAME = @"weather.sqlite";
static NSString *const DB_COLUMN_NAME_CITYNAME = @"cityName";
static NSString *const DB_COLUMN_NAME_CITYCODE = @"cityCode";

@implementation SWLocalListsDBService

+ (void)getAllDataWithBlockcompletion:(updateLists)updateItemblock {
    NSString *sql = @"SELECT * FROM LOCALCITIES";
    NSMutableArray *dbResults= [[NSMutableArray alloc] init];
    
    [SWDBHelper executeSelect:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            NSString *cityName = [result stringForColumn:DB_COLUMN_NAME_CITYNAME];
            NSString *cityCode = [result stringForColumn:DB_COLUMN_NAME_CITYCODE];
            SWLocalLists *newCity = [[SWLocalLists alloc] initWithCityName:cityName
                                                              cityCode:cityCode];
            [dbResults addObject:newCity];
        }
        updateItemblock(dbResults);
        [result close];
    }];
}

+ (void)addCityName:(NSString *)cityName
           cityCode:(NSString *)cityCode {
    NSString *sql = @"INSERT INTO LOCALCITIES (CITYNAME, CITYCODE) VALUES (?, ?)";
    [SWDBHelper executeUpdate:^(FMDatabase *db) {
        [db executeUpdate:sql, cityName, cityCode];
    }];
}

+ (void)deleteLocalListByCityCide:(NSString *)cityCode {
    NSString *sql = @"DELETE FROM LOCALCITIES WHERE CITYCODE = ?";
    [SWDBHelper executeUpdate:^(FMDatabase *db) {
        [db executeUpdate:sql, cityCode];
    }];
}
@end
