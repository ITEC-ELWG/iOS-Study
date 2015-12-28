//
//  SWHttp.h
//  SimpleWeather
//
//  Created by zxy on 15/12/28.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWHttp : NSObject
+ (NSString *)encodeHttpArg: (NSString *)httpArg
               withCityCode:(NSString *)cityCode;

+ (void)requestWithCityName: (NSString *)cityName
                   cityCode: (NSString *)cityCode
                   complete: (void (^)(NSString *))complete;

@end
