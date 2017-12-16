//
//  SKAboutViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/16.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKAboutViewController.h"

@interface SKAboutViewController ()

@end

@implementation SKAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?44:20, self.view.width, ROUND_WIDTH_FLOAT(44))];
    tView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tView];
    UILabel *tLabel = [UILabel new];
    tLabel.text = @"关于我们";
    tLabel.textColor = COMMON_TEXT_COLOR;
    tLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [tLabel sizeToFit];
    [tView addSubview:tLabel];
    tLabel.centerX = tView.width/2;
    tLabel.centerY = tView.height/2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_aboutpage_logo"]];
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(30));
        make.width.equalTo(ROUND_WIDTH(120));
        make.height.equalTo(ROUND_WIDTH(182));
        make.centerX.equalTo(tView);
    }];
    
    UILabel *label = [UILabel new];
    label.text = @"手 帐 种 草 拔 草 平 台";
    label.textColor = [UIColor blackColor];
    label.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [label sizeToFit];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tView);
        make.top.equalTo(imageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(10));
    }];
    
    UILabel *version = [UILabel new];
    version.text = [NSString stringWithFormat:@"v%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    version.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
    version.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [self.view addSubview:version];
    [version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(ROUND_HEIGHT_FLOAT(6));
        make.centerX.equalTo(tView);
    }];
    
    UIButton *followUs = [UIButton new];
    followUs.layer.cornerRadius = ROUND_WIDTH_FLOAT(22);
    followUs.layer.masksToBounds = YES;
    followUs.layer.borderWidth = 1;
    followUs.layer.borderColor = [UIColor colorWithHex:0x6b827a].CGColor;
    [followUs setTitle:@"关注糖草微博" forState:UIControlStateNormal];
    [followUs setTitleColor:[UIColor colorWithHex:0x6b827a] forState:UIControlStateNormal];
    followUs.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    [self.view addSubview:followUs];
    [followUs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(200), ROUND_WIDTH_FLOAT(44)));
        make.centerX.equalTo(tView);
        make.top.equalTo(version.mas_bottom).offset(37);
    }];
    [[followUs rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://weibo.com/2203980282"]];
    }];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"合作等事宜请联系 hello@tangcao.vip";
    bottomLabel.textColor = [UIColor colorWithHex:0x6b827a];
    bottomLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [bottomLabel sizeToFit];
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tView);
        make.bottom.equalTo(self.view).offset(ROUND_HEIGHT_FLOAT(-25));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
