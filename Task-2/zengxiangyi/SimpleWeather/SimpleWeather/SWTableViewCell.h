//
//  SWTableViewCell.h
//  SimpleWeather
//
//  Created by zxy on 15/12/11.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;

- (void)configFortTable:(NSMutableDictionary *)data;
@end
