//
//  ItemViewController.m
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNItemViewController.h"
#import "SNItemService.h"
#import "SNItem.h"
#import "SNDetailViewController.h"
#import "FMDB.h"
#import "SNDBService.h"

static NSString *const cellIdentifier = @"UITableViewCell";

@interface SNItemViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSMutableArray *filterData;
@property (nonatomic, assign) BOOL isFiltered; // 标识是否正在搜素
@property (nonatomic, retain) NSMutableArray *favorData;
@property (nonatomic, assign) BOOL isFavored; // 是否显示收藏列表
@property (nonatomic, strong) SNDetailViewController *detailViewController;

@end

@implementation SNItemViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self){
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"笔记本";
        
        //开启线程，载入数据库
        [SNDBService getAllData];
        self.data = [[SNItemService sharedStore] allItems];
        
        self.detailViewController = [[SNDetailViewController alloc] init];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //创建搜索栏
    [self createSearchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showAllItems];
}

#pragma mark 获取table中得行数和单元格信息

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 通过 isFiltered， isFavor区分当前的结果集
    if (_isFiltered) {
        return _filterData.count;
    }
    
    else if(_isFavored) {
        return _favorData.count;
    }
    
    else {
        return _data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据标识去缓存池中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    //缓存池没有时，重新创建
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    SNItem *cellItem = nil;

    // 通过 isFiltered， isFavor区分当前的结果集
    if (_isFiltered) {
        cellItem =  _filterData[indexPath.row];
    }
    
    else if (_isFavored) {
        cellItem =  _favorData[indexPath.row];
    }
    
    else {
        cellItem =  self.data[indexPath.row];
    }
    
    cell.textLabel.text = cellItem.title;
    cell.detailTextLabel.text = [cellItem description];

    return cell;
}

//选中某一行进入到详细内容的页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SNItem *selectedItem = nil;
    if (_isFiltered) {
        selectedItem = _filterData[indexPath.row];
    }
    
    else if (_isFavored) {
        selectedItem = _favorData[indexPath.row];
    }
    
    else {
        selectedItem = _data[indexPath.row];
    }
    
    _detailViewController = [self.detailViewController initDetailItem:NO];
    _detailViewController.item = selectedItem;
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_detailViewController];
        [self presentViewController:navController animated:YES completion:NULL];
    });
    
}

//显示所有的笔记
- (void)showAllItems {
    self.isFavored = NO;
    [self createToolbarItems];
    [self.tableView reloadData];
}

#pragma mark 增删操作

- (void)addNewItem {
    _detailViewController = [self.detailViewController initDetailItem:YES];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_detailViewController];
    //新页面压入栈
    [self presentViewController:navController animated:YES completion:NULL];
}

//删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //视图上的删除
        NSArray *items = [[SNItemService sharedStore] allItems];
        SNItem *item = items[indexPath.row];
        
        [[SNItemService sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //数据库中删除
        [SNDBService deleteDataByTitle:item.title content:item.detailText];
    }
}

#pragma mark 实现搜索的函数

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // 开始搜索时弹出 mask 并禁止 tableview 点击
    self.isFiltered = YES;
    searchBar.showsCancelButton = YES;
    self.mask.alpha = 0.3;
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    self.navigationController.toolbarHidden = YES;
}

//监听搜索栏的文本输入，并匹配关键字搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isFiltered = NO;
        self.mask.alpha = 0.3;
        self.tableView.allowsSelection = NO;
        self.tableView.scrollEnabled = NO;
        self.navigationController.toolbarHidden = YES;
    }
    
    else {
        self.isFiltered = YES;
        self.mask.alpha = 0;
        self.tableView.allowsSelection = YES;
        self.tableView.scrollEnabled = YES;
        self.navigationController.toolbarHidden = NO;
        self.data = [[SNItemService sharedStore] allItems];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@ || detailText contains %@",searchText, searchText];
        self.filterData =  [[NSMutableArray alloc] initWithArray:[self.data filteredArrayUsingPredicate:predicate]];
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    // 点击 cancel 时去掉 mask ,reloadData
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    [searchBar resignFirstResponder];
    self.mask.alpha = 0;
    self.isFiltered = NO;
    [self.tableView reloadData];
    self.navigationController.toolbarHidden = NO;
}

#pragma mark 显示收藏的笔记

- (void)showFavorItems {
    //点击收藏时，过滤出收藏的内容，再reloadData
    self.data = [[SNItemService sharedStore] allItems];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavor contains 'YES'"];
    self.favorData = [[NSMutableArray alloc] initWithArray:[self.data filteredArrayUsingPredicate:predicate]];
    self.isFavored = YES;
    
    [self.tableView reloadData];
    
    //修改工具栏的内容
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showAllItems)];
    
    self.toolbarItems = @[space, home, space];

}

#pragma mark 添加搜索栏和工具栏
//创建搜索视图，mask透明
- (void)createSearchBar {
    CGRect size = CGRectMake(0, 0, 320, 40);
    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:size];
    self.tableView.tableHeaderView = searchbar;
    searchbar.placeholder = @"搜索你的笔记";
    searchbar.delegate = self;
    
    self.mask = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    [self.view addSubview: self.mask];
    self.mask.backgroundColor = [UIColor blackColor];
    self.mask.alpha = 0;
}


- (void)createToolbarItems {
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showFavorItems)];
    NSArray *ary = @[space, addItem, space, favorite, space];
    self.toolbarItems = ary;
}

@end
