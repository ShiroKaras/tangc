//
//  SKThumbTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/19.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKThumbTableViewCell.h"

@interface SKThumbTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@end

@implementation SKThumbTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        
    }
    return self;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor greenColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.top = 10;
        _avatarImageView.left = 10;
        _avatarImageView.size = CGSizeMake(40, 40);
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"username";
        _usernameLabel.textColor = COMMON_TEXT_COLOR;
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right +20;
        _usernameLabel.centerY = _avatarImageView.centerY;
    }
    return _usernameLabel;
}

- (void)setUserInfo:(SKUserInfo *)userInfo {
    self.usernameLabel.text = userInfo.nickname;
    [self.usernameLabel sizeToFit];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
}
@end
