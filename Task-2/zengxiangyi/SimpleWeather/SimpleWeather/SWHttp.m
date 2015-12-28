//
//  SWHttp.m
//  SimpleWeather
//
//  Created by zxy on 15/12/28.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWHttp.h"

static NSString *const HTTPURL = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
static NSString *const APIKEY = @"apikey";
static NSString *const APIKEYVALUE = @"d826b9bf5289e2de1a99f938ab11f9fe";
static NSString *const HTTPARG = @"cityname=";

@implementation SWHttp

//将待查询的城市和城市代码转换成Unicode格式
+ (NSString *)encodeHttpArg: (NSString *)httpArg
               withCityCode:(NSString *)cityCode {
    httpArg = [httpArg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    httpArg = [HTTPARG stringByAppendingString:httpArg];
    httpArg = [httpArg stringByAppendingString:@"&cityid="];
    httpArg = [httpArg stringByAppendingString:cityCode];
    
    return httpArg;
}

+ (void)requestWithCityName:(NSString *)cityName cityCode:(NSString *)cityCode complete:(void (^)(NSString *))complete {
    __block NSString *responseString = nil;
    NSString *httpArg = [self encodeHttpArg:cityName withCityCode:cityCode];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", HTTPURL, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod: @"GET"];
    [request addValue:APIKEYVALUE forHTTPHeaderField: APIKEY];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error) {
                                                    responseString = nil;
                                                } else {
                                                    responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                }
                                                
                                                complete(responseString);
                                            }];
    
    [task resume];
}

@end
