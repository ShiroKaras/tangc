//
//  SKMypageArticleTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKMypageArticleTableViewCell.h"

@interface SKMypageArticleTableViewCell ()
@property (nonatomic, strong) UIImageView *mTitleImageView;
@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) UILabel *mDateLabel;
@property (nonatomic, strong) UILabel *mCommentCountLabel;
@property (nonatomic, strong) UILabel *mLikeLabel;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *heartImageView;
@end

@implementation SKMypageArticleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mTitleImageView];
        [self.contentView addSubview:self.mTitleLabel];
        [self.contentView addSubview:self.commentImageView];
        [self.contentView addSubview:self.mCommentCountLabel];
        [self.contentView addSubview:self.heartImageView];
        [self.contentView addSubview:self.mLikeLabel];
        [self layoutSubviews];
        self.cellHeight = ROUND_WIDTH_FLOAT(134);
    }
    return self;
}

- (void)setArtilce:(SKArticle *)artilce {
    [_mTitleImageView sd_setImageWithURL:[NSURL URLWithString:artilce.cover] placeholderImage:COMMON_PLACEHOLDER_IMAGE];
    _mTitleLabel.text = artilce.title;
    _mLikeLabel.text = artilce.thumb_num;
    [self layoutSubviews];
}

- (UIImageView *)mTitleImageView {
    if (!_mTitleImageView) {
        _mTitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(75))];
        _mTitleImageView.image = COMMON_PLACEHOLDER_IMAGE;
        _mTitleImageView.layer.cornerRadius = 3;
        _mTitleImageView.layer.masksToBounds = YES;
        _mTitleImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_label_article"]];
        imageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(38), ROUND_WIDTH_FLOAT(19));
        imageView.centerY = _mTitleImageView.height/2;
        imageView.right = _mTitleImageView.width;
        [_mTitleImageView addSubview:imageView];
    }
    return _mTitleImageView;
}

- (UILabel *)mTitleLabel {
    if (!_mTitleLabel) {
        _mTitleLabel = [UILabel new];
        _mTitleLabel.text = @"------";
        _mTitleLabel.textColor = [UIColor whiteColor];
    }
    return _mTitleLabel;
}

- (UIImageView *)commentImageView {
    if (!_commentImageView) {
        _commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_homepage_comment"]];
        _commentImageView.left = ROUND_WIDTH_FLOAT(15);
        _commentImageView.centerY = ROUND_WIDTH_FLOAT(134-22);
    }
    return _commentImageView;
}

- (UILabel *)mCommentCountLabel {
    if (!_mCommentCountLabel) {
        _mCommentCountLabel = [UILabel new];
        _mCommentCountLabel.text = @"9999";
        _mCommentCountLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
        _mCommentCountLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    }
    return _mCommentCountLabel;
}

- (UIImageView *)heartImageView {
    if (!_heartImageView) {
        _heartImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_homepage_like"]];
        _heartImageView.left = ROUND_WIDTH_FLOAT(86);
        _heartImageView.centerY = _commentImageView.centerY;
    }
    return _heartImageView;
}

- (UILabel *)mLikeLabel {
    if (!_mLikeLabel) {
        _mLikeLabel = [UILabel new];
        _mLikeLabel.text = @"99999";
        _mLikeLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
        _mLikeLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    }
    return _mLikeLabel;
}

- (void)layoutSubviews {
    [_mCommentCountLabel sizeToFit];
    _mCommentCountLabel.left = _commentImageView.right+ROUND_WIDTH_FLOAT(8);
    _mCommentCountLabel.centerY = _commentImageView.centerY;
    
    [_mLikeLabel sizeToFit];
    _mLikeLabel.left = _heartImageView.right+ROUND_WIDTH_FLOAT(8);
    _mLikeLabel.centerY = _heartImageView.centerY;
}

@end
