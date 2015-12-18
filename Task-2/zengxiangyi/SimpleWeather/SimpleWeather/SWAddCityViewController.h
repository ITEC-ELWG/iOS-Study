//
//  SWAddCityViewController.h
//  SimpleWeather
//
//  Created by zxy on 15/12/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWAddCityViewController : UIViewController
@property (nonatomic, strong) void (^currentCity)(NSString *cityName, NSString *cityCode);
@end
