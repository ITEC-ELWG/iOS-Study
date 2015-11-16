//
//  DetailViewController.h
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class Item;

@interface DetailViewController : UIViewController



@property (nonatomic, strong) Item *item;
@property (nonatomic) sqlite3 *dataBase;
@property (nonatomic, strong) NSString *databasePath;

@end
