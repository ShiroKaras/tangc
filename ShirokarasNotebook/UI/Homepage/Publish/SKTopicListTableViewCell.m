//
//  SKTopicListTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTopicListTableViewCell.h"

@interface SKTopicListTableViewCell ()

@end

@implementation SKTopicListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.topicLabel];
        [self.contentView addSubview:self.checkButton];
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
        _checkButton.centerY = ROUND_WIDTH_FLOAT(30);
        _checkButton.right = SCREEN_WIDTH -ROUND_WIDTH_FLOAT(15);
    }
    return _checkButton;
}

- (void)setIsCheck:(BOOL)isCheck {
    [_checkButton setBackgroundImage:isCheck?[UIImage imageNamed:@"btn_choicepage_confirm"]:[UIImage imageNamed:@"btn_choicepage_confirm_blank"] forState:UIControlStateNormal];
}

@end
