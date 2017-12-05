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

typedef void (^SKUserListCallback)(BOOL success, NSArray<SKUserInfo*>* topicList);

@interface SKProfileService : NSObject

//获取关注列表
- (void)comuserFollowsWithCallback:(SKUserListCallback)callback;

//获取粉丝列表
- (void)comuserFansWithCallback:(SKUserListCallback)callback;

//关注一个用户
- (void)doFollowsUserID:(NSString *)uid callback:(SKResponseCallback)callback;

//取关一个用户
- (void)unFollowsUserID:(NSString *)uid callback:(SKResponseCallback)callback;

//更新用户信息
- (void)updateUserInfoWithUserInfo:(SKUserInfo*)userInfo callback:(SKResponseCallback)callback;

@end
