//
//  Item.m
//  SimpleNote
//
//  Created by zxy on 15/11/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "Item.h"
#import "ItemStore.h"

@interface Item ()


@end

@implementation Item


- (id)initWithItemTitle:(NSString *)title detailText:(NSString *)dtext
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        self.title = title;
        self.detailText = dtext;
        self.dateCreated = [[NSDate alloc] init];
        self.idNum =  [[ItemStore sharedStore] allItems].count + 1;
    }
    

    
    
    // Return the address of the newly initialized object
    return self;
}

- (id)init {
    return [self initWithItemTitle:@"title" detailText:@""];
}

- (NSString *)description
{

    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *displayTime = [dateformatter stringFromDate:self.dateCreated];
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@-<%@>:%@",
     displayTime,
     self.title, self.detailText];
    
    return descriptionString;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

@end
