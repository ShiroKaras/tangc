//
//  SKPersonalArticleCollectionViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPersonalArticleCollectionViewCell.h"

@implementation SKPersonalArticleCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.dateLabel];
        
        self.cellHeight = ROUND_WIDTH_FLOAT(134);
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), 0, ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(75))];
        _imageView.layer.cornerRadius = 3;
        _imageView.layer.masksToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"MaskCopy"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.text = @"2017/11/11";
        _dateLabel.textColor = [UIColor colorWithHex:0xb0b0b0];
        _dateLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
        [_dateLabel sizeToFit];
        _dateLabel.top = _imageView.bottom+ROUND_WIDTH_FLOAT(15);
        _dateLabel.right = _imageView.right;
    }
    return _dateLabel;
}

@end
