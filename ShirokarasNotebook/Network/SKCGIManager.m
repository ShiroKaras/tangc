//
//  SKCGIManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCGIManager.h"

@implementation SKCGIManager

+ (NSString *)commonBaseCGIKey {
    return [NSString stringWithFormat:@"%@/Common/appIndex", @"http://112.74.133.183:8082"];
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

+ (NSString *)indexStartInfo {
    return [NSString stringWithFormat:@"%@/api/index/app_start_info", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)topicList {
    return [NSString stringWithFormat:@"%@/api/topic/list", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)getArticleDetail {
    return [NSString stringWithFormat:@"%@/api/article/article_details", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)comuserFollows {
    return [NSString stringWithFormat:@"%@/api/comuser/follows", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)comuserFans {
    return [NSString stringWithFormat:@"%@/api/comuser/rev_follows", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)doFollow {
    return [NSString stringWithFormat:@"%@/api/comuser/do_follows", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)unFollow {
    return [NSString stringWithFormat:@"%@/api/comuser/un_follows", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)getCommentList {
    return [NSString stringWithFormat:@"%@/api/comment/article_comments", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)postComment {
    return [NSString stringWithFormat:@"%@/api/comment/post_comment", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)postArticle {
    return [NSString stringWithFormat:@"%@/api/article/add", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)postLogin {
    return [NSString stringWithFormat:@"%@/api/post_login", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)postThumbUp {
    return [NSString stringWithFormat:@"%@/api/article/thumb_up", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)getUserInfo {
    return [NSString stringWithFormat:@"%@/api/my/profile", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)updateUserInfo {
    return [NSString stringWithFormat:@"%@/api/update_profile", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)ticketsList {
    return [NSString stringWithFormat:@"%@/api/shop/coupons", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)ticketsListClick {
    return [NSString stringWithFormat:@"%@/api/coupon/click", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)goodsList {
    return [NSString stringWithFormat:@"%@/api/shop/goods", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)goodsListClick {
    return [NSString stringWithFormat:@"%@/api/good/click", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)queueList {
    return [NSString stringWithFormat:@"%@/api/queue/list", [[ServerConfiguration sharedInstance] appHost]];
}

@end
