//
//  SKFollowListTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKFollowListTableViewCell.h"

@implementation SKFollowListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.checkButton];
    }
    return self;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(10), ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40))];
        _avatarImageView.image = COMMON_AVATAR_PLACEHOLDER_IMAGE;
        _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(20);
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"用户昵称";
        _usernameLabel.textColor = COMMON_TEXT_COLOR;
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [_usernameLabel sizeToFit];
        _usernameLabel.centerY = ROUND_WIDTH_FLOAT(30);
        _usernameLabel.left = ROUND_WIDTH_FLOAT(65);
    }
    return _usernameLabel;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton new];
        [_checkButton setBackgroundImage:[UIImage imageNamed:@"btn_choicepage_confirm_blank"] forState:UIControlStateNormal];
        _checkButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(16), ROUND_WIDTH_FLOAT(16));
        _checkButton.centerY = ROUND_WIDTH_FLOAT(30);
        _checkButton.right = SCREEN_WIDTH -ROUND_WIDTH_FLOAT(15);
    }
    return _checkButton;
}

- (void)setIsCheck:(BOOL)isCheck {
    [_checkButton setBackgroundImage:isCheck?[UIImage imageNamed:@"btn_choicepage_confirm"]:[UIImage imageNamed:@"btn_choicepage_confirm_blank"] forState:UIControlStateNormal];
}


@end
