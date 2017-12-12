//
//  SKFollowListTableViewController.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKFollowListTableViewController;

@protocol SKFollowListTableViewControllerDelegate <NSObject>
- (void)didClickBackButtonInFollowListController:(SKFollowListTableViewController *)controller selectedArray:(NSArray*)array;
@end

@interface SKFollowListTableViewController : UIViewController
@property (nonatomic, assign) id<SKFollowListTableViewControllerDelegate> delegate;
@end
