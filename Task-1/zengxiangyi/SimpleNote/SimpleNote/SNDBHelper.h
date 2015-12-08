//
//  SNDBHelper.h
//  SimpleNote
//
//  Created by zxy on 15/11/18.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

typedef void (^db_block)(FMDatabase *db);


@interface SNDBHelper : NSObject
+ (void)executeSelect:(db_block)block;
+ (void)executeUpdate:(db_block)block;
@end
