//
//  SKUserListTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SKUserListType) {
    SKUserListTypeFollow = 1,
    SKUserListTypeFans
};

@interface SKUserListTableViewCell : UITableViewCell
@property (nonatomic, assign) SKUserListType type;
@property (nonatomic, strong) SKUserInfo *userInfo;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, assign) float cellHeight;

- (void)setUserInfo:(SKUserInfo *)userInfo wityType:(SKUserListType)type;

@end
