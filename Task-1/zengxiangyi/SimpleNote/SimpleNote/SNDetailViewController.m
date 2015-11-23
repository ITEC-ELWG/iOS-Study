//
//  DetailViewController.m
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNDetailViewController.h"
#import "SNItem.h"
#import "FMDB.h"
#import "SNDBHelper.h"
@interface SNDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentField;
@property (nonatomic) NSString *isFavor;
@end

@implementation SNDetailViewController

- (instancetype)init
{
    self = [super init];
    return self;
}

//显示导航栏信息
- (instancetype)setViewController
{
    //如果是新建的情况
    if (!self.item)
    {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"新建";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
        
        navItem.rightBarButtonItem = bbi;
    }
    
    //如果是编辑的情况
    else
    {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"详细内容";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modify)];
        navItem.rightBarButtonItem = bbi;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFavor = _item.isFavor;
    [self createToolbarItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showCurrentItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark 增加和修改操作

- (void)save
{
    if ([_titleField.text isEqualToString:@""] && [_contentField.text isEqualToString:@""])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    //插入数据库
    [[SNDBHelper sharedDataBase] addTitle:_titleField.text content:_contentField.text date:_dateLabel.text isFavor:_isFavor];
    SNItem *newItem = [[SNItem sharedStore] createItem];
    self.item = newItem;
    self.item.isFavor = _isFavor;
    self.item.title = _titleField.text;
    self.item.detailText = _contentField.text;
    self.item.dateCreated = _dateLabel.text;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)modify
{
    //修改数据库
    [[SNDBHelper sharedDataBase] updateTitle:_titleField.text content:_contentField.text isFavor:self.item.isFavor byOldTitle:_item.title oldContent:_item.detailText];
    //修改Item数组
    self.item.title = _titleField.text;
    self.item.detailText = _contentField.text;
    self.item.isFavor = _isFavor;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)toggleFavor
{
    if (!_isFavor)
    {
        self.toolbarItems[1].image = [UIImage imageNamed:@"star.png"];
        self.isFavor = @"YES";
    }
    
    else
    {
        self.toolbarItems[1].image = [UIImage imageNamed:@"emptyStar.png"];
        self.isFavor = nil;
    }
}

#pragma mark 在视图上显示内容

- (void)createToolbarItems
{
    self.navigationController.toolbarHidden = NO;

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *favorite = nil;
    if (_isFavor)
    {
        favorite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavor)];
    }
    
    else
    {
        favorite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"emptyStar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavor)];
    }
    
    favorite.image = [favorite.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSArray *ary = [[NSArray alloc] initWithObjects: space, favorite, space, nil];
    
    self.toolbarItems = ary;
}

-(void)showCurrentItem
{
    dispatch_queue_t queue =  dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if (!_item)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            
            self.item.dateCreated = strDate;
            self.dateLabel.text = strDate;
        }
        
        else
        {
            self.titleField.text = _item.title;
            self.contentField.text =  _item.detailText;
            self.dateLabel.text = _item.dateCreated;
        }
    });
}
@end
