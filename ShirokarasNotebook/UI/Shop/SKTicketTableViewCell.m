//
//  SKTicketTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTicketTableViewCell.h"

#define CELL_WIDTH (SCREEN_WIDTH-30)

@interface SKTicketTableViewCell ()
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation SKTicketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 3;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.cellHeight = (SCREEN_WIDTH-30)/290*91;
        
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.shopNameLabel];
        
        [self layoutIfNeeded];
    }
    return self;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-30)-ROUND_WIDTH_FLOAT(100), 0, ROUND_WIDTH_FLOAT(100), self.cellHeight)];
        _rightImageView.image = [UIImage imageNamed:@"img_mallpage_receive.png"];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.backgroundColor = COMMON_GREEN_COLOR;
        _rightImageView.userInteractionEnabled = YES;
    }
    return _rightImageView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.text = @"100元";
        _moneyLabel.textColor = COMMON_TEXT_COLOR;
        _moneyLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(32);
        [_moneyLabel sizeToFit];
        _moneyLabel.left = ROUND_WIDTH_FLOAT(6);
        _moneyLabel.top = ROUND_WIDTH_FLOAT(3);
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.text = @"使用时限：2017/11/07-2017/11/17";
        _timeLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _timeLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
        [_timeLabel sizeToFit];
        _timeLabel.bottom = self.cellHeight-6;
        _timeLabel.left = _moneyLabel.left;
    }
    return _timeLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = COMMON_BG_COLOR;
        _iconImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(20), ROUND_WIDTH_FLOAT(20));
        _iconImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(10);
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.left = _moneyLabel.left;
        _iconImageView.bottom = _timeLabel.top -3;
    }
    return _iconImageView;
}

- (UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel = [UILabel new];
        _shopNameLabel.text = @"jede服装旗舰店";
        _shopNameLabel.textColor = [UIColor colorWithHex:0x6B827A];
        _shopNameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [_shopNameLabel sizeToFit];
        _shopNameLabel.left = _iconImageView.right +6;
        _shopNameLabel.centerY = _iconImageView.centerY;
    }
    return _shopNameLabel;
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x +=ROUND_WIDTH_FLOAT(15);
    frame.origin.y += ROUND_WIDTH_FLOAT(15);
    frame.size.height -=ROUND_WIDTH_FLOAT(15);
    frame.size.width -=ROUND_WIDTH_FLOAT(30);
    [super setFrame:frame];
}

- (void)setTicket:(SKTicket *)ticket {
    _shopNameLabel.text = ticket.name;
    [_shopNameLabel sizeToFit];
    _moneyLabel.text = ticket.show_value;
    [_moneyLabel sizeToFit];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:ticket.image] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
    _timeLabel.text = [NSString stringWithFormat:@"使用期限：%@-%@", ticket.begin_time, ticket.end_time];
    [_timeLabel sizeToFit];
    _rightImageView.height = _rightImageView.superview.height;
    _rightImageView.centerY = _rightImageView.superview.centerY;
}
@end
