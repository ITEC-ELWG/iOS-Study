//
//  SNTableViewCell.h
//  SimpleNote
//
//  Created by zxy on 15/12/25.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SNItem;
@interface SNTableViewCell : UITableViewCell
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (void)configTableCell:(SNItem *)data;
@end
