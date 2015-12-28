//
//  SWAllCitiesDBService.m
//  SimpleWeather
//
//  Created by zxy on 15/12/14.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWAllCitiesDBService.h"
#import "SWDBHelper.h"
#import "SWCityInfo.h"
//数据库名和列名
static NSString *const DB_COLUMN_NAME_PROVINCENAME = @"provinceName";
static NSString *const DB_COLUMN_NAME_CITYNAME = @"cityName";
static NSString *const DB_COLUMN_NAME_CITYCODE = @"cityCode";
static NSString *const DB_COLUMN_NAME_CITYPINYIN = @"cityPinyin";
@implementation SWAllCitiesDBService

+ (void)getAllDataWithComplete:(updateLists)updateItemblock {
    NSString *sql = @"SELECT * FROM ALLCITIES";
    NSMutableArray *dbResults= [[NSMutableArray alloc] init];
    
    [SWDBHelper executeSelect:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            NSString *provinceName = [result stringForColumn:DB_COLUMN_NAME_PROVINCENAME];
            NSString *cityName = [result stringForColumn:DB_COLUMN_NAME_CITYNAME];
            NSString *cityCode = [result stringForColumn:DB_COLUMN_NAME_CITYCODE];
            NSString *cityPinyin = [result stringForColumn:DB_COLUMN_NAME_CITYPINYIN];
            SWCityInfo *newCity = [[SWCityInfo alloc] initWithProcinceName:provinceName cityName:cityName cityCode:cityCode cityPinyin:cityPinyin];
            [dbResults addObject:newCity];
        }
        updateItemblock(dbResults);
        [result close];
    }];
}

+ (void)insertprovinceName:(NSString *)provinceName cityName:(NSString *)cityName cityCode:(NSString *)cityCode cityPinyin:(NSString *)cityPinyin {
    NSString *sql = @"INSERT INTO ALLCITIES (PROVINCENAME, CITYNAME, CITYCODE, CITYPINYIN) VALUES (?, ?, ?, ?)";
    [SWDBHelper executeSelect:^(FMDatabase *db) {
        [db executeUpdate:sql, provinceName, cityName, cityCode, cityPinyin];
    }];
}

@end
