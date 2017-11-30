//
//  SKProfileService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileService.h"

@implementation SKProfileService

- (void)profileBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	[manager setSecurityPolicy:[CustomSecurityPolicy customSecurityPolicy]];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];

	NSTimeInterval time = [[NSDate date] timeIntervalSince1970]; // (NSTimeInterval) time = 1427189152.313643
	long long int currentTime = (long long int)time;	     //NSTimeInterval返回的是double类型
	NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
	[mDict setValue:[NSString stringWithFormat:@"%lld", currentTime] forKey:@"time"];
	[mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
	[mDict setValue:@"iOS" forKey:@"client"];
	[mDict setValue:[[SKStorageManager sharedInstance] getUserID] forKey:@"user_id"];

	NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	NSDictionary *param = @{ @"data": [NSString encryptUseDES:jsonString key:nil] };

	[manager POST:[SKCGIManager profileBaseCGIKey]
		parameters:param
		progress:nil
		success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
		    SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
		    if (package.errcode == 0) {
			    callback(YES, package);
		    } else {
			    callback(YES, package);
			    DLog(@"%ld", (long)package.errcode);
		    }

		}
		failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
		    DLog(@"%@", error);
		    callback(NO, nil);
		}];
}

@end
