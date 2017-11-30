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

- (void)loginBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager setSecurityPolicy:[CustomSecurityPolicy customSecurityPolicy]];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:@"ios" forKey:@"device_type"];
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]; // (NSTimeInterval) time = 1427189152.313643
//    long long int currentTime = (long long int)time;         //NSTimeInterval返回的是double类型
//    [mDict setValue:[NSString stringWithFormat:@"%lld", currentTime] forKey:@"time"];
//    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];

//    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    DLog(@"Json ParamString: %@", jsonString);
//
//    NSDictionary *param = @{ @"data": [NSString encryptUseDES:jsonString key:nil] };

	[manager POST:[SKCGIManager login_thirdLogin]
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
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
