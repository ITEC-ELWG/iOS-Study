//
//  SWLocalLists.m
//  SimpleWeather
//
//  Created by zxy on 15/12/14.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWLocalLists.h"

@implementation SWLocalLists
- (instancetype)initWithCityName:(NSString *)cityName
                        cityCode:(NSString *)cityCode {
    self = [super init];
    if (self) {
        self.cityName = cityName;
        self.cityCode = cityCode;
    }
    
    return self;
}
@end
