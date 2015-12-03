//
//  SNItemService.h
//  SimpleNote
//
//  Created by zxy on 15/12/2.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNItem;

@interface SNItemService : NSObject

@property (nonatomic, strong) NSMutableArray *allItems;

+ (instancetype)sharedStore;

+ (SNItem *)createItem;

- (void)removeItem:(SNItem *)item;

@end
