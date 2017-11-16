//
//  SKTabbarViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/15.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTabbarViewController.h"
#import "SKHomepageViewController.h"
@interface SKTabbarViewController ()

@end

@implementation SKTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHex:0x8196AB]];
    [UITabBar appearance].translucent = NO;
    
    SKHomepageViewController *c1 = [[SKHomepageViewController alloc] init];
    c1.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c1.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_task"];
    c1.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_task_highlight"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIViewController *c2 = [[UIViewController alloc] init];
    c2.view.backgroundColor = [UIColor redColor];
    c2.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c2.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_puzzle"];
    c2.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_puzzle_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *c3 = [[UIViewController alloc] init];
    c3.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c3.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_lingzai"];
    c3.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_lingzai_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *c4 = [[UIViewController alloc] init];
    c4.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c4.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_lab"];
    c4.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_lab_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
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
