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
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "SKPublishNewContentViewController.h"
#import "SKUserListViewController.h"

#import "FileService.h"

#define AUTH_BACK_VIEW_TAG 100
#define AUTH_LABEL 101

#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

@interface SKPersonalIndexViewController ()
@property (nonatomic, strong) UIView *authBackView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) UILabel *label_follow;
@property (nonatomic, strong) UILabel *label_fans;

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
        [self.authBackView removeFromSuperview];
        self.authBackView = nil;
        [self.scrollView addSubview:self.authBackView];
        self.loginLabel.centerY = self.avatarImageView.centerY;
        self.loginLabel.left = self.avatarImageView.right +10;
        self.logoutButton.hidden = [SKStorageManager sharedInstance].loginUser.uuid==nil?YES:NO;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-(kDevice_Is_iPhoneX?44:0))];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, ROUND_WIDTH_FLOAT(566));
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
#ifdef __IPHONE_11_0
    if ([_scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
#endif
    
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
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _logoutButton.bottom);
    
    [[_logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"确认退出？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  SSDKPlatformType type = 0;
                                                                  NSLog(@"%@", [SKStorageManager sharedInstance].loginUser.login_type);
                                                                  if ([[SKStorageManager sharedInstance].loginUser.login_type isEqualToString:@"weibo"]) {
                                                                      type = SSDKPlatformTypeSinaWeibo;
                                                                  } else if ([[SKStorageManager sharedInstance].loginUser.login_type isEqualToString:@"qq"]) {
                                                                      type = SSDKPlatformTypeQQ;
                                                                  } else if ([[SKStorageManager sharedInstance].loginUser.login_type isEqualToString:@"weixin"]) {
                                                                      type = SSDKPlatformTypeWechat;
                                                                  } else {
                                                                      type = SSDKPlatformTypeUnknown;
                                                                  }
                                                                  [ShareSDK cancelAuthorize:type];
                                                                  
                                                                  [SKStorageManager sharedInstance].userInfo = [SKUserInfo new];
                                                                  [SKStorageManager sharedInstance].loginUser = [SKLoginUser new];
                                                                  [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[SKStorageManager sharedInstance].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
                                                                  [self.authBackView removeFromSuperview];
                                                                  self.authBackView = nil;
                                                                  [self.scrollView addSubview:self.authBackView];
                                                                  self.loginLabel.centerY = self.avatarImageView.centerY;
                                                                  self.loginLabel.left = self.avatarImageView.right +10;
                                                                  self.logoutButton.hidden = YES;
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
        _authBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(180))];
        _authBackView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(180))];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.layer.masksToBounds = YES;
        [_authBackView addSubview:headerImageView];
        [[[SKServiceManager sharedInstance] topicService] getIndexHeaderImagesArrayWithCallback:^(BOOL success, SKResponsePackage *response) {
            [headerImageView sd_setImageWithURL:response.data[@"personal_detail_top"]];
        }];
        
        UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _authBackView.width, _authBackView.height)];
        alphaView.backgroundColor = [UIColor colorWithHex:0x3b3b3b alpha:0.6];
        [_authBackView addSubview:alphaView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
                [self invokeLoginViewController];
            } else {
                [self enterMyPage:tapGesture];
            }
        }];
        [alphaView addGestureRecognizer:tapGesture];
        
        if ([SKStorageManager sharedInstance].loginUser.uuid) {
            
            _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(66), ROUND_WIDTH_FLOAT(66))];
            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[SKStorageManager sharedInstance].userInfo.avatar] placeholderImage:COMMON_AVATAR_PLACEHOLDER_IMAGE];
            _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(33);
            _avatarImageView.layer.masksToBounds = YES;
            _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
            _avatarImageView.top = ROUND_WIDTH_FLOAT(38);
            _avatarImageView.centerX = _authBackView.centerX;
            [_authBackView addSubview:_avatarImageView];
            
            _mTitleLabel = [UILabel new];
            _mTitleLabel.text = [SKStorageManager sharedInstance].userInfo.nickname;
            _mTitleLabel.textColor = [UIColor whiteColor];
            _mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
            [_mTitleLabel sizeToFit];
            _mTitleLabel.top = _avatarImageView.bottom +ROUND_WIDTH_FLOAT(7);
            _mTitleLabel.centerX = self.view.centerX;
            [_authBackView addSubview:_mTitleLabel];
            
            _label_follow = [UILabel new];
            _label_follow.text = [NSString stringWithFormat:@"关注 %ld", [SKStorageManager sharedInstance].userInfo.follows];
            _label_follow.textColor = [UIColor whiteColor];
            _label_follow.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
            [_label_follow sizeToFit];
            _label_follow.right = _authBackView.width/2-5;
            _label_follow.top = _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(3);
            [_authBackView addSubview:_label_follow];
            
            _label_fans = [UILabel new];
            _label_fans.text = [NSString stringWithFormat:@"粉丝 %ld", [SKStorageManager sharedInstance].userInfo.follows];
            _label_fans.textColor = [UIColor whiteColor];
            _label_fans.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
            [_label_fans sizeToFit];
            _label_fans.left = _authBackView.width/2+5;
            _label_fans.top = _mTitleLabel.bottom +ROUND_WIDTH_FLOAT(3);
            [_authBackView addSubview:_label_fans];
            
            UILabel *editLabel = [UILabel new];
            editLabel.text = @"编辑个人页";
            editLabel.textColor = [UIColor whiteColor];
            editLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
            editLabel.layer.cornerRadius = 8;
            editLabel.layer.borderWidth = 1;
            editLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            editLabel.textAlignment = NSTextAlignmentCenter;
            [editLabel sizeToFit];
            [_authBackView addSubview:editLabel];
            editLabel.width = ROUND_WIDTH_FLOAT(73);
            editLabel.height = ROUND_WIDTH_FLOAT(16);
            editLabel.centerX = _authBackView.centerX;
            editLabel.top = _label_follow.bottom+ROUND_WIDTH_FLOAT(3);
        }
        else {
            UILabel *loginLabel = [UILabel new];
            loginLabel.text = @"您还没有登录";
            loginLabel.textColor = [UIColor whiteColor];
            loginLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
            [_authBackView addSubview:loginLabel];
            [loginLabel sizeToFit];
            loginLabel.centerX = _authBackView.centerX;
            loginLabel.top = ROUND_WIDTH_FLOAT(64);
            
            UILabel *login = [UILabel new];
            login.text = @"登录";
            login.textColor = [UIColor whiteColor];
            login.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
            login.layer.cornerRadius = ROUND_WIDTH_FLOAT(17);
            login.layer.borderColor = [UIColor whiteColor].CGColor;
            login.layer.borderWidth = 1;
            login.textAlignment = NSTextAlignmentCenter;
            [_authBackView addSubview:login];
            login.width = ROUND_WIDTH_FLOAT(150);
            login.height = ROUND_WIDTH_FLOAT(34);
            login.centerX = _authBackView.centerX;
            login.top = loginLabel.bottom+ROUND_WIDTH_FLOAT(33);
        }
        
        
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
    
    UIView *line = [UIView new];
    line.backgroundColor = COMMON_SEPARATOR_COLOR;
    [cell addSubview:line];
    line.width = SCREEN_WIDTH - ROUND_WIDTH_FLOAT(30);
    line.height = 0.5;
    line.left = ROUND_WIDTH_FLOAT(15);
    line.bottom = cell.bottom;
    
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
