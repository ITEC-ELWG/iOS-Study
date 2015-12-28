//
//  SWTableViewCell.m
//  SimpleWeather
//
//  Created by zxy on 15/12/11.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWTableViewCell.h"
static NSString *const WEEK = @"week";
static NSString *const TYPE = @"type";
static NSString *const DATE = @"date";
@interface SWTableViewCell()

@end

@implementation SWTableViewCell

- (void)configFortTable:(NSMutableDictionary *)data {
    static NSDictionary *weatherImages;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weatherImages = @{@"晴":@"sun",
                          @"霾":@"mai",
                          @"多云":@"duoyun",
                          @"阴":@"yin",
                          @"小雨":@"xiaoyu",
                          @"阵雨":@"zhenyu",
                          @"中到大雨":@"zhenyu",
                          @"小雪":@"xiaoxue",
                          @"中雪":@"zhongxue",
                          @"阵雪":@"zhongxue",
                          @"小到中雪":@"zhongxue",
                          @"雾":@"wu"};
    });
    
    self.week.text = data[WEEK];
    self.type.text = data[TYPE];
    self.date.text = data[DATE];
    
    if (_type.text) {
        self.typeIcon.image = [UIImage imageNamed:weatherImages[_type.text]];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
}

@end

