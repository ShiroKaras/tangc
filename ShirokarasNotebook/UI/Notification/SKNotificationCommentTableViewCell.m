//
//  SKNotificationCommentTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKNotificationCommentTableViewCell.h"

@interface SKNotificationCommentTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *usernameAppendLabel;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *underLine;
@end

@implementation SKNotificationCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.usernameAppendLabel];
        [self.contentView addSubview:self.thumbImageView];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.underLine];
        
        [self layoutIfNeeded];
        self.cellHeight = _underLine.bottom;
    }
    return self;
}

- (UIImageView*)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = COMMON_SEPARATOR_COLOR;
        _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(15);
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(30), ROUND_WIDTH_FLOAT(30));
        _avatarImageView.left = ROUND_WIDTH_FLOAT(15);
        _avatarImageView.top = ROUND_WIDTH_FLOAT(17.5);
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"卓大王";
        _usernameLabel.textColor = COMMON_TEXT_COLOR;
        _usernameLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right+10;
        _usernameLabel.centerY = _avatarImageView.centerY;
    }
    return _usernameLabel;
}

- (UILabel *)usernameAppendLabel {
    if (!_usernameAppendLabel) {
        _usernameAppendLabel = [UILabel new];
        _usernameAppendLabel.text = @"评论了你的发布";
        _usernameAppendLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _usernameAppendLabel.font = _usernameLabel.font;
        [_usernameAppendLabel sizeToFit];
        _usernameAppendLabel.left = _usernameLabel.right+6;
        _usernameAppendLabel.centerY = _usernameLabel.centerY;
    }
    return _usernameAppendLabel;
}

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [UIImageView new];
        _thumbImageView.image = [UIImage imageNamed:@"MaskCopy"];
        _thumbImageView.layer.cornerRadius = 3;
        _thumbImageView.layer.masksToBounds = YES;
        _thumbImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(43), ROUND_WIDTH_FLOAT(43));
        _thumbImageView.top = ROUND_WIDTH_FLOAT(15);
        _thumbImageView.right = SCREEN_WIDTH -ROUND_WIDTH_FLOAT(15);
    }
    return _thumbImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.text = @"效率文具控的安利《这可能是最全的抵达清单可能是最全的抵达清单（TickTick）使用指南了》";
        _contentLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
        _contentLabel.font = PINGFANG_FONT_OF_SIZE(10);
        _contentLabel.numberOfLines = 3;
        _contentLabel.size = CGSizeMake(ROUND_WIDTH_FLOAT(197), ROUND_WIDTH_FLOAT(50));
        [_contentLabel sizeToFit];
        _contentLabel.left = _usernameLabel.left;
        _contentLabel.top = _usernameLabel.bottom +10;
    }
    return _contentLabel;
}


- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.text = @"2017/11/11";
        _dateLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _dateLabel.font = PINGFANG_FONT_OF_SIZE(9);
        [_dateLabel sizeToFit];
        _dateLabel.left = _usernameLabel.left;
        _dateLabel.top = _contentLabel.bottom+10;
    }
    return _dateLabel;
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] initWithFrame:CGRectMake(_usernameLabel.left, _dateLabel.bottom+15, SCREEN_WIDTH-_usernameLabel.left-ROUND_WIDTH_FLOAT(15), 0.5)];
        _underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
    }
    return _underLine;
}

- (void)setUserName:(NSString *)userName {
    self.usernameLabel.text = userName;
    [self.usernameLabel sizeToFit];
    _usernameAppendLabel.left = _usernameLabel.right+6;
}

@end
