//
//  SWLocalListViewController.h
//  SimpleWeather
//
//  Created by zxy on 15/12/10.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWAddCityViewController.h"
@interface SWLocalListViewController : UIViewController
@property (nonatomic, strong) void (^currentCity)(NSString *cityName, NSString *cityCode);
@property (nonatomic, strong) NSString *homeCity;
@end
