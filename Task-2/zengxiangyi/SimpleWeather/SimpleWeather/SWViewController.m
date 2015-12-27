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

static NSString *const HTTPURL = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
static NSString *const FILENAME = @"BaiduMap_cityCenter";
static NSString *const APIKEY = @"apikey";
static NSString *const APIKEYVALUE = @"d826b9bf5289e2de1a99f938ab11f9fe";
static NSString *const HTTPARG = @"cityname=";

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

- (instancetype)init {
    self = [super init];
    if (self) {
        //查询全国城市信息，
        [SWAllCitiesDBService getAllDataWithBlockcompletion:^(NSMutableArray *dbResults) {
            if (![dbResults count]) {
                dispatch_sync(dispatch_get_main_queue(), ^{

                [self initAllCitiesDb];
                });
            }
        }];
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
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(manageCityList)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
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
    
    //根据默认城市，查询天气
    SWLocalLists *homeCity = [self readNSUserDefaults];
    if ([homeCity.cityName isEqualToString:@""] || !homeCity.cityName) {
        SWAddCityViewController *addController = [[SWAddCityViewController alloc] init];
        addController.currentCity = ^(NSString *cityName, NSString *cityCode) {
            [self encodeHttpArg:cityName withCityCode:cityCode];
            
            //将增加的城市添加到本地城市列表，并设置为默认城市
            [SWLocalListsDBService addCityName:cityName cityCode:cityCode];
            [self saveUserDefaults:cityName andCityCode:cityCode];
        };
        [self.navigationController pushViewController:addController animated:YES];
    }
    
    else {
        [self encodeHttpArg:homeCity.cityName withCityCode:homeCity.cityCode];
    }
}

//刷新
-(void)refreshStateChange:(UIRefreshControl *)control
{
    SWLocalLists *currentCity = [self readNSUserDefaults];
    [self encodeHttpArg:currentCity.cityName withCityCode:currentCity.cityCode];
    [control endRefreshing];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.tableView.frame = bounds;
}


#pragma mark 导航栏函数
- (void)manageCityList {
    SWLocalListViewController *listController = [[SWLocalListViewController alloc] init];
    listController.homeCity = _cityName.text;
    listController.currentCity = ^(NSString *cityName, NSString *cityCode) {
        [self saveUserDefaults:cityName andCityCode:cityCode];
        [self encodeHttpArg:cityName withCityCode:cityCode];
        [self saveUserDefaults:cityName andCityCode:cityCode];
    };
    [self.navigationController pushViewController:listController animated:YES];
}

#pragma mark 全国城市信息处理
- (void)initAllCitiesDb {
    NSMutableArray *cityNameLists = [self getCityListFromText:FILENAME];
    NSInteger provinceNum = [cityNameLists count], cityNumInProvince = 0;
    NSUInteger i = 0, j = 0;
    NSMutableArray *cityData = [[NSMutableArray alloc] init];
    
    for (i = 0; i < provinceNum; i++) {
        cityNumInProvince = [cityNameLists[i][CITIES] count];
        for (j = 0; j < cityNumInProvince; j++) {
            SWCityInfo *newCityInfo = [[SWCityInfo alloc] init];
            newCityInfo.provinceName  = cityNameLists[i][PROVINCE];
            newCityInfo.cityName = cityNameLists[i][CITIES][j][CITYNAME];
            newCityInfo.cityCode = cityNameLists[i][CITIES][j][CODE];
            newCityInfo.cityPinyin = [self transformToPinyin:newCityInfo.cityName];
            [cityData addObject:newCityInfo];
            [SWAllCitiesDBService insertprovinceName:newCityInfo.provinceName cityName:newCityInfo.cityName cityCode:newCityInfo.cityCode cityPinyin:newCityInfo.cityPinyin];
        }
    }
}

//从文件中读取城市数据，转换为数组对象
- (NSMutableArray *)getCityListFromText:(NSString *)path {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"txt"];
    NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}

- (NSString *)transformToPinyin:(NSString *)name {
    NSMutableString *mutableString = [NSMutableString stringWithString:name];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    return [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark 存取NSUserDefaults

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

#pragma mark table数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sevenDaysData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SWTableViewCell" owner:self options:nil] lastObject];
    }
    
    [cell configFortTable: _sevenDaysData[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger navHeight = 66;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return (screenHeight - navHeight)/cellCount;
}

#pragma mark HTTP请求获取天气数据
//将待查询的城市和城市代码转换成Unicode格式
- (void)encodeHttpArg: (NSString *)httpArg
         withCityCode:(NSString *)cityCode {
    httpArg= [self encodeString:httpArg];
    httpArg = [HTTPARG stringByAppendingString:httpArg];
    httpArg = [httpArg stringByAppendingString:@"&cityid="];
    httpArg = [httpArg stringByAppendingString:cityCode];
    [self request:HTTPURL withHttpArg:httpArg];
}

- (NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedString;
}

- (void)request: (NSString*)httpUrl withHttpArg: (NSString *)HttpArg  {
    __block NSString *responseString = nil;
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod: @"GET"];
    [request addValue: APIKEYVALUE forHTTPHeaderField: APIKEY];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error) {
                                          responseString = nil;
                                      }
                                      else {
                                          responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          [self getWeatherDataByCityName:responseString];
                                      }
                                  }];
    
    [task resume];
}

#pragma mark 解析返回的json数据

- (void)getWeatherDataByCityName:(NSString *)cityWeatherData {
    //转换成字典对象
    NSMutableDictionary *currentCityInfo = [self transformToDic:cityWeatherData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cityName.text = currentCityInfo[RETDATA][CITY];
        self.weatherType.text = currentCityInfo[RETDATA][TODAY][TYPE];
        self.temperature.text = currentCityInfo[RETDATA][TODAY][CURTEMP];
        self.windDirection.text = currentCityInfo[RETDATA][TODAY][FENGXIANG];
        self.windSpeed.text = currentCityInfo[RETDATA][TODAY][FENGLI];
        
        [_sevenDaysData removeAllObjects];
        [self.sevenDaysData addObjectsFromArray:currentCityInfo[RETDATA][HISTORY]];
        [self.sevenDaysData addObject:currentCityInfo[RETDATA][TODAY]];
        [self.sevenDaysData addObjectsFromArray:currentCityInfo[RETDATA][FORECAST]];
        
        [_sevenDaysData removeObjectsInRange:NSMakeRange(0, 5)];

        self.backgroundView.image = [UIImage imageNamed:_backgroundImages[self.weatherType.text]];
        [self.navigationController.navigationBar setBackgroundImage:_backgroundView.image forBarMetrics:UIBarMetricsCompactPrompt];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [self.tableView reloadData];
    });
}

//将json数据转换成dictionary对象
- (NSMutableDictionary *)transformToDic:(NSString *)jsonString {
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}

@end

