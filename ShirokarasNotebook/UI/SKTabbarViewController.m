//
//  SKTabbarViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/15.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTabbarViewController.h"
#import "SKHomepageViewController.h"
#import "SKTopicsViewController.h"
#import "SKMarketViewController.h"
#import "SKNotificationViewController.h"

@interface SKTabbarViewController ()

@end

@implementation SKTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    SKHomepageViewController *c1 = [[SKHomepageViewController alloc] init];
    c1.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c1.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_home"];
    c1.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_home_highlight"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    SKTopicsViewController *c2 = [[SKTopicsViewController alloc] init];
    c2.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c2.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_mall"];
    c2.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_mall_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SKMarketViewController *c3 = [[SKMarketViewController alloc] init];
    c3.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c3.tabBarItem.image = [UIImage imageNamed:@""];
    c3.tabBarItem.selectedImage = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SKNotificationViewController *c4 = [[SKNotificationViewController alloc] init];
    c4.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c4.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_message"];
    c4.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_message_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *c5 = [[UIViewController alloc] init];
    c5.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c5.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_me"];
    c5.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_me_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SKNavigationController *controller = [[SKNavigationController alloc] initWithRootViewController:c5];
    
    self.viewControllers = @[c1, c2, c3, c4, controller];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end