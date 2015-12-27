//
//  SNTableViewCell.m
//  SimpleNote
//
//  Created by zxy on 15/12/25.
//  Copyright © 2015年 zxy. All rights reserved.
//

#import "SNTableViewCell.h"
#import "SNItem.h"

@interface SNTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@end

@implementation SNTableViewCell

#pragma mark - public methods

- (void)configTableCell:(SNItem *)data {
    self.titleLabel.text = data.title;
    self.detailTextField.text = data.detailText;
    self.dateLabel.text = [_dateFormatter stringFromDate:data.dateCreated];
}

@end
