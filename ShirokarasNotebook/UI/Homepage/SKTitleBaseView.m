//
//  SKTitleBaseView.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/14.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTitleBaseView.h"

@interface SKTitleBaseView ()

@end

@implementation SKTitleBaseView

- (instancetype)initWithFrame:(CGRect)frame withTopic:(SKTopic*)topic
{
    self = [super initWithFrame:frame];
    if (self) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor blackColor];
        _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(15);
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.top = ROUND_WIDTH_FLOAT(15);
        _avatarImageView.left = ROUND_WIDTH_FLOAT(15);
        _avatarImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(30), ROUND_WIDTH_FLOAT(30));
        [self addSubview:_avatarImageView];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"卓大王";
        _usernameLabel.textColor = COMMON_TEXT_COLOR;
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(13);
        _usernameLabel.textColor = COMMON_TEXT_COLOR;
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right +ROUND_WIDTH_FLOAT(10);
        _usernameLabel.top = _avatarImageView.top;
        [self addSubview:_usernameLabel];
        
        _dateLabel = [UILabel new];
        _dateLabel.text = @"2017/11/11";
        _dateLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _dateLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
        [_dateLabel sizeToFit];
        _dateLabel.top = _usernameLabel.bottom-2;
        _dateLabel.left = _usernameLabel.left;
        [self addSubview:_dateLabel];
        
        //关注按钮
        _followButton = [UIButton new];
        [_followButton setBackgroundImage:topic.is_follow?[UIImage imageNamed:@"btn_homepage_follow_highlight"]:[UIImage imageNamed:@"btn_homepage_follow"] forState:UIControlStateNormal];
        _followButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _followButton.layer.cornerRadius = ROUND_WIDTH_FLOAT(10);
        _followButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(45), ROUND_WIDTH_FLOAT(20));
        _followButton.right = self.width-ROUND_WIDTH_FLOAT(20);
        _followButton.centerY = _avatarImageView.centerY;
        [self addSubview:_followButton];
    }
    return self;
}

- (void)setUserInfo:(SKUserInfo *)userInfo {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
    self.usernameLabel.text = userInfo.nickname;
    [self.usernameLabel sizeToFit];
    _followButton.hidden = [[SKStorageManager sharedInstance].loginUser.nickname isEqualToString:userInfo.nickname];
    
//    [_followButton setBackgroundImage:userInfo.is_follow?[UIImage imageNamed:@"btn_homepage_follow_highlight"]:[UIImage imageNamed:@"btn_homepage_follow"] forState:UIControlStateNormal];
}

@end
