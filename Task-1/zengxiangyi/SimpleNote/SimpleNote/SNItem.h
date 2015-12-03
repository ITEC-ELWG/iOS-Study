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
@property (nonatomic, strong) NSString *dateCreated;
@property (nonatomic) NSString *idNum;
@property (nonatomic) NSString *isFavor;

- (instancetype)initWithItemTitle:(NSString *)title
                       detailText:(NSString *)dtext;

- (NSString *)description;
@end
