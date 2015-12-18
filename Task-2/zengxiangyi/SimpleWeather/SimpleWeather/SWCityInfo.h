//
//  SWCityInfo.h
//  SimpleWeather
//
//  Created by zxy on 15/12/10.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWCityInfo : NSObject

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityPinyin;
@property (nonatomic, copy) NSString *cityCode;

- (instancetype)initWithProcinceName:(NSString *)provinceName
                            cityName:(NSString *)cityName
                            cityCode:(NSString *)cityCode
                          cityPinyin:(NSString *)cityPinyin;

@end
