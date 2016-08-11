//
//  ZHDNewsCell.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/11.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDNewsCell.h"

@implementation ZHDNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];

        _pictureImageView = [[UIImageView alloc] init];
        [self addSubview:_pictureImageView];

        [self layoutViews];
    }
    return self;
}

- (void)layoutViews {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 100));
    }];

    [_pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
    }];
}

@end
