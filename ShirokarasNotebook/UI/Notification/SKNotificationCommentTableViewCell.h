//
//  SKNotificationCommentTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKNotificationCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) SKNotification *notificationItem;
@property (nonatomic, assign) float cellHeight;
@end
