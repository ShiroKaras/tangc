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

- (void)comuserFollowsWithCallback:(SKUserListCallback)callback {
    [self baseRequestWithParam:nil url:[SKCGIManager comuserFollows] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKUserInfo*>*list = [NSMutableArray array];
        for (int i = 0; i < [response.data count]; i++) {
            SKUserInfo *item = [SKUserInfo mj_objectWithKeyValues:response.data[i]];
            [list addObject:item];
        }
        callback(success, list);
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

@end
