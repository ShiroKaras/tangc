//
//  SKProfileService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileService.h"

@implementation SKProfileService

- (void)baseRequestWithParam:(NSDictionary *)dict url:(NSString *)url callback:(SKResponseCallback)callback {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    [manager setSecurityPolicy:[CustomSecurityPolicy customSecurityPolicy]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[SKStorageManager sharedInstance].userInfo.uuid forKey:@"uuid"];
    
    DLog(@"param:%@", mDict);
    [manager POST:url
       parameters:mDict
         progress:nil
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
              callback(YES, package);
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
              DLog(@"%@", error);
              callback(NO, nil);
          }];
}

//我的关注
- (void)comuserFollowsWithCallback:(SKUserListCallback)callback {
    [self baseRequestWithParam:nil url:[SKCGIManager comuserFollows] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKUserInfo*>*list = [NSMutableArray array];
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i <[response.data[@"lists"] count]; i++) {
                SKUserInfo *item = [SKUserInfo mj_objectWithKeyValues:response.data[@"lists"][i]];
                item.is_follow = YES;
                item.is_followed = item.is_concerned;
                [list addObject:item];
            }
        }
        callback(success, list);
    }];
}

- (void)comuserFansWithCallback:(SKUserListCallback)callback {
    [self baseRequestWithParam:nil url:[SKCGIManager comuserFans] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKUserInfo*>*list = [NSMutableArray array];
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKUserInfo *item = [SKUserInfo mj_objectWithKeyValues:response.data[@"lists"][i]];
                item.is_followed = YES;
                item.is_follow = item.is_concerned;
                [list addObject:item];
            }
        }
        callback(success, list);
    }];
}

- (void)doFollowsUserID:(NSString *)uid callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"toId" : uid
                            };
    [self baseRequestWithParam:param url:[SKCGIManager doFollow] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)unFollowsUserID:(NSString *)uid callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"toId" : uid
                            };
    [self baseRequestWithParam:param url:[SKCGIManager unFollow] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//修改用户信息
- (void)updateUserInfoWithUserInfo:(SKUserInfo *)userInfo callback:(SKResponseCallback)callback {
    NSMutableDictionary *param = [userInfo mj_keyValuesWithIgnoredKeys:@[@"id"]];
    [self baseRequestWithParam:param url:[SKCGIManager updateUserInfo] callback:^(BOOL success, SKResponsePackage *response) {
        SKUserInfo *userInfo = [SKUserInfo mj_objectWithKeyValues:response.data];
        [[SKStorageManager sharedInstance] setUserInfo:userInfo];
        callback(success, response);
    }];
}

- (void)getUserQueueListWithType:(NSInteger)type callback:(SKQueueListCallback)callback {
    NSDictionary *param = @{
                            @"type" : @(type)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager queueList] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKNotification*>*list = [NSMutableArray array];
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKNotification *item = [SKNotification mj_objectWithKeyValues:response.data[@"lists"][i]];
                [list addObject:item];
            }
        }
        callback(success, list);
    }];
}

@end
