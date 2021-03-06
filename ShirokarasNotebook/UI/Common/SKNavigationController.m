//
//  SKHTNavigationController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/10.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKNavigationController.h"
#import "SKUserInfoViewController.h"
#import "HXDatePhotoViewController.h"
#import "SKHomepageMorePicDetailViewController.h"
#import "SKPublishNewContentViewController.h"
#import "SKUserListViewController.h"
#import "SKAboutViewController.h"
#import "SKFollowListTableViewController.h"
#import "SKTopicListTableViewController.h"

@interface SKNavigationController ()

@end

@implementation SKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromColor:COMMON_BG_COLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    //设置成绿色
    statusBarView.backgroundColor = [UIColor greenColor];
    // 添加到 navigationBar 上
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"btn_detailpage_back_white"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1
        &&![viewController isKindOfClass:[HXDatePhotoViewController class]]) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.tag = 9001;
        if ([viewController isKindOfClass:[SKUserInfoViewController class]] ||
            [viewController isKindOfClass:[SKHomepageMorePicDetailViewController class]] ||
            [viewController isKindOfClass:[SKPublishNewContentViewController class]] ||
            [viewController isKindOfClass:[SKUserListViewController class]] ||
            [viewController isKindOfClass:[SKAboutViewController class]] ||
            [viewController isKindOfClass:[SKFollowListTableViewController class]] ||
            [viewController isKindOfClass:[SKTopicListTableViewController class]]
            ) {
            [_backButton setImage:[UIImage imageNamed:@"btn_detailpage_back"] forState:UIControlStateNormal];
            [_backButton setImage:[UIImage imageNamed:@"btn_detailpage_back_white"] forState:UIControlStateHighlighted];
        } else {
            [_backButton setImage:[UIImage imageNamed:@"btn_detailpage_back_white"] forState:UIControlStateNormal];
            [_backButton setImage:[UIImage imageNamed:@"btn_detailpage_back"] forState:UIControlStateHighlighted];
        }
        [_backButton sizeToFit];
        _backButton.top += kDevice_Is_iPhoneX? (44+ROUND_WIDTH_FLOAT(12)):(20+ROUND_WIDTH_FLOAT(12));
        _backButton.left += 15;
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        //        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [viewController.view addSubview:_backButton];
    }
}

- (void)back {
    [self popViewControllerAnimated:YES];
}
@end
