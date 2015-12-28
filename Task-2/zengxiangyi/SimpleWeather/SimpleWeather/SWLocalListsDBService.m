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

+ (void)getAllDataWithComplete:(updateLists)updateItemblock {
    NSString *sql = @"SELECT * FROM LOCALCITIES";
    NSMutableArray *dbResults= [[NSMutableArray alloc] init];
    
    [SWDBHelper executeOperation:^(FMDatabase *db) {
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

+ (void)insertCityName:(NSString *)cityName
              cityCode:(NSString *)cityCode
              complete:(void (^)())complete {
    NSString *sql = @"INSERT INTO LOCALCITIES (CITYNAME, CITYCODE) VALUES (?, ?)";
    [SWDBHelper executeOperation:^(FMDatabase *db) {
        [db executeUpdate:sql, cityName, cityCode];
        complete();
    }];
}

+ (void)deleteLocalListByCityCide:(NSString *)cityCode
                         complete:(void (^)())complete {
    NSString *sql = @"DELETE FROM LOCALCITIES WHERE CITYCODE = ?";
    [SWDBHelper executeOperation:^(FMDatabase *db) {
        [db executeUpdate:sql, cityCode];
        complete();
    }];
}

@end
