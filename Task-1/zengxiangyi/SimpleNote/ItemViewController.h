//
//  ItemViewController.h
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface ItemViewController : UITableViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *data;
    NSMutableArray *filterData;
    BOOL isFiltered; // 标识是否正在搜素
    UIView *mask;
}
@property (nonatomic) sqlite3 *dataBase;
@property (nonatomic, strong) NSString *databasePath;

@end
