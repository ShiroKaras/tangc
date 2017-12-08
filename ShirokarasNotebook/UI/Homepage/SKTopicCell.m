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
        _mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(10), CELL_WIDTH+ROUND_WIDTH_FLOAT(6), self.width-ROUND_WIDTH_FLOAT(20), ROUND_WIDTH_FLOAT(30))];
        _mTitleLabel.textColor = [UIColor colorWithHex:0x434343];
        _mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _mTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _mTitleLabel.numberOfLines = 3;
    }
    return _mTitleLabel;
}

- (UIImageView *)mAvatarImageView {
    if (!_mAvatarImageView) {
        _mAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(25), ROUND_WIDTH_FLOAT(20), ROUND_WIDTH_FLOAT(20))];
        _mAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mAvatarImageView.layer.masksToBounds = YES;
        _mAvatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(10);
        _mAvatarImageView.image = [UIImage imageNamed:@"img_personalpage_headimage_default"];
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

- (void)setTopic:(NSString *)topic {
    _mTitleLabel.text = topic;
    CGSize maxSize = CGSizeMake(CELL_WIDTH-20, ROUND_WIDTH_FLOAT(45));//labelsize的最大值
    CGSize labelSize = [topic boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(10)} context:nil].size;
    _mTitleLabel.size = labelSize;
    
    // 话题的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // @的规则
    NSString *atPattern = @"\\@[0-9a-zA-Z\\u4e00-\\u9fa5\\_\\-]+";
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@",topicPattern,atPattern];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    //匹配集合
    NSArray *results = [regex matchesInString:topic options:0 range:NSMakeRange(0, topic.length)];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[topic dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                       documentAttributes:nil error:nil];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        //set font
        [attrStr addAttribute:NSFontAttributeName value:PINGFANG_FONT_OF_SIZE(14) range:NSMakeRange(0, topic.length)];
        // 设置颜色
        [attrStr addAttribute:NSForegroundColorAttributeName value:COMMON_GREEN_COLOR range:result.range];
    }
    _mTitleLabel.attributedText = attrStr;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    _mAvatarImageView.top = _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(25);
    _mUsernameLabel.centerY = _mAvatarImageView.centerY;
    _mUsernameLabel.width = ROUND_WIDTH_FLOAT(60);
    self.cellHeight = _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(51);
}
@end
