//
//  SKNotificationBaseInfoTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKNotificationBaseInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *usernameAppendLabel;
@property (nonatomic, strong) SKNotification *notificationItem;
@property (nonatomic, assign) float cellHeight;
@end
