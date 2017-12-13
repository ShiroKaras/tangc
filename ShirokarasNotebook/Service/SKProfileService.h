//
//  SKProfileService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

typedef void (^SKUserListCallback)(BOOL success, NSArray<SKUserInfo*>* userList);
typedef void (^SKQueueListCallback)(BOOL success, NSArray<SKNotification*>* queueList);
typedef void (^SKUserInfoCallback)(BOOL success, SKUserInfo *userInfo);
typedef void (^SKPictureCallback)(BOOL success, NSArray<SKPicture*> *picList);

@interface SKProfileService : NSObject

//获取关注列表
- (void)comuserFollowsWithCallback:(SKUserListCallback)callback;

//获取粉丝列表
- (void)comuserFansWithCallback:(SKUserListCallback)callback;

//关注一个用户
- (void)doFollowsUserID:(NSString *)uid callback:(SKResponseCallback)callback;

//取关一个用户
- (void)unFollowsUserID:(NSString *)uid callback:(SKResponseCallback)callback;

//获取用户信息
- (void)getUserInfoWithCallback:(SKUserInfoCallback)callback;

//修改用户信息
- (void)updateUserInfoWithUserInfo:(SKUserInfo*)userInfo callback:(SKResponseCallback)callback;

//系统推送通知列表
- (void)getUserQueueListWithType:(NSInteger)type callback:(SKQueueListCallback)callback;

//图片列表
- (void)getPicListWithPage:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKPictureCallback)callback;

@end
