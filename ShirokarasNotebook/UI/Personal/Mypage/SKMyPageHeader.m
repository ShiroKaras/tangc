//
//  SKMyPageHeader.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKMyPageHeader.h"

@implementation SKMyPageHeader

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backImageView];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.usernameLabel];
        [self addSubview:self.userInfoLabel];
    }
    return self;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-ROUND_WIDTH_FLOAT(22))];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.backgroundColor = COMMON_TEXT_COLOR;
    }
    return _backImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(33);
        _avatarImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(66), ROUND_WIDTH_FLOAT(66));
        _avatarImageView.centerX = self.width/2;
        _avatarImageView.top = ROUND_WIDTH_FLOAT(38);
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"卓大王";
        _usernameLabel.textColor = [UIColor whiteColor];
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
        [_usernameLabel sizeToFit];
        _usernameLabel.centerX = _avatarImageView.centerX;
        _usernameLabel.top = _avatarImageView.bottom+10;
    }
    return _usernameLabel;
}

- (UILabel *)userInfoLabel {
    if (!_userInfoLabel) {
        _userInfoLabel = [UILabel new];
        _userInfoLabel.text = @"关注9999  粉丝9999";
        _userInfoLabel.textColor = [UIColor colorWithHex:0xF0F4F8];
        _userInfoLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [_userInfoLabel sizeToFit];
        _userInfoLabel.centerX = _avatarImageView.centerX;
        _userInfoLabel.top = _usernameLabel.bottom +6;
    }
    return _userInfoLabel;
}

@end
