//
//  SKLoginService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLoginService.h"
#import "SKModel.h"
#import "SKStorageManager.h"

@implementation SKLoginService

- (void)baseRequestWithParam:(NSDictionary *)dict url:(NSString *)url callback:(SKResponseCallback)callback {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager setSecurityPolicy:[CustomSecurityPolicy customSecurityPolicy]];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:@"ios" forKey:@"device_type"];

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

//第三方登录
- (void)loginWithThirdPlatform:(SKLoginUser *)user callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"open_id"  :  user.open_id,
                            @"login_type"   : user.plant_type,
                            @"nickname" : user.user_name,
                            @"avatar"   : user.user_avatar
                            };
    [self baseRequestWithParam:param url:[SKCGIManager login_thirdLogin] callback:^(BOOL success, SKResponsePackage *response) {
        SKUserInfo *userInfo = [SKUserInfo mj_objectWithKeyValues:response.data];
        [[SKStorageManager sharedInstance] setUserInfo:userInfo];
        callback(success, response);
    }];
}

@end
