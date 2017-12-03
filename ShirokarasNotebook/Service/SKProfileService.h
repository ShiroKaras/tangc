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

- (void)comuserFollowsWithCallback:(SKUserListCallback)callback;
- (void)updateUserInfoWithUserInfo:(SKUserInfo*)userInfo callback:(SKResponseCallback)callback;

@end
