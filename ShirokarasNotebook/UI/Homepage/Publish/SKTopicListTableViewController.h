//
//  SKTopicListTableViewController.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKTopicListTableViewController;

@protocol SKTopicListTableViewControllerDelegate <NSObject>
- (void)didClickBackButtonInTopicListController:(SKTopicListTableViewController *)controller selectedArray:(NSArray*)array;
@end

@interface SKTopicListTableViewController : UIViewController
@property (nonatomic, assign) id<SKTopicListTableViewControllerDelegate> delegate;
@end
