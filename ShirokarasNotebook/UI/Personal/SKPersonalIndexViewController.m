//
//  SKPersonalIndexViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPersonalIndexViewController.h"
#import "SKPersonalMyPageViewController.h"

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

@property (nonatomic, strong) UIView *cellsView;
@end

@implementation SKPersonalIndexViewController {
    float         cacheSize;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, ROUND_WIDTH_FLOAT(566));
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:self.authBackView];
    [scrollView addSubview:self.cellsView];
    self.cellsView.top = self.authBackView.bottom+10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)authBackView {
    if (!_authBackView) {
        _authBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(153))];
        _authBackView.backgroundColor = [UIColor whiteColor];
        
        self.avatarImageView = [UIImageView new];
        self.avatarImageView.backgroundColor = [UIColor colorWithHex:0xd8d8d8];
        self.avatarImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(55), ROUND_WIDTH_FLOAT(55));
        self.avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(55)/2;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[SKStorageManager sharedInstance].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
        self.avatarImageView.top = 15;
        self.avatarImageView.left = 15;
        [_authBackView addSubview:self.avatarImageView];
        
        self.loginLabel = [UILabel new];
        self.loginLabel.text = @"点击登录";
        self.loginLabel.textColor = COMMON_TEXT_COLOR;
        self.loginLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
        [self.loginLabel sizeToFit];
        self.loginLabel.centerY = self.avatarImageView.centerY;
        self.loginLabel.left = self.avatarImageView.right +10;
        [_authBackView addSubview:self.loginLabel];
        
        UIImageView *arrow = [self arrowImageView];
        arrow.centerY = self.avatarImageView.centerY;
        arrow.right = _authBackView.width-20;
        [_authBackView addSubview:arrow];
        
        //认证背景
        UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(self.avatarImageView.left, self.avatarImageView.bottom+10, _authBackView.width-30, _authBackView.height-self.avatarImageView.bottom-20)];
        orangeView.backgroundColor = [UIColor colorWithHex:0xFFF7F0];
        orangeView.layer.cornerRadius = 3;
        [_authBackView addSubview:orangeView];
        
        UIButton *goAuthButton = [UIButton new];
        [goAuthButton setBackgroundImage:[UIImage imageNamed:@"btn_personalpage_authentication"] forState:UIControlStateNormal];
        goAuthButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(60), ROUND_WIDTH_FLOAT(30));
        goAuthButton.centerY = orangeView.height/2;
        goAuthButton.right = orangeView.width-10;
        [orangeView addSubview:goAuthButton];
        
        self.authTextLabel = [UILabel new];
        self.authTextLabel.text = @"身份认证（品牌、团体、画师认证，秀出你的不同）";
        self.authTextLabel.textColor = [UIColor colorWithHex:0xFA7716];
        self.authTextLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(11);
        self.authTextLabel.numberOfLines = 2;
        self.authTextLabel.size = CGSizeMake(ROUND_WIDTH_FLOAT(200), ROUND_WIDTH_FLOAT(50));
        [self.authTextLabel sizeToFit];
        self.authTextLabel.left = 10;
        self.authTextLabel.centerY = orangeView.height/2;
        [orangeView addSubview:self.authTextLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (![SKStorageManager sharedInstance].userInfo.uuid) {
//                [self invokeLoginViewController];
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
            SKUserListViewController *controller = [[SKUserListViewController alloc] initWithType:SKUserListTypeFans];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        [cell_fans addGestureRecognizer:tapGesture_fans];
        
        UIView *cell_push = [self cellWithImageName:@"img_personalpage_push" title:@"推送通知" isShowArrow:YES];
        [_cellsView addSubview:cell_push];
        cell_push.top = cell_fans.bottom+10;
        BOOL isPushOff = [[UD objectForKey:@"PushModeForOff"] boolValue];       //初始为NO，默认打开通知
        //TODO 刷新按钮状态
        
        UITapGestureRecognizer *tapGesture_push = [[UITapGestureRecognizer alloc] init];
        [[tapGesture_push rac_gestureSignal] subscribeNext:^(id x) {
            [UD setValue:@(isPushOff) forKey:@"PushModeForOff"];
            [GeTuiSdk setPushModeForOff:isPushOff];
        }];
        [cell_fans addGestureRecognizer:tapGesture_push];
        
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
        
        //logout
        UIButton *logoutButton = [UIButton new];
        [logoutButton setBackgroundColor:[UIColor whiteColor]];
        [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutButton setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
        logoutButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
        logoutButton.layer.cornerRadius = ROUND_WIDTH_FLOAT(22);
        logoutButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(200), ROUND_WIDTH_FLOAT(44));
        logoutButton.top = cell.bottom+20;
        logoutButton.centerX = _cellsView.width/2;
        [_cellsView addSubview:logoutButton];
        
        
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
    SKLoginUser *user = [SKLoginUser new];
    user.open_id = @"ios_test";
    user.nickname = @"ios_testname";
    user.avatar = @"http://avatar.csdn.net/F/A/7/3_sinat_34137390.jpg";
    user.login_type = @"weixin";
    
    [[[SKServiceManager sharedInstance] loginService] loginWithThirdPlatform:user callback:^(BOOL success, SKResponsePackage *response) {
        NSLog(@"%@", response.data);
    }];

//    SKPersonalMyPageViewController *controller = [[SKPersonalMyPageViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
}

@end
