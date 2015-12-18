//
//  SWLocalLists.h
//  SimpleWeather
//
//  Created by zxy on 15/12/14.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWLocalLists : NSObject
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *ifHome;

- (instancetype)initWithCityName:(NSString *)cityName
                        cityCode:(NSString *)cityCode;
@end
