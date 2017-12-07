//
//  SKUserListTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKUserListTableViewCell.h"
@interface SKUserListTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIView *underLine;
@end

@implementation SKUserListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.followButton];
        [self.contentView addSubview:self.underLine];
        self.cellHeight = ROUND_WIDTH_FLOAT(60);
    }
    return self;
}

- (void)setUserInfo:(SKUserInfo *)userInfo wityType:(SKUserListType)type {
    self.type = type;
    if (type==SKUserListTypeFollow) {
        [self.followButton setBackgroundImage:userInfo.is_concerned?[UIImage imageNamed:@"btn_followpage_followeeachother"]:[UIImage imageNamed:@"btn_followpage_followed"] forState:UIControlStateNormal];
    } else if (type == SKUserListTypeFans) {
        [self.followButton setBackgroundImage:userInfo.is_concerned?[UIImage imageNamed:@"btn_followpage_followeeachother"]:[UIImage imageNamed:@"btn_followpage_followe"] forState:UIControlStateNormal];
    }
    self.userInfo = userInfo;
}

- (void)setUserInfo:(SKUserInfo *)userInfo {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
    self.usernameLabel.text = userInfo.nickname;
    [self.usernameLabel sizeToFit];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(10), ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40))];
        _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(20);
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.backgroundColor = COMMON_BG_COLOR;
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"卓大王";
        _usernameLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right+ROUND_WIDTH_FLOAT(10);
        _usernameLabel.centerY = ROUND_WIDTH_FLOAT(30);
    }
    return _usernameLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton new];
        [_followButton setBackgroundImage:[UIImage imageNamed:@"btn_followpage_followe"] forState:UIControlStateNormal];
        _followButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(60), ROUND_WIDTH_FLOAT(30));
        _followButton.right = SCREEN_WIDTH-ROUND_WIDTH_FLOAT(15);
        _followButton.centerY = ROUND_WIDTH_FLOAT(30);
    }
    return _followButton;
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(59.5), SCREEN_WIDTH-ROUND_WIDTH_FLOAT(30), 0.5)];
        _underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
    }
    return _underLine;
}

@end
