//
//  Item.h
//  SimpleNote
//
//  Created by zxy on 15/11/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

- (instancetype)initWithItemTitle:(NSString *)title
                       detailText:(NSString *)dtext;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic) int idNum;

@end
