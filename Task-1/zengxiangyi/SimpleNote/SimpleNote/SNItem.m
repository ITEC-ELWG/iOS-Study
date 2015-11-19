//
//  Item.m
//  SimpleNote
//
//  Created by zxy on 15/11/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNItem.h"

@interface SNItem ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation SNItem

- (id)initWithItemTitle:(NSString *)title detailText:(NSString *)dtext
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.detailText = dtext;
    }
    
    return self;
}

- (id)init
{
    return [self initWithItemTitle:@"" detailText:@""];
}


+ (instancetype)sharedStore
{
    static SNItem *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
   return sharedStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self)
    {
        self.privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (SNItem *)createItem
{
    SNItem *item = [[SNItem alloc] initWithItemTitle:@"" detailText:@""];
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(SNItem *)item
{
    [self.privateItems removeObjectIdenticalTo:item];
}




@end
