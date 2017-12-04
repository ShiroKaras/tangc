//
//  SKTopicCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/16.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTopicCell.h"

#define SPACE 15
#define CELL_WIDTH ((SCREEN_WIDTH-SPACE*3)/2)

@implementation SKTopicCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        [self.contentView addSubview:self.mCoverImageView];
        [self.contentView addSubview:self.mTitleLabel];
        [self.contentView addSubview:self.mAvatarImageView];
        [self.contentView addSubview:self.mUsernameLabel];
    }
    return self;
}

- (UIImageView *)mCoverImageView {
    if (!_mCoverImageView) {
        _mCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_WIDTH)];
        _mCoverImageView.backgroundColor = [UIColor colorWithHex:0xD8DDF9];
    }
    return _mCoverImageView;
}

- (UILabel *)mTitleLabel {
    if (!_mTitleLabel) {
        _mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CELL_WIDTH+10, self.width-20, 40)];
        _mTitleLabel.textColor = [UIColor colorWithHex:0x434343];
        _mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        _mTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _mTitleLabel.numberOfLines = 2;
//        CGSize maximumLabelSize = CGSizeMake(self.width-20, 30);//labelsize的最大值
//        CGSize expectSize = [_mTitleLabel sizeThatFits:maximumLabelSize];
//        _mTitleLabel.frame = CGRectMake(10, CELL_WIDTH+10, expectSize.width, expectSize.height);
    }
    return _mTitleLabel;
}

- (UIImageView *)mAvatarImageView {
    if (!_mAvatarImageView) {
        _mAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, _mTitleLabel.bottom+30, 25, 25)];
        _mAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mAvatarImageView.layer.masksToBounds = YES;
        _mAvatarImageView.layer.cornerRadius = 12.5;
        _mAvatarImageView.backgroundColor = [UIColor blackColor];
    }
    return _mAvatarImageView;
}

- (UILabel *)mUsernameLabel {
    if (!_mUsernameLabel) {
        _mUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mAvatarImageView.right+6, _mTitleLabel.bottom+6, 50, 11)];
        _mUsernameLabel.textColor = COMMON_TEXT_COLOR;
        _mUsernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        _mUsernameLabel.centerY = _mAvatarImageView.centerY;
    }
    return _mUsernameLabel;
}

- (void)setTopic:(NSString *)topic {
    //TODO
}

@end
