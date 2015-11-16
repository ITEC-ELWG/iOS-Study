//
//  ItemViewController.m
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "ItemViewController.h"
#import "ItemStore.h"
#import "Item.h"
#import "DetailViewController.h"

@interface ItemViewController ()

@property (nonatomic, strong) IBOutlet UIView *footerView;

@end

@implementation ItemViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        //[[ItemStore sharedStore] createItem];
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"笔记本";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    
    CGRect size = CGRectMake(0, 0, 320, 40);
    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:size];
    self.tableView.tableHeaderView = searchbar;
    searchbar.placeholder = @"搜索你的笔记";
    searchbar.delegate = self;
    
    
    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    [self.view addSubview: mask];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editItem)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *ary = [[NSArray alloc] initWithObjects: space, addItem, space, editItem, space, nil];
    self.toolbarItems = ary;
    
    
    //创建数据库
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    self.databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"info.db"]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:self.databasePath] == NO) {
        const char *dbpath = [self.databasePath UTF8String];
        if (sqlite3_open(dbpath, &_dataBase)==SQLITE_OK) {
            char *errmsg;
            const char *createsql = "CREATE TABLE IF NOT EXISTS INFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE, CONTENT, DATE, IDNUM)";
            if (sqlite3_exec(self.dataBase, createsql, NULL, NULL, &errmsg)!=SQLITE_OK) {
                NSLog(@"create table failed.");
            }
        }
        else {
            NSLog(@"create/open failed.");
        }
    }
    
    
    //查询数据库
    const char *dbpath = [self.databasePath UTF8String];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_dataBase) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from info"];
        const char *querystatement = [querySQL UTF8String];
        if (sqlite3_prepare_v2(self.dataBase, querystatement, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                Item *newItem = [[ItemStore sharedStore] createItem];
                newItem.title = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                newItem.detailText = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                
                //字符串转换成date类型
                static NSDateFormatter *dateFormatter;
                if (!dateFormatter) {
                    dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
                    dateFormatter.timeStyle = NSDateFormatterNoStyle;
                }
                NSString *dateString = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                newItem.dateCreated = [dateFormatter dateFromString:dateString];
                //newItem.idNum = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                NSString *idNum = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                newItem.idNum = [idNum intValue];
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(self.dataBase);
    }
    
    
       
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    [self.tableView reloadData];
    NSLog(@"%@", [[ItemStore sharedStore] allItems]);
    data = [[ItemStore sharedStore] allItems];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    data = [[ItemStore sharedStore] allItems];
    
    // 通过 isFiltered 区分出当前显示的是搜索结果集还是原结果集
    if (isFiltered) {
        return filterData.count;
    }
    
    return [data count];
    //return [[[ItemStore sharedStore] allItems] count];


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    //NSArray *items = [[ItemStore sharedStore] allItems];
    //Item *item = items[indexPath.row];
    //cell.textLabel.text = [item description];
    
    
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // 通过 isFiltered 区分出当前显示的是搜索结果集还是原结果集
    if (isFiltered) {
        cell.textLabel.text = [filterData[indexPath.row] description];
    }else{
        cell.textLabel.text = [data[indexPath.row] description];
    }
    
    return cell;
    
    
    
}

//选中某一行进入到详细内容的页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    //新页面压入栈
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    NSArray *items = [[ItemStore sharedStore] allItems];
    Item *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    detailViewController.dataBase = self.dataBase;
    detailViewController.databasePath = self.databasePath;
    
    
    NSString *text;
    if (isFiltered) {
        text = filterData[indexPath.row];
    }else{
        text = data[indexPath.row];
    }
    
    NSLog(@"you click index:%d  %@",indexPath.row,text);


    
}

- (UIView *)footerView
{
    //如果没有载入headerView
    if (!_footerView) {
        [[NSBundle mainBundle] loadNibNamed:@"FooterView" owner:self options:nil];
    }
    return _footerView;
}

- (void)addNewItem
{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    sqlite3 *dataBase = self.dataBase;
    NSString *databasePath = self.databasePath;
    
    //新页面压入栈
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    //Item *newItem = [[ItemStore sharedStore] createItem];
    //detailViewController.item = newItem;
    detailViewController.dataBase = dataBase;
    detailViewController.databasePath = databasePath;
    
}

- (void)editItem
{
    if (self.isEditing) {
        //[self setTitle:@"Edit"];
        [self setEditing:NO animated:YES];
    }
    else {
        //[self setTitle:@"done"];
        [self setEditing:YES animated:YES];
    }
}

//删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //视图上的删除
        NSArray *items = [[ItemStore sharedStore] allItems];
        Item *item = items[indexPath.row];
        int deleteNum = item.idNum;
        [[ItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //数据库中删除
        sqlite3_stmt *statement;
        
        const char *dbpath = [self.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_dataBase)==SQLITE_OK) {
            
            
            NSString *insertSql = [NSString stringWithFormat:@"DELETE FROM INFO WHERE idnum = \"%d\"", deleteNum];
            const char *insertstaement = [insertSql UTF8String];
            sqlite3_prepare_v2(self.dataBase, insertstaement, -1, &statement, NULL);
            if (sqlite3_step(statement)==SQLITE_DONE) {
                NSLog(@"delete!");
            }
            else {
                NSLog(@"delete failed!");
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(self.dataBase);
            
        }

        
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}




- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // 开始搜索时弹出 mask 并禁止 tableview 点击
    NSLog(@"searchBarTextDidBeginEditing");
    isFiltered = YES;
    searchBar.showsCancelButton = YES;
    mask.alpha = 0.3;
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    self.navigationController.toolbarHidden = YES;

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"textDidChange");
    if (searchText.length == 0) {
        isFiltered = NO;
        mask.alpha = 0.3;
        self.tableView.allowsSelection = NO;
        self.tableView.scrollEnabled = NO;
        self.navigationController.toolbarHidden = YES;
        [self.tableView reloadData];
        return;
    }
    
    isFiltered = YES;
    mask.alpha = 0;
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    self.navigationController.toolbarHidden = NO;

    data = [[ItemStore sharedStore] allItems];
    // 谓词搜索
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@ || detailText contains %@",searchText];
    filterData =  [[NSMutableArray alloc] initWithArray:[data filteredArrayUsingPredicate:predicate]];
    NSLog(@"here%@", data);
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) sb{
    // 点击 cancel 时去掉 mask ,reloadData
    sb.text = @"";
    [sb setShowsCancelButton:NO animated:YES];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    [sb resignFirstResponder];
    mask.alpha = 0;
    isFiltered = NO;
    [self.tableView reloadData];
    self.navigationController.toolbarHidden = NO;

}


@end
