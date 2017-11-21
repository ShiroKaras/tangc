//
//  SKHTNavigationController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/10.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKNavigationController.h"

@interface SKNavigationController ()

@end

@implementation SKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromColor:COMMON_TITLE_BG_COLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
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
    
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 9001;
        [button setImage:[UIImage imageNamed:@"btn_detailpage_back_white"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_detailpage_back"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.top += 32;
        button.left += 15;
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        //        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [viewController.view addSubview:button];
    }
}

- (void)back {
    [self popViewControllerAnimated:YES];
}
@end
