//
//  SKCommonViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "UIViewController+SKTips.h"
#import "SKLoginRootViewController.h"

@implementation UIViewController (SKTips)

- (void)invokeLoginViewController {
    NSLog(@"调用登录页面");
    if ([SKStorageManager sharedInstance].loginUser.uuid) {
        return;
    }
    SKLoginRootViewController *controller = [SKLoginRootViewController new];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

@end
