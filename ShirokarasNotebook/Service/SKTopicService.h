//
//  SKTopicService.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/30.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLogicHeader.h"

//typedef void (^SKUserPostListCallback)(BOOL success, NSArray<SKTopic*>* topicList);
typedef void (^SKTopicListCallback)(BOOL success, NSArray<SKTopic*>* topicList);

@interface SKTopicService : NSObject

//首页
- (void)getIndexFollowListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback;
- (void)getIndexHotListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback;
- (void)getIndexTopicListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback;

//获取标签列表
- (void)getTopicNameListWithCallback:(SKTopicListCallback)callback;
//发文章
- (void)postArticleWith:(SKUserPost *)topic callback:(SKResponseCallback)callback;
//点赞
- (void)postThumbUpWithArticleID:(NSInteger)articleID callback:(SKResponseCallback)callback;
//文章详情
- (void)getArticleDetailWithArticleID:(NSInteger)articleID callback:(SKResponseCallback)callback;
//发送评论
- (void)postCommentWithComment:(SKComment*)comment callback:(SKResponseCallback)callback;
@end
