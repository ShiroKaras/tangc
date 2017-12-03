//
//  SKCGIManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCGIManager.h"

@implementation SKCGIManager

+ (NSString *)loginBaseCGIKey {
	return [NSString stringWithFormat:@"%@/api", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)profileBaseCGIKey {
	return [NSString stringWithFormat:@"%@/ArtUser/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)commonBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Common/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)shareBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Share/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

#pragma mark -

+ (NSString *)login_thirdLogin {
    return [NSString stringWithFormat:@"%@/api/third_login", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)indexHot {
    return [NSString stringWithFormat:@"%@/api/index/hot", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)indexFollow {
    return [NSString stringWithFormat:@"%@/api/index/follow", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)indexTopic {
    return [NSString stringWithFormat:@"%@/api/index/topic", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)topicList {
    return [NSString stringWithFormat:@"%@/api/topic/list", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)comuserFollows {
    return [NSString stringWithFormat:@"%@/api/comuser/follows", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)postArticle {
    return [NSString stringWithFormat:@"%@/api/article/add", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)postThumbUp {
    return [NSString stringWithFormat:@"%@/api/article/thumb_up", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)updateUserInfo {
    return [NSString stringWithFormat:@"%@/api/update_profile", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)ticketsList {
    return [NSString stringWithFormat:@"%@/api/shop/coupons", [[ServerConfiguration sharedInstance] appHost]];
}
@end
