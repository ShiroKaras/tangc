//
//  SKPersonalIndexViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPersonalIndexViewController.h"
#import "SKPersonalMyPageViewController.h"
#import "SKAboutViewController.h"
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用

#import "SKPublishNewContentViewController.h"
#import "SKUserListViewController.h"

#import "FileService.h"

#define AUTH_BACK_VIEW_TAG 100
#define AUTH_LABEL 101

@interface SKPersonalIndexViewController ()
@property (nonatomic, strong) UIView *authBackView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UILabel *authTextLabel;
@property (nonatomic, strong) UILabel *cacheLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *cellsView;
@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, assign) BOOL isPushOff;
@end

@implementation SKPersonalIndexViewController {
    float         cacheSize;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[SKStorageManager sharedInstance].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
        if ([SKStorageManager sharedInstance].loginUser.uuid) {
            self.loginLabel.text = [SKStorageManager sharedInstance].userInfo.nickname;
            [self.loginLabel sizeToFit];
            _logoutButton.hidden = NO;
        } else {
            self.loginLabel.text = @"点击登录";
            [self.loginLabel sizeToFit];
            _logoutButton.hidden = YES;
        }
        self.loginLabel.centerY = self.avatarImageView.centerY;
        self.loginLabel.left = self.avatarImageView.right +10;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?44:20, self.view.width, ROUND_WIDTH_FLOAT(44))];
    tView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tView];
    UILabel *tLabel = [UILabel new];
    tLabel.text = @"我的";
    tLabel.textColor = COMMON_TEXT_COLOR;
    tLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [tLabel sizeToFit];
    [tView addSubview:tLabel];
    tLabel.centerX = tView.width/2;
    tLabel.centerY = tView.height/2;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?24:0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, ROUND_WIDTH_FLOAT(566));
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.authBackView];
    [_scrollView addSubview:self.cellsView];
    self.cellsView.top = self.authBackView.bottom+10;
    //logout
    _logoutButton = [UIButton new];
    [_logoutButton setBackgroundColor:[UIColor whiteColor]];
    [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutButton setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    _logoutButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
    _logoutButton.layer.cornerRadius = ROUND_WIDTH_FLOAT(22);
    _logoutButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(200), ROUND_WIDTH_FLOAT(44));
    _logoutButton.top = _cellsView.bottom+20;
    _logoutButton.centerX = _cellsView.width/2;
    [_scrollView addSubview:_logoutButton];
    [[_logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"确认退出？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [SKStorageManager sharedInstance].userInfo = [SKUserInfo new];
                                                                  [SKStorageManager sharedInstance].loginUser = [SKLoginUser new];
                                                                  [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[SKStorageManager sharedInstance].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
                                                                  if ([SKStorageManager sharedInstance].loginUser.uuid) {
                                                                      self.loginLabel.text = [SKStorageManager sharedInstance].userInfo.nickname;
                                                                      [self.loginLabel sizeToFit];
                                                                      _logoutButton.hidden = NO;
                                                                  } else {
                                                                      self.loginLabel.text = @"点击登录";
                                                                      [self.loginLabel sizeToFit];
                                                                      _logoutButton.hidden = YES;
                                                                  }
                                                                  self.loginLabel.centerY = self.avatarImageView.centerY;
                                                                  self.loginLabel.left = self.avatarImageView.right +10;
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) { }];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)authBackView {
    if (!_authBackView) {
        _authBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ROUND_WIDTH_FLOAT(44), SCREEN_WIDTH, ROUND_WIDTH_FLOAT(153))];
        _authBackView.backgroundColor = [UIColor whiteColor];
        
        self.avatarImageView = [UIImageView new];
        self.avatarImageView.backgroundColor = [UIColor colorWithHex:0xd8d8d8];
        self.avatarImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(55), ROUND_WIDTH_FLOAT(55));
        self.avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(55)/2;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.top = ROUND_WIDTH_FLOAT(15);
        self.avatarImageView.left = ROUND_WIDTH_FLOAT(15);
        [_authBackView addSubview:self.avatarImageView];
        
        self.loginLabel = [UILabel new];
        self.loginLabel.textColor = COMMON_TEXT_COLOR;
        self.loginLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
        [_authBackView addSubview:self.loginLabel];
        
        UIImageView *arrow = [self arrowImageView];
        arrow.centerY = self.avatarImageView.centerY;
        arrow.right = _authBackView.width-20;
        [_authBackView addSubview:arrow];
        
        _authBackView.height = self.avatarImageView.bottom+ROUND_WIDTH_FLOAT(15);
//        //认证背景
//        UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(self.avatarImageView.left, self.avatarImageView.bottom+10, _authBackView.width-30, _authBackView.height-self.avatarImageView.bottom-20)];
//        orangeView.backgroundColor = [UIColor colorWithHex:0xFFF7F0];
//        orangeView.layer.cornerRadius = 3;
//        [_authBackView addSubview:orangeView];
//
//        UIButton *goAuthButton = [UIButton new];
//        [goAuthButton setBackgroundImage:[UIImage imageNamed:@"btn_personalpage_authentication"] forState:UIControlStateNormal];
//        goAuthButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(60), ROUND_WIDTH_FLOAT(30));
//        goAuthButton.centerY = orangeView.height/2;
//        goAuthButton.right = orangeView.width-10;
//        [orangeView addSubview:goAuthButton];
//
//        self.authTextLabel = [UILabel new];
//        self.authTextLabel.text = @"身份认证（品牌、团体、画师认证，秀出你的不同）";
//        self.authTextLabel.textColor = [UIColor colorWithHex:0xFA7716];
//        self.authTextLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(11);
//        self.authTextLabel.numberOfLines = 2;
//        self.authTextLabel.size = CGSizeMake(ROUND_WIDTH_FLOAT(200), ROUND_WIDTH_FLOAT(50));
//        [self.authTextLabel sizeToFit];
//        self.authTextLabel.left = 10;
//        self.authTextLabel.centerY = orangeView.height/2;
//        [orangeView addSubview:self.authTextLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
                [self invokeLoginViewController];
            } else {
                [self enterMyPage:tapGesture];
            }
        }];
        [_authBackView addGestureRecognizer:tapGesture];
    }
    return _authBackView;
}

- (UIView *)cellsView {
    if (!_cellsView) {
        _cellsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(44*6)+20)];
        
        //我的关注
        UIView *cell_follow = [self cellWithImageName:@"img_personalpage_myfollow" title:@"我的关注" isShowArrow:YES];
        [_cellsView addSubview:cell_follow];
        UITapGestureRecognizer *tapGesture_follow = [[UITapGestureRecognizer alloc] init];
        [[tapGesture_follow rac_gestureSignal] subscribeNext:^(id x) {
            if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
                [self invokeLoginViewController];
                return;
            }
            SKUserListViewController *controller = [[SKUserListViewController alloc] initWithType:SKUserListTypeFollow];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        [cell_follow addGestureRecognizer:tapGesture_follow];
        
        //我的粉丝
        UIView *cell_fans = [self cellWithImageName:@"img_personalpage_myfans" title:@"我的粉丝" isShowArrow:YES];
        [_cellsView addSubview:cell_fans];
        cell_fans.top = cell_follow.bottom;
        UITapGestureRecognizer *tapGesture_fans = [[UITapGestureRecognizer alloc] init];
        [[tapGesture_fans rac_gestureSignal] subscribeNext:^(id x) {
            if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
                [self invokeLoginViewController];
                return;
            }
            SKUserListViewController *controller = [[SKUserListViewController alloc] initWithType:SKUserListTypeFans];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        [cell_fans addGestureRecognizer:tapGesture_fans];
        
        //推送开关
        UIView *cell_push = [self cellWithImageName:@"img_personalpage_push" title:@"推送通知" isShowArrow:YES];
        [_cellsView addSubview:cell_push];
        cell_push.top = cell_fans.bottom+10;
        _isPushOff = [[UD objectForKey:@"PushModeForOff"] boolValue];       //初始为NO，默认打开通知
        //TODO 刷新按钮状态
        
        UITapGestureRecognizer *tapGesture_push = [[UITapGestureRecognizer alloc] init];
        [[tapGesture_push rac_gestureSignal] subscribeNext:^(id x) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [cell_push addGestureRecognizer:tapGesture_push];
        [GeTuiSdk setPushModeForOff:NO];
        
        //清除缓存
        UIView *cell_clear = [self cellWithImageName:@"img_personalpage_clean" title:@"清理缓存" isShowArrow:NO];
        [_cellsView addSubview:cell_clear];
        _cacheLabel = [UILabel new];
        NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        [self listFileAtPath:cacheFilePath];
        _cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", cacheSize];
        _cacheLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _cacheLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [cell_clear addSubview:_cacheLabel];
        [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell_clear).offset(ROUND_WIDTH_FLOAT(-15));
            make.centerY.equalTo(cell_clear);
        }];
        cell_clear.top = cell_push.bottom;
        UITapGestureRecognizer *tapGesture_clear = [[UITapGestureRecognizer alloc] init];
        [[tapGesture_clear rac_gestureSignal] subscribeNext:^(id x) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [[SDImageCache sharedImageCache] clearMemory];//可有可无
            [FileService clearCache:cacheFilePath];
            [self listFileAtPath:cacheFilePath];
            _cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", cacheSize];
        }];
        [cell_clear addGestureRecognizer:tapGesture_clear];
        
        //关于
        UIView *cell_about = [self cellWithImageName:@"img_personalpage_about" title:@"关于我们" isShowArrow:YES];
        [_cellsView addSubview:cell_about];
        cell_about.top = cell_clear.bottom;
        UITapGestureRecognizer *tapGesture_about = [[UITapGestureRecognizer alloc] init];
        [[tapGesture_about rac_gestureSignal] subscribeNext:^(id x) {
            SKAboutViewController *controller = [[SKAboutViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        [cell_about addGestureRecognizer:tapGesture_about];
        
        //
        UIView *cell = [UIView new];
        cell.backgroundColor = [UIColor whiteColor];
        cell.size = CGSizeMake(SCREEN_WIDTH, ROUND_WIDTH_FLOAT(44));
        cell.top = cell_about.bottom+10;
        [_cellsView addSubview:cell];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"喜欢糖草？请给我们好评吧！";
        titleLabel.textColor = COMMON_TEXT_COLOR;
        titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [titleLabel sizeToFit];
        titleLabel.left = 15;
        titleLabel.centerY = cell.height/2;
        [cell addSubview:titleLabel];
        
        UIImageView *arrow = [self arrowImageView];
        arrow.right = cell.width-20;
        arrow.centerY = cell.height/2;
        [cell addSubview:arrow];
    }
    return _cellsView;
}

- (UIView *)cellWithImageName:(NSString *)imageName title:(NSString *)title isShowArrow:(BOOL)isShow{
    UIView *cell = [UIView new];
    cell.backgroundColor = [UIColor whiteColor];
    cell.size = CGSizeMake(SCREEN_WIDTH, ROUND_WIDTH_FLOAT(44));
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    icon.left = 15;
    icon.centerY = cell.height/2;
    [cell addSubview:icon];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.textColor = COMMON_TEXT_COLOR;
    titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [titleLabel sizeToFit];
    titleLabel.left = icon.right+8;
    titleLabel.centerY = icon.centerY;
    [cell addSubview:titleLabel];
    
    UIImageView *arrow = [self arrowImageView];
    arrow.right = cell.width-20;
    arrow.centerY = cell.height/2;
    [cell addSubview:arrow];
    arrow.hidden = !isShow;
    
    return cell;
}

- (UIImageView*)arrowImageView {
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_personalpage_nextpage"]];
    return arrow;
}

#pragma mark - Actions

- (void)listFileAtPath:(NSString *)path {
    cacheSize = 0;
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [path stringByAppendingPathComponent:aPath];
        cacheSize += [FileService fileSizeAtPath:fullPath];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
            [self listFileAtPath:fullPath];
        }
    }
}

- (void)enterMyPage:(UIGestureRecognizer *)sender {
    SKPersonalMyPageViewController *controller = [[SKPersonalMyPageViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
