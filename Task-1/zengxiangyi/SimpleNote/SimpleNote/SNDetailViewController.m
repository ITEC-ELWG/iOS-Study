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

@end

@implementation SNDetailViewController

- (instancetype)init
{
    self = [super init];
    return self;
}

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
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        self.contentField.text = _item.detailText;
        self.dateLabel.text = _item.dateCreated;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark 增加和修改数据库内容

- (void)save
{
    if ([_titleField.text isEqualToString:@""] && [_contentField.text isEqualToString:@""])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    //插入数据库
    [[SNDBHelper sharedDataBase] addTitle:_titleField.text content:_contentField.text date:_dateLabel.text];
    
    SNItem *newItem = [[SNItem sharedStore] createItem];
    self.item = newItem;
    
    self.item.title = _titleField.text;
    self.item.detailText = _contentField.text;
    self.item.dateCreated = _dateLabel.text;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)modify
{
    //修改数据库
    [[SNDBHelper sharedDataBase] updateTitle:_titleField.text content:_contentField.text by:self.item.idNum];
    
    self.item.title = _titleField.text;
    self.item.detailText = _contentField.text;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
