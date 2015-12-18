//
//  SWLocalListViewController.m
//  SimpleWeather
//
//  Created by zxy on 15/12/10.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWLocalListViewController.h"
#import "SWAddCityViewController.h"
#import "SWLocalLists.h"
#import "SWLocalListsDBService.h"
static NSString *const cellIdentifier = @"UITableViewCell";

@interface SWLocalListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *localList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@end

@implementation SWLocalListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addNewCity)];
        self.localList = [[NSMutableArray alloc] init];
        
        [SWLocalListsDBService getAllDataWithBlockcompletion:^(NSMutableArray *dbResults) {
            self.localList = dbResults;
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"管理城市";
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.backgroundView.image = [UIImage imageNamed:@"nightbg"];
    [self.navigationController.navigationBar setBackgroundImage:_backgroundView.image forBarMetrics:UIBarMetricsCompactPrompt];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.localList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    SWLocalLists *cellItem = _localList[indexPath.row];
    cell.textLabel.text = cellItem.cityName;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWLocalLists *selectCity = _localList[indexPath.row];
    _currentCity(selectCity.cityName, selectCity.cityCode);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SWLocalLists *item = _localList[indexPath.row];
        [self.localList removeObjectIdenticalTo:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //在数据库中删除
        [SWLocalListsDBService deleteLocalListByCityCide:item.cityCode];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        //如果本地城市列表为空的话，就进入添加城市页面
        if (![self.localList count]) {
            [userDefaults setObject:@"" forKey:@"homeCityName"];
            [userDefaults setObject:@"" forKey:@"homeCityCode"];
            [self addNewCity];
        }
        else {
            if ([_homeCity isEqualToString:item.cityName]) {
                SWLocalLists *newHomeCity = _localList[0];
                [userDefaults setObject:newHomeCity.cityName forKey:@"homeCityName"];
                [userDefaults setObject:newHomeCity.cityCode forKey:@"homeCityCode"];
            }
        }
    }
}

//添加城市
- (void)addNewCity {
    SWAddCityViewController *addCityController = [[SWAddCityViewController alloc] init];

    addCityController.currentCity = ^(NSString *cityName, NSString *cityCode){
        _currentCity(cityName, cityCode);
        
        SWLocalLists *newCityInfo = [[SWLocalLists alloc] init];
        newCityInfo.cityName = cityName;
        newCityInfo.cityCode = cityCode;
        [self.localList addObject:newCityInfo];
        [SWLocalListsDBService addCityName:cityName cityCode:cityCode];

        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addCityController animated:YES];
}

@end
