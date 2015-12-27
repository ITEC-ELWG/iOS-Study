//
//  ItemViewController.m
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNItemViewController.h"
#import "SNItem.h"
#import "SNDetailViewController.h"
#import "FMDB.h"
#import "SNDBService.h"
#import "SNTableViewCell.h"

static NSString *const cellIdentifier = @"UITableViewCell";

@interface SNItemViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) SNDetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *filterData;
@property (nonatomic, retain) NSMutableArray *favorData;

@property (nonatomic, assign) BOOL isFiltered; // 标识是否正在搜素
@property (nonatomic, assign) BOOL isFavored; // 是否显示收藏列表

@property (nonatomic, strong) NSArray *originToolBarItems;
@property (nonatomic, strong) NSArray *favorToolBarItems;

@property (nonatomic, strong) NSPredicate *favorPredicate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation SNItemViewController

#pragma mark - Init

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        self.detailViewController = [[SNDetailViewController alloc] init];
        _detailViewController.dateFormatter = _dateFormatter;
        
    }
    
    return self;
}

//创建搜索视图，mask透明
- (void)createSearchBar {
    CGRect size = CGRectMake(0, 0, self.view.frame.size.width, 40);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:size];
    
    searchBar.placeholder = @"搜索你的笔记";
    searchBar.delegate = self;
    
    self.tableView.tableHeaderView = searchBar;
    
    self.mask = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    self.mask.backgroundColor = [UIColor blackColor];
    self.mask.alpha = 0;
    
    [self.view addSubview: _mask];
}

- (NSArray *)configOriginToolBarItems {
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showFavorItems)];
    
    NSArray *ary = @[space, addItem, space, favorite, space];
    
    return ary;
}

- (NSArray *)configFavorToolBarItems {
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showAllItems)];
    
    NSArray *ary = @[space, home, space];
    
    return ary;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.originToolBarItems = [self configOriginToolBarItems];
    self.favorToolBarItems = [self configFavorToolBarItems];
    
    self.favorPredicate = [NSPredicate predicateWithFormat:@"isFavor == YES"];
    
    self.navigationController.toolbarHidden = NO;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //创建搜索栏
    [self createSearchBar];
    [self showAllItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //查询数据库
    [SNDBService getAllDataWithComplete:^(NSMutableArray *dbResults) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.data = dbResults;
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // 通过 isFiltered， isFavor区分当前的结果集
    if (_isFiltered) {
        return _filterData.count;
    } else if(_isFavored) {
        return _favorData.count;
    } else {
        return _data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据标识去缓存池中取
    SNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    //缓存池没有时，重新创建
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SNTableViewCell" owner:self options:nil] lastObject];
    }
    
    SNItem *cellItem = nil;

    // 通过 isFiltered， isFavor区分当前的结果集
    if (_isFiltered) {
        cellItem =  _filterData[indexPath.row];
    } else if (_isFavored) {
        cellItem =  _favorData[indexPath.row];
    } else {
        cellItem =  _data[indexPath.row];
    }
    
    cell.dateFormatter = _dateFormatter;
    [cell configTableCell:cellItem];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


//选中某一行进入到详细内容的页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SNItem *selectedItem = nil;
    
    if (_isFiltered) {
        selectedItem = _filterData[indexPath.row];
    } else if (_isFavored) {
        selectedItem = _favorData[indexPath.row];
    } else {
        selectedItem = _data[indexPath.row];
    }
    
    self.detailViewController.item = selectedItem;
    self.detailViewController = [_detailViewController initDetailItem:NO];
    
    [self.navigationController pushViewController:_detailViewController animated:YES];
}

//选中删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SNItem *item = nil;
        if (_isFavored) {
            item = _favorData[indexPath.row];
        } else {
            item = _data[indexPath.row];
        }
        
        //数据库中删除
        dispatch_async(dispatch_get_main_queue(), ^{
            [SNDBService deleteDataById:item.idNum
                               complete:^{
                                   //视图上的删除
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       if (_isFavored) {
                                           [_favorData removeObjectIdenticalTo:item];
                                       } else {
                                           [_data removeObjectIdenticalTo:item];
                                       }
                                       
                                       [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                   });
                               }];
        });
    }
}

#pragma mark - Search delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // 开始搜索时弹出 mask 并禁止 tableview 点击
    searchBar.showsCancelButton = YES;
    
    self.isFiltered = YES;
    self.mask.alpha = 0.3;
    
    self.tableView.scrollEnabled = NO;
    
    self.navigationController.toolbarHidden = YES;
}

//监听搜索栏的文本输入，并匹配关键字搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isFiltered = NO;
        self.mask.alpha = 0.3;
        
        self.navigationController.toolbarHidden = YES;
        
        self.tableView.scrollEnabled = NO;
    } else {
        self.isFiltered = YES;
        self.mask.alpha = 0;
        
        self.navigationController.toolbarHidden = NO;
        
        self.tableView.scrollEnabled = YES;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@ || detailText contains %@", searchText, searchText];
        self.filterData =  [[NSMutableArray alloc] initWithArray:[_data filteredArrayUsingPredicate:predicate]];
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    // 点击 cancel 时去掉 mask ,reloadData
    
    self.mask.alpha = 0;
    self.isFiltered = NO;
    self.navigationController.toolbarHidden = NO;
    
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
}

#pragma mark - Private methods

//显示所有的笔记
- (void)showAllItems {
    self.isFavored = NO;
    
    [SNDBService getAllDataWithComplete:^(NSMutableArray *dbResults) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.data = dbResults;
            [self.tableView reloadData];
        });
    }];
    
    self.navigationItem.title = @"笔记本";
    self.toolbarItems = _originToolBarItems;
    
    [self.tableView reloadData];
}

- (void)addNewItem {
    self.detailViewController = [_detailViewController initDetailItem:YES];
    
    //新页面压入栈
    [self.navigationController pushViewController:_detailViewController animated:YES];
}

//删除操作


- (void)showFavorItems {
    self.isFavored = YES;
    self.favorData = [[NSMutableArray alloc] initWithArray:[_data filteredArrayUsingPredicate:_favorPredicate]];

    self.navigationItem.title = @"收藏夹";
    self.toolbarItems = _favorToolBarItems;

    [self.tableView reloadData];
}

@end
