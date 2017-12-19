//
//  SKTopicService.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/30.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLogicHeader.h"

typedef void (^SKTopicListCallback)(BOOL success, NSArray<SKTopic*>* topicList, NSInteger totalPage);
typedef void (^SKTagListCallback)(BOOL success, NSArray<SKTag*>* tagList);
typedef void (^SKCommentListCallback)(BOOL success, NSArray<SKComment*>* commentList, NSInteger totalPage);
typedef void (^SKThumbListCallback)(BOOL success, NSArray<SKUserInfo*>* list, NSInteger totalPage);

typedef void (^SKTopicCallback) (BOOL success, SKTopic *topic);

@interface SKTopicService : NSObject

//首页
- (void)getIndexFollowListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback;
- (void)getIndexHotListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback;
- (void)getIndexTopicListWithTopicID:(NSInteger)topic_id PageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback;
- (void)getIndexHeaderImagesArrayWithCallback:(SKResponseCallback)callback;

//获取标签列表
- (void)getTopicNameListWithCallback:(SKTagListCallback)callback;
//点赞
- (void)postThumbUpWithArticleID:(NSInteger)articleID callback:(SKResponseCallback)callback;
//获取文章详情
- (void)getArticleDetailWithArticleID:(NSInteger)articleID callback:(SKTopicCallback)callback;
//发文章
- (void)postArticleWith:(SKUserPost *)topic callback:(SKResponseCallback)callback;
//电脑发文登录
- (void)postLoginWithToken:(NSString*)token callback:(SKResponseCallback)callback;
//获取评论列表
- (void)getCommentListWithArticleID:(NSInteger)articleID page:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKCommentListCallback)callback;
//点赞列表
- (void)getThumbListWithArticleID:(NSInteger)articleID page:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKThumbListCallback)callback;
//发送评论
- (void)postCommentWithComment:(SKComment*)comment callback:(SKResponseCallback)callback;
//删除
- (void)deleteArticleWithArticleID:(NSInteger)aid callback:(SKResponseCallback)callback;
@end
