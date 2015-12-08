//
//  Item.m
//  SimpleNote
//
//  Created by zxy on 15/11/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNItem.h"

@implementation SNItem

- (id)initWithItemTitle:(NSString *)title detailText:(NSString *)dtext idNum:(NSString *)idNum date:(NSString *)date isFavor:(NSString *)isFavor {
    self = [super init];
    if (self) {
        self.title = title;
        self.detailText = dtext;
        self.idNum = idNum;
        self.dateCreated = date;
        self.isFavor = isFavor;
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [self initWithItemTitle:@"" detailText:@"" idNum:@"" date:@"" isFavor:@""];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@]: %@", self.dateCreated, self.detailText];
}

@end
