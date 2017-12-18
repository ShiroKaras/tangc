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
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        [self.contentView addSubview:self.mCoverImageView];
        [self.contentView addSubview:self.mTitleLabel];
        [self.contentView addSubview:self.mAvatarImageView];
        [self.contentView addSubview:self.mUsernameLabel];
        [self.contentView addSubview:self.mTopicLabel];
        [self.contentView addSubview:self.favButton];
    }
    return self;
}

- (UIImageView *)mCoverImageView {
    if (!_mCoverImageView) {
        _mCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_WIDTH)];
        _mCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mCoverImageView.layer.masksToBounds = YES;
        _mCoverImageView.backgroundColor = [UIColor colorWithHex:0xD8DDF9];
    }
    return _mCoverImageView;
}

- (UILabel *)mTitleLabel {
    if (!_mTitleLabel) {
        _mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(10), CELL_WIDTH+ROUND_WIDTH_FLOAT(6), self.width-ROUND_WIDTH_FLOAT(20), ROUND_WIDTH_FLOAT(30))];
        _mTitleLabel.textColor = [UIColor colorWithHex:0x434343];
        _mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _mTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _mTitleLabel.numberOfLines = 3;
    }
    return _mTitleLabel;
}

- (UILabel *)mTopicLabel {
    if (!_mTopicLabel) {
        _mTopicLabel = [[UILabel alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(10), _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(6), self.width-ROUND_WIDTH_FLOAT(20), ROUND_WIDTH_FLOAT(15))];
        _mTopicLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _mTopicLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _mTopicLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _mTopicLabel.numberOfLines = 1;
    }
    return _mTopicLabel;
}

- (UIImageView *)mAvatarImageView {
    if (!_mAvatarImageView) {
        _mAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(25), ROUND_WIDTH_FLOAT(20), ROUND_WIDTH_FLOAT(20))];
        _mAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mAvatarImageView.layer.masksToBounds = YES;
        _mAvatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(10);
        _mAvatarImageView.image = COMMON_AVATAR_PLACEHOLDER_IMAGE;
    }
    return _mAvatarImageView;
}

- (UILabel *)mUsernameLabel {
    if (!_mUsernameLabel) {
        _mUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mAvatarImageView.right+6, _mTitleLabel.bottom+6, 50, ROUND_WIDTH_FLOAT(15))];
        _mUsernameLabel.textColor = COMMON_TEXT_COLOR;
        _mUsernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    }
    return _mUsernameLabel;
}

- (UIButton *)favButton {
    if (!_favButton) {
        //点赞
        _favButton = [UIButton new];
        [_favButton setImage:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
        [_favButton setTitle:@"999" forState:UIControlStateNormal];
        [_favButton setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
        _favButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        [_favButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        [self.contentView addSubview:_favButton];
    }
    return _favButton;
}


- (void)setTopic:(SKTopic *)topic {
    if (topic.images.count >0) {
        [_mCoverImageView sd_setImageWithURL:[NSURL URLWithString:topic.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
    }
    [_mAvatarImageView sd_setImageWithURL:[NSURL URLWithString:topic.userinfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
    _mUsernameLabel.text = topic.userinfo.nickname;
    
    _mTitleLabel.text = topic.content;
    CGSize maxSize = CGSizeMake(CELL_WIDTH-20, ROUND_WIDTH_FLOAT(45));//labelsize的最大值
    CGSize labelSize = [topic.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(10)} context:nil].size;
    _mTitleLabel.size = labelSize;
    [_favButton setTitle:topic.thumb_num forState:UIControlStateNormal];
    
    // 话题的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // @的规则
    NSString *atPattern = @"\\@[0-9a-zA-Z\\u4e00-\\u9fa5\\_\\-]+";
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@",topicPattern,atPattern];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    //匹配集合
    NSArray *results = [regex matchesInString:topic.content options:0 range:NSMakeRange(0, topic.content.length)];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[topic.content dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                  options:@{NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType}
                                                                       documentAttributes:nil error:nil];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        //set font
        [attrStr addAttribute:NSFontAttributeName value:PINGFANG_FONT_OF_SIZE(14) range:NSMakeRange(0, topic.content.length)];
        // 设置颜色
        [attrStr addAttribute:NSForegroundColorAttributeName value:COMMON_GREEN_COLOR range:result.range];
    }
    _mTitleLabel.attributedText = attrStr;
    
    _mTopicLabel.text = [NSString stringWithFormat:@"#%@#",topic.topics[0][@"name"]];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    _mAvatarImageView.top = _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(25);
    _mTitleLabel.width = CELL_WIDTH-ROUND_WIDTH_FLOAT(20);
    
    _mUsernameLabel.centerY = _mAvatarImageView.centerY;
    _mUsernameLabel.width = ROUND_WIDTH_FLOAT(60);
    self.cellHeight = _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(51);
    
    _mTopicLabel.top = _mTitleLabel.bottom +ROUND_WIDTH_FLOAT(3);
    
    _favButton.size = CGSizeMake(40, 20);
    _favButton.right = CELL_WIDTH-ROUND_WIDTH_FLOAT(6);
    _favButton.centerY = _mAvatarImageView.centerY;
}
@end
