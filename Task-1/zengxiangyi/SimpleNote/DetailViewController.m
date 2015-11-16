//
//  DetailViewController.m
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "ItemStore.h"
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentField;

@end

@implementation DetailViewController
@synthesize dataBase;
@synthesize databasePath;

- (instancetype)init
{
    self = [super init];
    if (self) {
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
    
    if (!self.item) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"新建";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    
        navItem.rightBarButtonItem = bbi;
    }
    
    else{
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"详细内容";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modify)];
        
        navItem.rightBarButtonItem = bbi;
    }
    
    Item *item = self.item;
    self.titleField.text = item.title;
    self.contentField.text = item.detailText;
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contents
    if (!item.dateCreated) {
        NSDate *currentDate = [[NSDate alloc] init];
        //NSLog(@"ws  %@",item.dateCreated);
        self.dateLabel.text = [dateFormatter stringFromDate:currentDate];

    }
    else {
        self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    }
    if (self.contentField.text.length == 0) {
        //self.contentField.text = @"新建笔记内容";
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    
}

- (void)save
{
    
    //如果新建标题和内容均为空，则不插入
    if ([self.titleField.text isEqualToString:@""] && [self.contentField.text isEqualToString:@""]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    Item *addItem = [[ItemStore sharedStore] createItem];
    self.item = addItem;
    Item *item = self.item;
    item.title = self.titleField.text;
    item.detailText = self.contentField.text;
    

    
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        
 
            
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO INFO (title, content, date, idnum) VALUES(\"%@\",\"%@\",\"%@\", \"%d\")", self.titleField.text, self.contentField.text, self.dateLabel.text, self.item.idNum];
            const char *insertstaement = [insertSql UTF8String];
            sqlite3_prepare_v2(dataBase, insertstaement, -1, &statement, NULL);
            if (sqlite3_step(statement)==SQLITE_DONE) {
                //NSLog(@"%d", self.item.idNum);
            }
            else {
                NSLog(@"save failed!");
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
   
    }

    
    [self.navigationController popToRootViewControllerAnimated:YES];
    

}

- (void)modify
{
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        
        
        
        NSString *insertSql = [NSString stringWithFormat:@"UPDATE INFO SET title = \"%@\", content = \"%@\" where idnum = \"%d\"", self.titleField.text, self.contentField.text, self.item.idNum];
        const char *insertstaement = [insertSql UTF8String];
        sqlite3_prepare_v2(dataBase, insertstaement, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE) {
            NSLog(@"modify!");
        }
        else {
            NSLog(@"modify failed!");
            NSLog(@"%@", insertSql);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        
    }
    
    self.item.title = self.titleField.text;
    self.item.detailText = self.contentField.text;
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}


@end
