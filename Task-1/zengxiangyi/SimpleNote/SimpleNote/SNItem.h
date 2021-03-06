//
//  Item.h
//  SimpleNote
//
//  Created by zxy on 15/11/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic) NSInteger idNum;
@property (nonatomic) BOOL isFavor;

- (instancetype)initWithItemTitle:(NSString *)title
                       detailText:(NSString *)dtext
                            idNum:(NSInteger)idNum
                             date:(NSDate *)date
                          isFavor:(BOOL)isFavor;

- (NSString *)description;
@end
