//
//  SKCGIManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServerConfiguration.h"

@interface SKCGIManager : NSObject

+ (NSString *)loginBaseCGIKey;

+ (NSString *)profileBaseCGIKey;

+ (NSString *)commonBaseCGIKey;

+ (NSString *)shareBaseCGIKey;

#pragma mark -

//第三方登录
+ (NSString *)login_thirdLogin;

//话题列表
+ (NSString *)topicList;

//关注用户
+ (NSString *)comuserFollows;

//发布文章
+ (NSString *)postArticle;

@end
