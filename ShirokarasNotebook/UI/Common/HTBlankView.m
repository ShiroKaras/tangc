//
//  HTBlankView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/21.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTBlankView.h"

@interface HTBlankView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) HTBlankViewType type;
@property (nonatomic, assign) CGFloat offset;
@end

@implementation HTBlankView

- (instancetype)initWithType:(HTBlankViewType)type {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)]) {
        _type = type;
        self.backgroundColor = [UIColor clearColor];
        switch (type) {
            case HTBlankViewTypeNetworkError:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_empty"]];;
                break;
            case HTBlankViewTypeNoMessage:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_messagelpage_empty"]];;
                break;
            case HTBlankViewTypeNoComment:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailpage_empty"]];;
                break;
            case HTBlankViewTypeNoThumb:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailpage_empty2"]];;
                break;
            case HTBlankViewTypeNoFollow:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_personalpage_empty3"]];;
                break;
            case HTBlankViewTypeNoFans:
                _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_personalpage_empty4"]];;
                break;
            default:
                break;
        }
        [self addSubview:_imageView];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage*)image text:(NSString*)text {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] initWithImage:image];;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image andOffset:(CGFloat)offset {
    _imageView.image = image;
    _offset = offset;
    [self setNeedsLayout];
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_imageView sizeToFit];
    _imageView.centerX = self.centerX;
    _imageView.top = 0;
    _label.top = _imageView.bottom + _offset;
    _label.centerX = _imageView.centerX;
}

@end
