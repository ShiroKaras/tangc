//
//  SKFollowListTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKFollowListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, assign) BOOL isCheck;
@end
