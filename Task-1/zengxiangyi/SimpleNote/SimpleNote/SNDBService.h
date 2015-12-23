//
//  SNDBHelper.h
//  SimpleNote
//
//  Created by zxy on 15/11/18.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class SNItem;
@class SNItemService;
typedef void(^updateItem)(NSMutableArray *dbResults);

@interface SNDBService : NSObject

+ (void)getAllDataWithComplete:(updateItem)updateItemblock;

+ (void)deleteDataById:(NSString *)idNum
              complete:(void (^)())complete;

+ (void)addTitle:(NSString *)titleFieldText
         content:(NSString *)contentFieldText
            date:(NSString *)dateLabelText
         isFavor:(NSString *)isFavor
        complete:(void (^)())complete;

+ (void)updateTitle:(NSString *)title
            content:(NSString *)content
            isFavor:(NSString *)isFavor
         byOldTitle:(NSString *)oldTitle
         oldContent:(NSString *)oldContent
           complete:(void (^)())complete;

@end
