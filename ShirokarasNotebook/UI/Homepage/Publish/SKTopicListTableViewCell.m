//
//  SKTopicListTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTopicListTableViewCell.h"

@interface SKTopicListTableViewCell ()
@property (nonatomic, strong) UIView *underLine;
@end

@implementation SKTopicListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.topicLabel];
        [self.contentView addSubview:self.checkButton];
        [self.contentView addSubview:self.underLine];
    }
    return self;
}

- (UILabel *)topicLabel {
    if (!_topicLabel) {
        _topicLabel = [UILabel new];
        _topicLabel.text = @"#最美手帐#";
        _topicLabel.textColor = COMMON_TEXT_COLOR;
        _topicLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [_topicLabel sizeToFit];
        _topicLabel.centerY = ROUND_WIDTH_FLOAT(22);
        _topicLabel.left = ROUND_WIDTH_FLOAT(15);
    }
    return _topicLabel;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton new];
        [_checkButton setBackgroundImage:[UIImage imageNamed:@"btn_choicepage_confirm_blank"] forState:UIControlStateNormal];
        _checkButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(16), ROUND_WIDTH_FLOAT(16));
        _checkButton.centerY = ROUND_WIDTH_FLOAT(22);
        _checkButton.right = SCREEN_WIDTH -ROUND_WIDTH_FLOAT(15);
    }
    return _checkButton;
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [UIView new];
        _underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
        _underLine.size = CGSizeMake(ROUND_WIDTH_FLOAT(290), 0.5);
        _underLine.left = ROUND_WIDTH_FLOAT(15);
        _underLine.bottom = ROUND_WIDTH_FLOAT(44);
    }
    return _underLine;
}

- (void)setIsCheck:(BOOL)isCheck {
    [_checkButton setBackgroundImage:isCheck?[UIImage imageNamed:@"btn_choicepage_confirm"]:[UIImage imageNamed:@"btn_choicepage_confirm_blank"] forState:UIControlStateNormal];
}

@end
