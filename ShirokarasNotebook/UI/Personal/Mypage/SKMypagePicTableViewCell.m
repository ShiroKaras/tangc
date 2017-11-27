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
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageView0;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
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
        _imageView0.left = 10+IMAGE_WIDTH+6;
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
    }
    return _imageView2;
}
@end
