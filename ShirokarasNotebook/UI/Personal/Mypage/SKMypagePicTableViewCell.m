//
//  SKMypagePicTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKMypagePicTableViewCell.h"

#define IMAGE_WIDTH (SCREEN_WIDTH-32)/3

@interface SKMypagePicTableViewCell ()

@end

@implementation SKMypagePicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView0];
        [self.contentView addSubview:self.imageView1];
        [self.contentView addSubview:self.imageView2];
        
        _imageView0.left = 10;
        _imageView1.left = 10+IMAGE_WIDTH+6;
        _imageView2.left = 10+IMAGE_WIDTH+6+IMAGE_WIDTH+6;
        
        self.cellHeight = ROUND_WIDTH_FLOAT(102);
    }
    return self;
}

- (UIImageView *)imageView0 {
    if (!_imageView0) {
        _imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
        _imageView0.layer.cornerRadius = 3;
        _imageView0.layer.masksToBounds = YES;
        _imageView0.image = [UIImage imageNamed:@"MaskCopy"];
        _imageView0.contentMode = UIViewContentModeScaleAspectFill;
        
        _countLabel0 = [UILabel new];
        _countLabel0.text = @"99";
        _countLabel0.textColor = [UIColor whiteColor];
        _countLabel0.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _countLabel0.layer.cornerRadius = 3;
        _countLabel0.layer.masksToBounds = YES;
        _countLabel0.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.6];
        _countLabel0.textAlignment = NSTextAlignmentCenter;
        [_countLabel0 sizeToFit];
        _countLabel0.width = _countLabel0.width+ROUND_WIDTH_FLOAT(10);
        _countLabel0.height = ROUND_WIDTH_FLOAT(16);
        _countLabel0.right = _imageView0.width-ROUND_WIDTH_FLOAT(5);
        _countLabel0.bottom = _imageView0.bottom-ROUND_WIDTH_FLOAT(5);
        [_imageView0 addSubview:_countLabel0];
    }
    return _imageView0;
}

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
        _imageView1.layer.cornerRadius = 3;
        _imageView1.layer.masksToBounds = YES;
        _imageView1.image = [UIImage imageNamed:@"MaskCopy"];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        
        _countLabel1 = [UILabel new];
        _countLabel1.text = @"99";
        _countLabel1.textColor = [UIColor whiteColor];
        _countLabel1.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _countLabel1.layer.cornerRadius = 3;
        _countLabel1.layer.masksToBounds = YES;
        _countLabel1.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.6];
        _countLabel1.textAlignment = NSTextAlignmentCenter;
        [_countLabel1 sizeToFit];
        _countLabel1.width = _countLabel1.width+ROUND_WIDTH_FLOAT(10);
        _countLabel1.height = ROUND_WIDTH_FLOAT(16);
        _countLabel1.right = _imageView1.width-ROUND_WIDTH_FLOAT(5);
        _countLabel1.bottom = _imageView1.bottom-ROUND_WIDTH_FLOAT(5);
        [_imageView1 addSubview:_countLabel1];
    }
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
        _imageView2.layer.cornerRadius = 3;
        _imageView2.layer.masksToBounds = YES;
        _imageView2.image = [UIImage imageNamed:@"MaskCopy"];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        
        _countLabel2 = [UILabel new];
        _countLabel2.text = @"99";
        _countLabel2.textColor = [UIColor whiteColor];
        _countLabel2.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _countLabel2.layer.cornerRadius = 3;
        _countLabel2.layer.masksToBounds = YES;
        _countLabel2.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.6];
        _countLabel2.textAlignment = NSTextAlignmentCenter;
        [_countLabel2 sizeToFit];
        _countLabel2.width = _countLabel2.width+ROUND_WIDTH_FLOAT(10);
        _countLabel2.height = ROUND_WIDTH_FLOAT(16);
        _countLabel2.right = _imageView2.width-ROUND_WIDTH_FLOAT(5);
        _countLabel2.bottom = _imageView2.bottom-ROUND_WIDTH_FLOAT(5);
        [_imageView2 addSubview:_countLabel2];
    }
    return _imageView2;
}
@end
