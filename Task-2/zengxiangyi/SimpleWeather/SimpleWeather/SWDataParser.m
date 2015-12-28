//
//  SWDataParser.m
//  SimpleWeather
//
//  Created by zxy on 15/12/28.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWDataParser.h"
#import "SWCityInfo.h"
#import "SWAllCitiesDBService.h"

static NSString *const FILENAME = @"BaiduMap_cityCenter";
static NSString *const PROVINCE = @"省";
static NSString *const CITIES = @"市";
static NSString *const CITYNAME = @"市名";
static NSString *const CODE = @"编码";

@implementation SWDataParser

//从文件中读取全国城市信息，保存到数据库
+ (void)initAllCitiesDb {
    NSMutableArray *cityNameLists = [self getCityListFromText:FILENAME];
    NSInteger provinceNum = [cityNameLists count], cityNumInProvince = 0;
    NSInteger i = 0, j = 0;
    
    for (i = 0; i < provinceNum; i++) {
        cityNumInProvince = [cityNameLists[i][CITIES] count];
        for (j = 0; j < cityNumInProvince; j++) {
            NSString *pinyinName = [self transformToPinyin:cityNameLists[i][CITIES][j][CITYNAME]];
            SWCityInfo *newCityInfo = [[SWCityInfo alloc] initWithProcinceName:cityNameLists[i][PROVINCE]
                                                                      cityName:cityNameLists[i][CITIES][j][CITYNAME]
                                                                      cityCode:cityNameLists[i][CITIES][j][CODE]
                                                                    cityPinyin:pinyinName];
            
            
            [SWAllCitiesDBService insertprovinceName:newCityInfo.provinceName cityName:newCityInfo.cityName cityCode:newCityInfo.cityCode cityPinyin:newCityInfo.cityPinyin];
        }
    }
}


//从文件中读取城市数据，转换为数组对象
+ (NSMutableArray *)getCityListFromText:(NSString *)path {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"txt"];
    NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}

//汉字转换为拼音
+ (NSString *)transformToPinyin:(NSString *)name {
    NSMutableString *mutableString = [NSMutableString stringWithString:name];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    //去掉拼音之间的空格，比如wu han转换为wuhan
    return [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
