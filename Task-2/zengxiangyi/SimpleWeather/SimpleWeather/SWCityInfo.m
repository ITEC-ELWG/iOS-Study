//
//  SWCityInfo.m
//  SimpleWeather
//
//  Created by zxy on 15/12/10.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWCityInfo.h"

@implementation SWCityInfo

- (instancetype)initWithProcinceName:(NSString *)provinceName cityName:(NSString *)cityName cityCode:(NSString *)cityCode cityPinyin:(NSString *)cityPinyin {
    self.provinceName = provinceName;
    self.cityName = cityName;
    self.cityCode = cityCode;
    self.cityPinyin = cityPinyin;
    
    return self;
}

@end
