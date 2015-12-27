//
//  Item.m
//  SimpleNote
//
//  Created by zxy on 15/11/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNItem.h"

@implementation SNItem

- (instancetype)initWithItemTitle:(NSString *)title detailText:(NSString *)dtext idNum:(NSInteger)idNum date:(NSDate *)date isFavor:(BOOL)isFavor{
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

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@]: %@", self.dateCreated, self.detailText];
}

@end
