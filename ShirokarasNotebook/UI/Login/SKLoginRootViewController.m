//
//  SKLoginRootViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/13.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKLoginRootViewController.h"
#import "SKHomepageViewController.h"
#import "SKLoginVerifyMobileViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface SKLoginRootViewController ()

@end

@implementation SKLoginRootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_loginpage_background_%f",SCREEN_WIDTH]]];
    [self.view addSubview:backImageView];
    
    __weak __typeof(self) weakSelf = self;
    
    //skip
    UIButton *button_skip = [UIButton new];
    [button_skip setTitle:@"跳过" forState:UIControlStateNormal];
    [button_skip setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
    button_skip.size = CGSizeMake(44, 44);
    button_skip.top = 20;
    button_skip.right = self.view.right -20;
    [self.view addSubview:button_skip];
    [[button_skip rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //login buttons
    UIButton *login_weibo = [UIButton new];
    login_weibo.tag = 102;
    [login_weibo addTarget:self action:@selector(didClickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [login_weibo setBackgroundImage:[UIImage imageNamed:@"btn_loginpage_weibo"] forState:UIControlStateNormal];
    login_weibo.layer.cornerRadius = ROUND_HEIGHT_FLOAT(22);
    login_weibo.width = ROUND_WIDTH_FLOAT(220);
    login_weibo.height = ROUND_HEIGHT_FLOAT(44);
    login_weibo.centerX = weakSelf.view.centerX;
    login_weibo.bottom = weakSelf.view.bottom - ROUND_WIDTH_FLOAT(52.5);
    [self.view addSubview:login_weibo];
    
    UIButton *login_qq = [UIButton new];
    login_qq.tag = 101;
    [login_qq addTarget:self action:@selector(didClickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [login_qq setTitle:@"QQ登录" forState:UIControlStateNormal];
    [login_qq setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    login_qq.width = ROUND_WIDTH_FLOAT(100);
    login_qq.height = ROUND_HEIGHT_FLOAT(44);
    login_qq.left = login_weibo.left;
    login_qq.top = login_weibo.bottom +10;
    [self.view addSubview:login_qq];
    
    UIButton *login_weixin = [UIButton new];
    login_weixin.tag = 100;
    [login_weixin addTarget:self action:@selector(didClickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [login_weixin setTitle:@"微信登录" forState:UIControlStateNormal];
    [login_weixin setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    login_weixin.width = ROUND_WIDTH_FLOAT(100);
    login_weixin.height = ROUND_HEIGHT_FLOAT(44);
    login_weixin.left = login_qq.right+ROUND_WIDTH_FLOAT(20);
    login_weixin.top = login_weibo.bottom +10;
    [self.view addSubview:login_weixin];
}

//Test
- (void)didclickWeiboButton {
    SKLoginVerifyMobileViewController *controller = [[SKLoginVerifyMobileViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickLoginButton:(UIButton*)sender {
    switch (sender.tag) {
        case 100: {
            [ShareSDK getUserInfo:SSDKPlatformTypeWechat
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                       if (state == SSDKResponseStateSuccess) {
                           DLog(@"uid=%@", user.uid);
                           DLog(@"%@", user.credential);
                           DLog(@"token=%@", user.credential.token);
                           DLog(@"nickname=%@", user.nickname);
                           
                           [self loginWithUser:user type:@"weixin"];
                       }
                       
                       else {
                           DLog(@"%@", error);
                       }
                       
                   }];
            break;
        }
        case 101: {
            [ShareSDK getUserInfo:SSDKPlatformTypeQQ
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                       if (state == SSDKResponseStateSuccess) {
                           DLog(@"uid=%@", user.uid);
                           DLog(@"credential=%@", user.credential);
                           DLog(@"token=%@", user.credential.token);
                           DLog(@"nickname=%@", user.nickname);
                           
                           [self loginWithUser:user type:@"qq"];
                       }
                       
                       else {
                           DLog(@"%@", error);
                       }
                       
                   }];
            break;
        }
        case 102: {
            [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                       if (state == SSDKResponseStateSuccess) {
                           DLog(@"uid=%@", user.uid);
                           DLog(@"%@", user.credential);
                           DLog(@"token=%@", user.credential.token);
                           DLog(@"nickname=%@", user.nickname);
                           DLog(@"icon=%@", user.icon);
                           
                           [self loginWithUser:user type:@"weibo"];
                       } else {
                           DLog(@"%@", error);
                       }
                       
                   }];
            break;
        }
        case 103: {
            SKHomepageViewController *controller =  [[SKHomepageViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
            break;
        }
        default:
            break;
    }
}

- (void)loginWithUser:(SSDKUser *)user type:(NSString*)type{
        SKLoginUser *use = [SKLoginUser new];
        use.open_id = user.uid;
        use.nickname = user.nickname;
        use.avatar = user.icon;
        use.login_type = type;
    
        [[[SKServiceManager sharedInstance] loginService] loginWithThirdPlatform:use callback:^(BOOL success, SKResponsePackage *response) {
            DLog(@"%@", response.data);
            [[[SKServiceManager sharedInstance] profileService] getUserInfoWithCallback:^(BOOL success, SKUserInfo *userInfo) { }];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
}
@end
