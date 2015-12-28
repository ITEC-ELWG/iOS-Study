//
//  SWAddCityViewController.m
//  SimpleWeather
//
//  Created by zxy on 15/12/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWAddCityViewController.h"
#import "SWCityInfo.h"
#import "SWAllCitiesDBService.h"
static NSString *const cellIdentifier = @"UITableViewCell";

@interface SWAddCityViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@property (strong, nonatomic) NSMutableArray *cityNameLists;
@property (nonatomic, strong) NSMutableArray *cityData;
@property (nonatomic, strong) NSMutableArray *searchCityData;
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation SWAddCityViewController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityData = [[NSMutableArray alloc] init];
    self.isSearch = NO;

    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
    
    self.searchBar.delegate = self;
    
    [SWAllCitiesDBService getAllDataWithComplete:^(NSMutableArray *dbResults) {
        self.cityData = dbResults;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_cityTableView reloadData];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:_imageView.image forBarMetrics:UIBarMetricsCompactPrompt];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - Table view data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return [_searchCityData count];
    } else {
        return [_cityData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    SWCityInfo *cellItem = nil;
    //缓存池没有时，重新创建
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (_isSearch) {
        cellItem = _searchCityData[indexPath.row];
    } else {
        cellItem = _cityData[indexPath.row];
    }
    
    cell.textLabel.text = [cellItem.cityName stringByAppendingString:@" ,"];
    cell.textLabel.text = [cell.textLabel.text stringByAppendingString:cellItem.provinceName];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWCityInfo *selectCity = nil;
    
    if (_isSearch) {
        selectCity = _searchCityData[indexPath.row];
    } else {
        selectCity = _cityData[indexPath.row];
    }
    
    _currentCity(selectCity.cityName, selectCity.cityCode);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - SearchDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearch = YES;
    self.searchBar.showsCancelButton = YES;
}

//匹配关键字搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isSearch = NO;
    } else {
        self.isSearch = YES;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName BEGINSWITH %@ || provinceName BEGINSWITH %@ || cityPinyin BEGINSWITH %@", searchText, searchText, searchText];
        self.searchCityData = [[NSMutableArray alloc] initWithArray:[_cityData filteredArrayUsingPredicate:predicate]];
    }
    
    [_cityTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.isSearch = NO;
    self.searchBar.text = @"";
    
    [_cityTableView reloadData];
}

@end
