//
//  SWAllCitiesDBService.h
//  SimpleWeather
//
//  Created by zxy on 15/12/14.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
typedef void(^updateLists)(NSMutableArray *dbResults);

@interface SWAllCitiesDBService : NSObject
+ (void)getAllDataWithComplete:(updateLists)updateItemblock;
+ (void)insertprovinceName:(NSString *)provinceName
                  cityName:(NSString *)cityName
                  cityCode:(NSString *)cityCode
                cityPinyin:(NSString *)cityPinyin;
@end
