//
//  SKLoginRootViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/13.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKLoginRootViewController.h"
#import "SKHomepageViewController.h"

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
    
    __weak __typeof(self) weakSelf = self;
    
    //skip
    UIButton *button_skip = [UIButton new];
    [button_skip setTitle:@"跳过" forState:UIControlStateNormal];
    [button_skip setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button_skip.size = CGSizeMake(44, 44);
    button_skip.top = 20;
    button_skip.right = self.view.right -20;
    [self.view addSubview:button_skip];
    
    //login buttons
    UIButton *login_weibo = [UIButton new];
    [login_weibo setTitle:@"微博登录" forState:UIControlStateNormal];
    [login_weibo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login_weibo.backgroundColor = [UIColor darkGrayColor];
    login_weibo.layer.cornerRadius = ROUND_HEIGHT_FLOAT(25);
    login_weibo.width = ROUND_WIDTH_FLOAT(220);
    login_weibo.height = ROUND_HEIGHT_FLOAT(50);
    login_weibo.centerX = weakSelf.view.centerX;
    login_weibo.bottom = weakSelf.view.bottom - 60;
    [self.view addSubview:login_weibo];
    
    UIButton *login_qq = [UIButton new];
    [login_qq setTitle:@"QQ登录" forState:UIControlStateNormal];
    [login_qq setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    login_qq.width = ROUND_WIDTH_FLOAT(100);
    login_qq.height = ROUND_HEIGHT_FLOAT(20);
    login_qq.left = login_weibo.left;
    login_qq.top = login_weibo.bottom +20;
    [self.view addSubview:login_qq];
    
    UIButton *login_weixin = [UIButton new];
    [login_weixin setTitle:@"微信登录" forState:UIControlStateNormal];
    [login_weixin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    login_weixin.width = ROUND_WIDTH_FLOAT(100);
    login_weixin.height = ROUND_HEIGHT_FLOAT(20);
    login_weixin.left = login_qq.right+ROUND_WIDTH_FLOAT(20);
    login_weixin.top = login_weibo.bottom +20;
    [self.view addSubview:login_weixin];
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
                           
                           [self loginWithUser:user];
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
                           
                           [self loginWithUser:user];
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
                           
                           [self loginWithUser:user];
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

- (void)loginWithUser:(SSDKUser *)user {
    SKLoginUser *loginUser = [SKLoginUser new];
}
@end
