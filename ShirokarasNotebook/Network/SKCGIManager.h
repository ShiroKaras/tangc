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

+ (NSString *)commonBaseCGIKey;

#pragma mark -

//第三方登录
+ (NSString *)login_thirdLogin;

//首页热门
+ (NSString *)indexHot;

//首页关注
+ (NSString *)indexFollow;

//首页话题
+ (NSString *)indexTopic;

//首页轮询图
+ (NSString *)indexStartInfo;

//话题列表
+ (NSString *)topicList;

//关注列表
+ (NSString *)comuserFollows;

//粉丝列表
+ (NSString *)comuserFans;

//关注一个用户
+ (NSString *)doFollow;

//取关一个用户
+ (NSString *)unFollow;

//评论列表
+ (NSString *)getCommentList;

//点赞列表
+ (NSString *)getThumbList;

//发布评论
+ (NSString *)postComment;

//发布文章
+ (NSString *)postArticle;

//删除文章
+ (NSString *)deleteArticle;

//电脑发文登录
+ (NSString *)postLogin;

//获取文章详情
+ (NSString *)getArticleDetail;

//点赞
+ (NSString *)postThumbUp;

//获取用户信息
+ (NSString *)getUserInfo;

//修改资料
+ (NSString *)updateUserInfo;

//礼券列表
+ (NSString *)ticketsList;

//点击礼券计数
+ (NSString *)ticketsListClick;

//商品列表
+ (NSString *)goodsList;

//点击商品计数
+ (NSString *)goodsListClick;

//系统推送列表
+ (NSString *)queueList;

//我的图片列表
+ (NSString *)pictureList;

//我的文章列表
+ (NSString *)articleList;

//绑定CID
+ (NSString *)bindCid;
@end
