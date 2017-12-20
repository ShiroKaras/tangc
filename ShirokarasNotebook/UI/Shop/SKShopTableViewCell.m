//
//  SKShopTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/12.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKShopTableViewCell.h"

@implementation SKShopTableViewCellChildView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _mImageView.image = COMMON_PLACEHOLDER_IMAGE;
        _mImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mImageView.layer.masksToBounds = YES;
        [self addSubview:self.mImageView];
        
        _mContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(6), _mImageView.bottom+ROUND_WIDTH_FLOAT(6), ROUND_WIDTH_FLOAT(125.5), ROUND_WIDTH_FLOAT(30))];
        _mContentLabel.numberOfLines = 2;
        _mContentLabel.textColor = COMMON_TEXT_COLOR;
        _mContentLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        [self addSubview:self.mContentLabel];
        
        UILabel *dollar = [UILabel new];
        dollar.text = @"¥";
        dollar.textColor = [UIColor colorWithHex:0xD2946F];
        dollar.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        [dollar sizeToFit];
        [self addSubview:dollar];
        dollar.left = ROUND_WIDTH_FLOAT(6);
        dollar.bottom = frame.size.height-ROUND_WIDTH_FLOAT(6);
        
        _mMoneyLabel = [UILabel new];
        _mMoneyLabel.text = @"999999";
        _mMoneyLabel.textColor = [UIColor colorWithHex:0xD2946F];
        _mMoneyLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
        [self addSubview:_mMoneyLabel];
        [_mMoneyLabel sizeToFit];
        _mMoneyLabel.left = dollar.right+ROUND_WIDTH_FLOAT(2);
        _mMoneyLabel.bottom = dollar.bottom;
        
//        _mCountLabel = [UILabel new];
//        _mCountLabel.text = @"共999999件";
//        _mCountLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
//        _mCountLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
//        [self addSubview:_mCountLabel];
//        [_mCountLabel sizeToFit];
//        _mCountLabel.right = frame.size.width-ROUND_WIDTH_FLOAT(6);
//        _mCountLabel.bottom = _mMoneyLabel.bottom;
    }
    return self;
}

- (void)layoutSubviews {
//    _mCountLabel.right = self.size.width-ROUND_WIDTH_FLOAT(6);
//    _mCountLabel.bottom = _mMoneyLabel.bottom;
}

@end

@implementation SKShopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
        [self.contentView addSubview:self.view_left];
        [self.contentView addSubview:self.view_right];
    }
    return self;
}

- (UIView *)view_left {
    if (!_view_left) {
        _view_left = [[SKShopTableViewCellChildView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(137.5), ROUND_WIDTH_FLOAT(199))];
        _view_left.backgroundColor = [UIColor whiteColor];
        _view_left.layer.cornerRadius =3;
    }
    return _view_left;
}

- (UIView *)view_right {
    if (!_view_right) {
        _view_right = [[SKShopTableViewCellChildView alloc] initWithFrame:CGRectMake(_view_left.right+ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(137.5), ROUND_WIDTH_FLOAT(199))];
        _view_right.backgroundColor = [UIColor whiteColor];
        _view_right.layer.cornerRadius =3;
    }
    return _view_right;
}

- (void)setLeftData:(SKGoods *)leftData {
    [_view_left.mImageView sd_setImageWithURL:[NSURL URLWithString:leftData.image] placeholderImage:COMMON_PLACEHOLDER_IMAGE];
    _view_left.mContentLabel.text = leftData.name;
    _view_left.mMoneyLabel.text = leftData.price;
//    _view_left.mCountLabel.text = [NSString stringWithFormat:@"共%@件", leftData.click_num];
//    [_view_left.mCountLabel sizeToFit];
    [_view_left layoutSubviews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSString *u = [leftData.url componentsSeparatedByString:@"://"][1];
        
        //淘宝链接
        if ([u containsString:@"taobao"]) {
            // 构建淘宝客户端协议的 URL
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"taobao://%@",u]];
            // 判断当前系统是否有安装淘宝客户端
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                // 如果已经安装淘宝客户端，就使用客户端打开链接
                [[UIApplication sharedApplication] openURL:url];
            } else {
                // 否则使用 Mobile Safari 或者内嵌 WebView 来显示
                url=[NSURL URLWithString:leftData.url];
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:leftData.url]];
        }
    }];
    [_view_left addGestureRecognizer:tap];
}

- (void)setRightData:(SKGoods *)rightData {
    [_view_right.mImageView sd_setImageWithURL:[NSURL URLWithString:rightData.image] placeholderImage:COMMON_PLACEHOLDER_IMAGE];
    _view_right.mContentLabel.text = rightData.name;
    _view_right.mMoneyLabel.text = rightData.price;
//    _view_right.mCountLabel.text = [NSString stringWithFormat:@"共%@件", rightData.click_num];
//    [_view_right.mCountLabel sizeToFit];
    [_view_right layoutSubviews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSString *u = [rightData.url componentsSeparatedByString:@"://"][1];
        
        //淘宝链接
        if ([u containsString:@"taobao"]) {
            // 构建淘宝客户端协议的 URL
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"taobao://%@",u]];
            // 判断当前系统是否有安装淘宝客户端
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                // 如果已经安装淘宝客户端，就使用客户端打开链接
                [[UIApplication sharedApplication] openURL:url];
            } else {
                // 否则使用 Mobile Safari 或者内嵌 WebView 来显示
                url=[NSURL URLWithString:rightData.url];
                [[UIApplication sharedApplication] openURL:url];
            }
        } else  {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rightData.url]];
        }
    }];
    [_view_right addGestureRecognizer:tap];
}

@end
