//
//  SKTitleBaseView.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/14.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTitleBaseView.h"

@implementation SKTitleBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor greenColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.top = 10;
        _avatarImageView.left = 10;
        _avatarImageView.size = CGSizeMake(40, 40);
        [self addSubview:_avatarImageView];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"username";
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(16);
        _usernameLabel.textColor = [UIColor greenColor];
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right +20;
        _usernameLabel.top = _avatarImageView.top;
        [self addSubview:_usernameLabel];
        
        _dateLabel = [UILabel new];
        _dateLabel.text = @"2017/11/11";
        _dateLabel.textColor = [UIColor lightGrayColor];
        _dateLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        [_dateLabel sizeToFit];
        _dateLabel.top = _usernameLabel.bottom;
        _dateLabel.left = _usernameLabel.left;
        [self addSubview:_dateLabel];
        
        //关注按钮
        _followButton = [UIButton new];
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followButton.backgroundColor = [UIColor lightGrayColor];
        _followButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _followButton.layer.cornerRadius = 12;
        _followButton.size = CGSizeMake(40, 24);
        _followButton.left = self.width-20-_followButton.width -20;
        _followButton.centerY = _avatarImageView.centerY;
        [self addSubview:_followButton];
    }
    return self;
}

@end
