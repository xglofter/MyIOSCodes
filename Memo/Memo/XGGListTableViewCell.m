//
//  XGGListTableViewCell.m
//  Memo
//
//  Created by Richard on 16/7/16.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "XGGListTableViewCell.h"

#import <Masonry.h>

@implementation XGGListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_titleLabel];
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_dateLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(_dateLabel.mas_left).offset(-20);
            make.bottom.equalTo(self);
        }];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self).offset(-20);
//            make.left.equalTo
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    NSLog(@"setSelected");
}

@end
