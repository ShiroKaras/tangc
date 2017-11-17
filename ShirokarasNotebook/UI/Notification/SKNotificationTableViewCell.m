//
//  SKNotificationTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKNotificationTableViewCell.h"

@interface SKNotificationTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation SKNotificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = COMMON_SEPARATOR_COLOR;
        _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(15);
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(30), ROUND_WIDTH_FLOAT(30));
        _avatarImageView.left = ROUND_WIDTH_FLOAT(15);
        _avatarImageView.top = ROUND_WIDTH_FLOAT(17.5);
        [self.contentView addSubview:_avatarImageView];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"卓大王";
        _usernameLabel.textColor = COMMON_TEXT_COLOR;
        _usernameLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right+10;
        _usernameLabel.centerY = _avatarImageView.centerY;
        [self.contentView addSubview:_usernameLabel];
        
        _dateLabel = [UILabel new];
        _dateLabel.text = @"2017/11/11";
        _dateLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _dateLabel.font = PINGFANG_FONT_OF_SIZE(9);
        [_dateLabel sizeToFit];
        _dateLabel.right = SCREEN_WIDTH-ROUND_WIDTH_FLOAT(15);
        _dateLabel.centerY = _avatarImageView.centerY;
        [self.contentView addSubview:_dateLabel];
        
        _contentLabel = [UILabel new];
        _contentLabel.text = @"效率文具控的安利《这可能是最全的抵达清单可能是最全的抵达清单（TickTick）使用指南了》";
        _contentLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
        _contentLabel.font = PINGFANG_FONT_OF_SIZE(10);
        _contentLabel.numberOfLines = 2;
        _contentLabel.size = CGSizeMake(ROUND_WIDTH_FLOAT(250), ROUND_WIDTH_FLOAT(30));
        _contentLabel.top = _usernameLabel.bottom +10;
        _contentLabel.left = _usernameLabel.left;
        [self.contentView addSubview:_contentLabel];
        
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(_usernameLabel.left, _contentLabel.bottom+15, SCREEN_WIDTH-_usernameLabel.left-ROUND_WIDTH_FLOAT(15), 0.5)];
        underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
        [self.contentView addSubview:underLine];
        
        [self layoutIfNeeded];
        self.cellHeight = underLine.bottom;        
    }
    return self;
}

@end
