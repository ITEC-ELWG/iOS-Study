//
//  SWDBHelper.h
//  SimpleWeather
//
//  Created by zxy on 15/12/14.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

typedef void (^db_block)(FMDatabase *db);

@interface SWDBHelper : NSObject

+ (void)executeOperation:(db_block)block;

@end
