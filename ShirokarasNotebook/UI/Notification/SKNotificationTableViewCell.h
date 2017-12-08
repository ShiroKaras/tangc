//
//  SKNotificationTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKNotificationTableViewCell : UITableViewCell
@property (nonatomic, strong) SKNotification *notificationItem;
@property (nonatomic, assign) float cellHeight;

@end
