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
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-30)-ROUND_WIDTH_FLOAT(100), 0, ROUND_WIDTH_FLOAT(100), self.cellHeight)];
        rightImageView.backgroundColor = [UIColor colorWithHex:0x37ECBA];
        [self.contentView addSubview:rightImageView];
        
        _moneyLabel = [UILabel new];
        _moneyLabel.text = @"100元";
        _moneyLabel.textColor = COMMON_TEXT_COLOR;
        _moneyLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(32);
        [_moneyLabel sizeToFit];
        _moneyLabel.left = ROUND_WIDTH_FLOAT(6);
        _moneyLabel.top = ROUND_WIDTH_FLOAT(3);
        [self.contentView addSubview:_moneyLabel];
        
        _timeLabel = [UILabel new];
        _timeLabel.text = @"使用时限：2017/11/07-2017/11/17";
        _timeLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _timeLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
        [_timeLabel sizeToFit];
        _timeLabel.bottom = self.cellHeight-6;
        _timeLabel.left = _moneyLabel.left;
        [self.contentView addSubview:_timeLabel];
        
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = COMMON_BG_COLOR;
        _iconImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(20), ROUND_WIDTH_FLOAT(20));
        _iconImageView.left = _moneyLabel.left;
        _iconImageView.bottom = _timeLabel.top -3;
        [self.contentView addSubview:_iconImageView];
        
        _shopNameLabel = [UILabel new];
        _shopNameLabel.text = @"jede服装旗舰店";
        _shopNameLabel.textColor = [UIColor colorWithHex:0x6B827A];
        _shopNameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [_shopNameLabel sizeToFit];
        _shopNameLabel.left = _iconImageView.right +6;
        _shopNameLabel.centerY = _iconImageView.centerY;
        [self.contentView addSubview:_shopNameLabel];
        
        [self layoutIfNeeded];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x +=15;
    frame.origin.y += 15;
    frame.size.height -=15;
    frame.size.width -=30;
    [super setFrame:frame];
}

@end
