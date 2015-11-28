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

@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) FMDatabaseQueue *queue;
@property (nonatomic, strong) dispatch_queue_t dispachQueue;

+ (id)sharedDataBase;

- (void)createTable;

- (void)getAllData;

- (void)deleteDataByTitle:(NSString *)title content:(NSString *)content;

- (void)addTitle:(NSString *)titleFieldText content:(NSString *)contentFieldText date:(NSString *)dateLabelText isFavor:(NSString *)isFavor;

- (void)updateTitle:(NSString *)title content:(NSString *)content isFavor:(NSString *)isFavor byOldTitle:(NSString *)oldTitle oldContent:(NSString *)oldContent;
@end
