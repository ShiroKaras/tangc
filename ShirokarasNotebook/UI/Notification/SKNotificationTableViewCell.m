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
@property (nonatomic, strong) UIView *underLine;
@end

@implementation SKNotificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.underLine];
        
        [self layoutIfNeeded];
        self.cellHeight = self.underLine.bottom;
    }
    return self;
}

- (UIImageView *)avatarImageView {
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
        _usernameLabel.text = @"---";
        _usernameLabel.textColor = COMMON_TEXT_COLOR;
        _usernameLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right+10;
        _usernameLabel.centerY = _avatarImageView.centerY;
    }
    return _usernameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.text = @"2017/11/11";
        _dateLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _dateLabel.font = PINGFANG_FONT_OF_SIZE(9);
        [_dateLabel sizeToFit];
        _dateLabel.right = SCREEN_WIDTH-ROUND_WIDTH_FLOAT(15);
        _dateLabel.centerY = _avatarImageView.centerY;
    }
    return _dateLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.text = @"--------------------";
        _contentLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
        _contentLabel.font = PINGFANG_FONT_OF_SIZE(10);
        _contentLabel.numberOfLines = 0;
        _contentLabel.size = CGSizeMake(ROUND_WIDTH_FLOAT(250), ROUND_WIDTH_FLOAT(30));
        _contentLabel.top = _usernameLabel.bottom +10;
        _contentLabel.left = _usernameLabel.left;
    }
    return _contentLabel;
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] initWithFrame:CGRectMake(_usernameLabel.left, _contentLabel.bottom+ROUND_WIDTH_FLOAT(15), SCREEN_WIDTH-_usernameLabel.left-ROUND_WIDTH_FLOAT(15), 0.5)];
        _underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
    }
    return _underLine;
}

- (void)setNotificationItem:(SKNotification *)notificationItem {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:notificationItem.avatar] placeholderImage:COMMON_AVATAR_PLACEHOLDER_IMAGE];
    _usernameLabel.text = [notificationItem.comuser_nickname isEqualToString:@""]?@"系统通知":notificationItem.comuser_nickname;
    [_usernameLabel sizeToFit];
    _contentLabel.text = notificationItem.content;
    CGSize labelSize = [notificationItem.content boundingRectWithSize:CGSizeMake(ROUND_WIDTH_FLOAT(250), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(10)} context:nil].size;
    _contentLabel.size = labelSize;
    _dateLabel.text = notificationItem.publish_time;
    [_dateLabel sizeToFit];
    
    _underLine.top = _contentLabel.bottom+ROUND_WIDTH_FLOAT(15);
    self.cellHeight = self.underLine.bottom;
}

@end
