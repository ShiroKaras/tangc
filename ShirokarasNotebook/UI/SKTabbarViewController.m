//
//  SKTabbarViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/15.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTabbarViewController.h"
#import "SKHomepageViewController.h"
#import "SKShopViewController.h"
#import "SKPublishNewContentViewController.h"
#import "SKNotificationViewController.h"
#import "SKPersonalIndexViewController.h"
#import "SKPublishPreView.h"

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
    
    SKShopViewController *c2 = [[SKShopViewController alloc] init];
    c2.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c2.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_mall"];
    c2.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_mall_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *c3 = [UIViewController new];
//    c3.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
//    c3.tabBarItem.image = [UIImage imageNamed:@""];
//    c3.tabBarItem.selectedImage = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SKNotificationViewController *c4 = [[SKNotificationViewController alloc] init];
    c4.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c4.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_message"];
    c4.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_message_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SKPersonalIndexViewController *c5 = [[SKPersonalIndexViewController alloc] init];
    c5.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c5.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_me"];
    c5.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_me_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[c1, c2, c3, c4, c5];
    
    UIButton *addButton = [UIButton new];
    [addButton setImage:[UIImage imageNamed:@"btn_homepage_release"] forState:UIControlStateNormal];
    addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    addButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(60), 49);
    addButton.centerX = self.view.width/2;
    addButton.top = kDevice_Is_iPhoneX?(self.tabBar.top-34):(self.tabBar.top);
    [self.view addSubview:addButton];
    
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
        } else {
            SKPublishPreView *preView = [[SKPublishPreView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.view addSubview:preView];
            preView.alpha =0;
            [UIView animateWithDuration:0.2 animations:^{
                preView.alpha =1;
            }];
        }
    }];
    
    _redPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    _redPoint.backgroundColor = [UIColor redColor];
    _redPoint.layer.cornerRadius = 3;
    _redPoint.top = addButton.top+5;
    _redPoint.left = addButton.right+ROUND_WIDTH_FLOAT(44);
    [self.view addSubview:_redPoint];
    _redPoint.hidden = ![[UD valueForKey:@"isNewNotification"] boolValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
