//
//  ItemStore.h
//  SimpleNote
//
//  Created by zxy on 15/11/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface ItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;

- (Item *)createItem;

- (void)removeItem:(Item *)item;

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
