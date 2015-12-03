//
//  DetailViewController.m
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNDetailViewController.h"
#import "SNItem.h"
#import "SNItemService.h"
#import "FMDB.h"
#import "SNDBService.h"
@interface SNDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (weak, nonatomic) IBOutlet UITextView *contentField;
@property (weak, nonatomic) UITextView *contentField;
@property (nonatomic) BOOL isNew;
@property (nonatomic) NSString *isFavor;
@end

@implementation SNDetailViewController

- (instancetype)init {
    self = [super init];
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, 355, 440)];
    textview.backgroundColor=[UIColor groupTableViewBackgroundColor]; //背景色
    self.contentField = textview;
    [self.view addSubview:textview];
    return self;
}

- (instancetype)initDetailItem:(BOOL)isNew {
    self = [self init];
    self.isNew = isNew;
    //如果是新建的情况
    if (isNew) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"新建";
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
        
        navItem.rightBarButtonItem = barButtonItem;
    }
    
    //如果是编辑的情况
    else {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"详细内容";
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modify)];
        navItem.rightBarButtonItem = barButtonItem;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.isFavor = _item.isFavor;
    [self showCurrentItem];
    [self createToolbarItems];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark 增加和修改操作

- (void)save {
    if ([_titleField.text isEqualToString:@""] && [_contentField.text  isEqualToString:@""]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    //插入数据库
    [SNDBService addTitle:_titleField.text content:_contentField.text date:_dateLabel.text isFavor:_isFavor];
    SNItem *newItem = [SNItemService createItem];
    self.item = newItem;
    self.item.isFavor = _isFavor;
    self.item.title = _titleField.text;
    self.item.detailText = _contentField.text ;
    self.item.dateCreated = _dateLabel.text;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)modify {
    //修改数据库
    [SNDBService updateTitle:_titleField.text content:_contentField.text  isFavor:_isFavor byOldTitle:_item.title oldContent:_item.detailText];
    //修改Item数组
    self.item.title = _titleField.text;
    self.item.detailText = _contentField.text ;
    self.item.isFavor = _isFavor;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleFavor {
    if (!_isFavor) {
        self.toolbarItems[1].image = [UIImage imageNamed:@"star.png"];
        self.isFavor = @"YES";
    }
    
    else {
        self.toolbarItems[1].image = [UIImage imageNamed:@"emptyStar.png"];
        self.isFavor = nil;
    }
}

#pragma mark 在视图上显示内容

- (void)createToolbarItems {
    self.navigationController.toolbarHidden = NO;

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *favorite = nil;
    if (_isFavor) {
        favorite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavor)];
    }
    
    else {
        favorite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"emptyStar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavor)];
    }
    
    favorite.image = [favorite.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSArray *ary = @[space, favorite, space];
    
    self.toolbarItems = ary;
}

-(void)showCurrentItem {
    static  NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });

    dispatch_queue_t queue =  dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if (_isNew) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            
            self.dateLabel.text = strDate;
            self.titleField.text = @"";
            self.isFavor = nil;
            self.item = nil;
        }
        
        else {
            self.titleField.text = _item.title;
            self.contentField.text =  _item.detailText;
            self.dateLabel.text = _item.dateCreated;
        }
    });
}

@end
