//
//  SWDBService.h
//  SimpleWeather
//
//  Created by zxy on 15/12/14.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
typedef void(^updateLists)(NSMutableArray *dbResults);

@interface SWLocalListsDBService : NSObject
+ (void)getAllDataWithBlockcompletion:(updateLists)updateItemblock;
+ (void)addCityName:(NSString *)cityName
           cityCode:(NSString *)cityCod;

+ (void)deleteLocalListByCityCide:(NSString *)cityCode;
@end
