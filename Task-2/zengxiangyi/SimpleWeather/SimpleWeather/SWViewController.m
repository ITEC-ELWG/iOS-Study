//
//  SWViewController.m
//  SimpleWeather
//
//  Created by zxy on 15/12/9.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SWViewController.h"
#import "SWAddCityViewController.h"
#import "SWLocalListViewController.h"
#import "SWTableViewCell.h"
#import "SWCityInfo.h"
#import "SWLocalLists.h"
#import "SWLocalListsDBService.h"
#import "SWAllCitiesDBService.h"
#import "SWHttp.h"

static NSString *const FILENAME = @"BaiduMap_cityCenter";

static NSString *const RETDATA = @"retData";
static NSString *const TODAY = @"today";
static NSString *const HISTORY = @"history";
static NSString *const FORECAST = @"forecast";
static NSString *const CITY = @"city";
static NSString *const TYPE = @"type";
static NSString *const CURTEMP = @"curTemp";
static NSString *const FENGLI = @"fengli";
static NSString *const FENGXIANG = @"fengxiang";

static NSString *const PROVINCE = @"省";
static NSString *const CITIES = @"市";
static NSString *const CITYNAME = @"市名";
static NSString *const CODE = @"编码";

static NSString *const HOMECITYNAME = @"homeCityName";
static NSString *const HOMECITYCODE = @"homeCityCode";

static NSString *const cellIdentifier = @"CellIdentifier";
static NSInteger const navigationHeight = 66;

@interface SWViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSDictionary *cityList;
@property (weak, nonatomic) IBOutlet UILabel *windDirection;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *weatherType;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (nonatomic, strong) NSMutableArray *sevenDaysData;
@property (nonatomic, strong) NSDictionary *backgroundImages;
@end

@implementation SWViewController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        //应用首次运行建立全国城市信息的数据库
        [SWAllCitiesDBService getAllDataWithComplete:^(NSMutableArray *dbResults) {
            if (![dbResults count]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self initAllCitiesDb];
                });
            }
        }];
    }
    
    return self;
}

//从文件中读取全国城市信息，保存到数据库
- (void)initAllCitiesDb {
    NSMutableArray *cityNameLists = [self getCityListFromText:FILENAME];
    NSInteger provinceNum = [cityNameLists count], cityNumInProvince = 0;
    NSInteger i = 0, j = 0;
    NSMutableArray *cityData = [[NSMutableArray alloc] init];
    
    for (i = 0; i < provinceNum; i++) {
        cityNumInProvince = [cityNameLists[i][CITIES] count];
        for (j = 0; j < cityNumInProvince; j++) {
            NSString *pinyinName = [self transformToPinyin:cityNameLists[i][CITIES][j][CITYNAME]];
            SWCityInfo *newCityInfo = [[SWCityInfo alloc] initWithProcinceName:cityNameLists[i][PROVINCE]
                                                                      cityName:cityNameLists[i][CITIES][j][CITYNAME]
                                                                      cityCode:cityNameLists[i][CITIES][j][CODE]
                                                                    cityPinyin:pinyinName];
            
            [cityData addObject:newCityInfo];
            
            [SWAllCitiesDBService insertprovinceName:newCityInfo.provinceName cityName:newCityInfo.cityName cityCode:newCityInfo.cityCode cityPinyin:newCityInfo.cityPinyin];
        }
    }
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sevenDaysData = [[NSMutableArray alloc] init];
    self.backgroundImages = [[NSDictionary alloc] init];
    self.backgroundImages = @{@"晴":@"sunbg",
                              @"霾":@"maibg",
                              @"多云":@"cloudbg",
                              @"阴":@"yinbg",
                              @"小雨":@"lightRainbg",
                              @"阵雨":@"rainbg",
                              @"中到大雨":@"rainbg",
                              @"小雪":@"snowbg",
                              @"中雪":@"snowbg",
                              @"阵雪":@"snowbg",
                              @"小到中雪":@"snowbg",
                              @"雾":@"fogbg"};

    //设置导航栏
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(manageCityLists)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:_tableView];
    
    //设置tableHeaderView
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SWHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = _headerView;
    
    //设置刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.tableView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blueColor]];
    
    SWLocalLists *homeCity = [self readNSUserDefaults];
    
    //默认城市为空，就进入添加页面设置
    if ([homeCity.cityName isEqualToString:@""] || !homeCity.cityName) {
        SWAddCityViewController *addController = [[SWAddCityViewController alloc] init];
        addController.currentCity = ^(NSString *cityName, NSString *cityCode) {
            [SWHttp requestWithCityName:cityName cityCode:cityCode complete:^(NSString *responseData) {
                [self setViewDataBy:responseData];
            }];
            
            //将增加的城市添加到本地城市列表
            [SWLocalListsDBService addCityName:cityName cityCode:cityCode];
            
            //设置为默认城市
            [self saveUserDefaults:cityName andCityCode:cityCode];
        };
        
        [self.navigationController pushViewController:addController animated:YES];
    } else {
        [SWHttp requestWithCityName:homeCity.cityName cityCode:homeCity.cityCode complete:^(NSString *responseData) {
            [self setViewDataBy:responseData];
        }];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.tableView.frame = bounds;
}

#pragma mark - Table view data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sevenDaysData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SWTableViewCell" owner:self options:nil] lastObject];
    }
    
    [cell configFortTable: _sevenDaysData[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger cellCount = _sevenDaysData.count;;
    
    return (screenHeight - navigationHeight)/cellCount;;
}

#pragma mark - NSUserDefaults

- (void)saveUserDefaults:(NSString *)cityName andCityCode:(NSString *)cityCode {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cityName forKey:HOMECITYNAME];
    [userDefaults setObject:cityCode forKey:HOMECITYCODE];
}

-(SWLocalLists *)readNSUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [userDefaults valueForKey:HOMECITYNAME];
    NSString *cityCode = [userDefaults valueForKey:HOMECITYCODE];
    SWLocalLists *homeCity = [[SWLocalLists alloc] initWithCityName:cityName cityCode:cityCode];
    
    return homeCity;
}

#pragma mark - Private methods
//刷新
-(void)refreshStateChange:(UIRefreshControl *)control
{
    SWLocalLists *currentCity = [self readNSUserDefaults];
    
    [SWHttp requestWithCityName:currentCity.cityName cityCode:currentCity.cityCode complete:^(NSString *responseData) {
        [self setViewDataBy:responseData];
    }];
    
    [control endRefreshing];
}

- (void)manageCityLists {
    SWLocalListViewController *listController = [[SWLocalListViewController alloc] init];
    listController.homeCity = _cityName.text;
    listController.currentCity = ^(NSString *cityName, NSString *cityCode) {
        [self saveUserDefaults:cityName andCityCode:cityCode];
    };
    
    [self.navigationController pushViewController:listController animated:YES];
}

//从文件中读取城市数据，转换为数组对象
- (NSMutableArray *)getCityListFromText:(NSString *)path {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"txt"];
    NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}

//汉字转换为拼音
- (NSString *)transformToPinyin:(NSString *)name {
    NSMutableString *mutableString = [NSMutableString stringWithString:name];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    //去掉拼音之间的空格，比如wu han转换为wuhan
    return [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)setViewDataBy:(NSString *)cityWeatherData {
    //转换成字典对象
    NSMutableDictionary *currentCityInfo = [self transformToDic:cityWeatherData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cityName.text = currentCityInfo[RETDATA][CITY];
        self.weatherType.text = currentCityInfo[RETDATA][TODAY][TYPE];
        self.temperature.text = currentCityInfo[RETDATA][TODAY][CURTEMP];
        self.windDirection.text = currentCityInfo[RETDATA][TODAY][FENGXIANG];
        self.windSpeed.text = currentCityInfo[RETDATA][TODAY][FENGLI];
        
        [_sevenDaysData removeAllObjects];
        [_sevenDaysData addObjectsFromArray:currentCityInfo[RETDATA][HISTORY]];
        [_sevenDaysData addObject:currentCityInfo[RETDATA][TODAY]];
        [_sevenDaysData addObjectsFromArray:currentCityInfo[RETDATA][FORECAST]];
        
        [_sevenDaysData removeObjectsInRange:NSMakeRange(0, 5)];

        self.backgroundView.image = [UIImage imageNamed:_backgroundImages[self.weatherType.text]];
        [self.navigationController.navigationBar setBackgroundImage:_backgroundView.image forBarMetrics:UIBarMetricsCompactPrompt];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        
        [_tableView reloadData];
    });
}

//将json数据转换成dictionary对象
- (NSMutableDictionary *)transformToDic:(NSString *)jsonString {
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}

@end

