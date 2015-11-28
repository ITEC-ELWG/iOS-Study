//
//  DetailViewController.h
//  SimpleNote
//
//  Created by zxy on 15/11/12.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNItem;

@interface SNDetailViewController : UIViewController
@property (nonatomic, strong) SNItem *item;
- (instancetype)setViewController;

@end
