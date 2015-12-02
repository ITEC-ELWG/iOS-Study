//
//  Item.m
//  SimpleNote
//
//  Created by zxy on 15/11/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNItem.h"

@implementation SNItem

- (id)initWithItemTitle:(NSString *)title detailText:(NSString *)dtext {
    self = [super init];
    if (self) {
        self.title = title;
        self.detailText = dtext;
        self.isFavor = Nil;
    }
    
    return self;
}

- (id)init {
    return [self initWithItemTitle:@"" detailText:@""];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@]: %@", self.dateCreated, self.detailText];
}

@end
