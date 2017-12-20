//
//  SKHomepageDetaillTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/14.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKHomepageDetaillTableViewCell.h"

@interface SKHomepageDetaillTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *underLine;
@end

@implementation SKHomepageDetaillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.underLine];
        self.cellHeight = self.underLine.bottom;
    }
    return self;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor greenColor];
        _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(12.5);
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.top = 15;
        _avatarImageView.left = 15;
        _avatarImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(25), ROUND_WIDTH_FLOAT(25));
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

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.text = @"2017/11/11";
        _dateLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _dateLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
        [_dateLabel sizeToFit];
        _dateLabel.right = SCREEN_WIDTH-30;
        _dateLabel.centerY = _usernameLabel.centerY;
    }
    return _dateLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.text = @"text\ntext";
        _contentLabel.textColor = [UIColor colorWithHex:0x6A7781];
        _contentLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(11);
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
        _contentLabel.top = _usernameLabel.bottom+ROUND_WIDTH_FLOAT(10);
        _contentLabel.left = _usernameLabel.left;
    }
    return _contentLabel;
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [UIView new];
        _underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
        _underLine.size = CGSizeMake(SCREEN_WIDTH-_usernameLabel.left-10, 0.5);
        _underLine.left = _contentLabel.left;
        _underLine.top = _contentLabel.bottom+5;
        _underLine.bottom = ROUND_WIDTH_FLOAT(37)-0.5;
        [self.contentView addSubview:_underLine];
    }
    return _underLine;
}

- (void)setComment:(SKComment *)comment {
    self.usernameLabel.text = comment.user.nickname;
    [self.usernameLabel sizeToFit];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
    
    self.dateLabel.text = comment.updated_at;
    [self.dateLabel sizeToFit];
    self.dateLabel.right = SCREEN_WIDTH-30;
    
    self.contentLabel.text = comment.content;
    CGSize maxSize = CGSizeMake(ROUND_WIDTH_FLOAT(255), ROUND_WIDTH_FLOAT(33));
    CGSize labelSize = [comment.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(11)} context:nil].size;
    self.contentLabel.size = labelSize;
    self.underLine.top = self.contentLabel.bottom+ROUND_WIDTH_FLOAT(10);
    self.cellHeight = self.underLine.bottom;
}

@end
