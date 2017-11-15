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
@end

@implementation SKHomepageDetaillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor greenColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.top = 10;
        _avatarImageView.left = 10;
        _avatarImageView.size = CGSizeMake(40, 40);
        [self.contentView addSubview:_avatarImageView];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"username";
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(16);
        _usernameLabel.textColor = [UIColor greenColor];
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right +20;
        _usernameLabel.centerY = _avatarImageView.centerY;
        [self.contentView addSubview:_usernameLabel];
        
        _dateLabel = [UILabel new];
        _dateLabel.text = @"2017/11/11";
        _dateLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(13);
        [_dateLabel sizeToFit];
        _dateLabel.right = SCREEN_WIDTH-30;
        _dateLabel.centerY = _usernameLabel.centerY;
        [self.contentView addSubview:_dateLabel];
        
        _contentLabel = [UILabel new];
        _contentLabel.text = @"text\ntext";
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
        _contentLabel.top = _avatarImageView.bottom+3;
        _contentLabel.left = _usernameLabel.left;
        [self.contentView addSubview:_contentLabel];
        
        UIView *underLine = [UIView new];
        underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
        underLine.size = CGSizeMake(SCREEN_WIDTH-_usernameLabel.left-10, 0.5);
        underLine.left = _contentLabel.left;
        underLine.top = _contentLabel.bottom+5;
        [self.contentView addSubview:underLine];
        
        self.cellHeight = underLine.bottom;
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x +=5;
    frame.size.width-=10;
    [super setFrame:frame];
}

@end
