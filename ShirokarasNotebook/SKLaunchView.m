//
//  SKLaunchView.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKLaunchView.h"

@implementation SKLaunchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 在window上放一个imageView
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(460))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_startpage_logo"]];
        [self addSubview:icon];
        icon.size = CGSizeMake(ROUND_WIDTH_FLOAT(122), ROUND_WIDTH_FLOAT(44));
        icon.centerX = imageView.centerX;
        icon.centerY = ROUND_WIDTH_FLOAT(460)+(SCREEN_HEIGHT-ROUND_WIDTH_FLOAT(460))/2;
        
        UIButton *skipButton = [UIButton new];
        [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        skipButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        skipButton.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
        skipButton.layer.cornerRadius = ROUND_WIDTH_FLOAT(11);
        [self addSubview:skipButton];
        skipButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(22));
        skipButton.top = kDevice_Is_iPhoneX?(44+20):(20+20);
        skipButton.right = self.right-ROUND_WIDTH_FLOAT(8);
        [[skipButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha=0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
        
        [[[SKServiceManager sharedInstance] topicService] getIndexHeaderImagesArrayWithCallback:^(BOOL success, SKResponsePackage *response) {
            [imageView sd_setImageWithURL:response.data[@"start_image"]];
        }];
    }
    return self;
}

@end
