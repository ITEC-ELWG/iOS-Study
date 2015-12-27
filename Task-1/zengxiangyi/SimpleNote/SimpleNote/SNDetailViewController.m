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
#import "SNDBService.h"

@interface SNDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UITextView *textView;
@property (nonatomic) BOOL isNew;
@end

@implementation SNDetailViewController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textView = [[UITextView alloc] init];
    }
    
    return self;
}

- (instancetype)initDetailItem:(BOOL)isNew {
    self.isNew = isNew;
    //如果是新建的情况
    if (isNew) {
        self.item = [[SNItem alloc] init];

        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"新建";
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                       target:self
                                                                                       action:@selector(save)];
        
        navItem.rightBarButtonItem = barButtonItem;
    } else {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"详细内容";
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                       target:self
                                                                                       action:@selector(modify)];
        navItem.rightBarButtonItem = barButtonItem;
    }
    
    return self;
}

- (NSArray *)configToolbarItems {
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *favorite = nil;
    
    if (_item.isFavor) {
        favorite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star.png"]
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(toggleFavor)];
    } else {
        favorite = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"emptyStar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavor)];
    }
    
    favorite.image = [favorite.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSArray *ary = @[space, favorite, space];
    
    return ary;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_textView];

    //添加约束
    self.textView.contentMode = UIViewContentModeScaleAspectFit;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *nameMap = @{@"textView":_textView, @"dateLabel": _dateLabel };
    
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[textView]-10-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-10-[textView]-60-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self showCurrentItem];
    self.toolbarItems = [self configToolbarItems];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.titleField.text = @"";
    self.textView.text = @"";
    self.dateLabel.text = @"";
}

#pragma mark - Private methods

- (void)save {
    if ([_titleField.text isEqualToString:@""] && [_textView.text isEqualToString:@""]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    //插入数据库
    [SNDBService addTitle:_titleField.text
                  content:_textView.text
                     date:_item.dateCreated
                  isFavor:_item.isFavor
                 complete:^{
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         [self.navigationController popViewControllerAnimated:YES];
                     });
                 }];
}

- (void)modify {
    //修改数据库
    [SNDBService updateTitle:_titleField.text
                     content:_textView.text
                     isFavor:_item.isFavor
                  byOldTitle:_item.title
                  oldContent:_item.detailText
                    complete:^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }];
}

- (void)toggleFavor {
    if (!_item.isFavor) {
        self.toolbarItems[1].image = [UIImage imageNamed:@"star.png"];
        self.item.isFavor = YES;
    } else {
        self.toolbarItems[1].image = [UIImage imageNamed:@"emptyStar.png"];
        self.item.isFavor = NO;
    }
}

-(void)showCurrentItem {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isNew) {
            NSDate *date = [NSDate date];
            NSString *strDate = [_dateFormatter stringFromDate:date];
            
            self.dateLabel.text = strDate;
            self.titleField.text = @"";
            self.textView.text = @"";
            
            self.item.isFavor = NO;
            self.item.dateCreated = date;
        } else {
            self.titleField.text = _item.title;
            self.textView.text =  _item.detailText;
            
            NSString *strDate = [_dateFormatter stringFromDate:_item.dateCreated];
            self.dateLabel.text = strDate;
        }
    });
}
@end
