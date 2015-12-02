//
//  SNItemService.m
//  SimpleNote
//
//  Created by zxy on 15/12/2.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNItemService.h"
#import "SNItem.h"

@implementation SNItemService

+ (instancetype)sharedStore {
    static SNItemService *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [self alloc];
        sharedStore.allItems = [NSMutableArray new];
    });
    
    return sharedStore;
}

- (NSMutableArray *)allItems {
    return _allItems;
}

+ (SNItem *)createItem {
    SNItemService *sharedStore = [SNItemService sharedStore];
    SNItem *item = [[SNItem alloc] initWithItemTitle:@"" detailText:@""];
    [sharedStore.allItems addObject:item];
    
    return item;
}

- (void)removeItem:(SNItem *)item {
    [self.allItems removeObjectIdenticalTo:item];
}

@end
