//
//  SNDBHelper.h
//  SimpleNote
//
//  Created by zxy on 15/11/18.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "SNItem.h"

@interface SNDBHelper : NSObject

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic, copy) NSString *dbPath;

+ (id)sharedDataBase;

- (void)createTable;

- (void)getAllData;

- (void)deleteData:(NSString *)deleteID;

- (void)addTitle:(NSString *)titleFieldText content:(NSString *)contentFieldText date:(NSString *)dateLabelText;

- (void)updateTitle:(NSString *)title content:(NSString *)content by:(NSString *)ID;
@end
