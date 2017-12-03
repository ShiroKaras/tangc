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

- (void)getTopicNameListWithCallback:(SKTopicListCallback)callback;
- (void)postArticleWith:(SKUserPost *)topic callback:(SKResponseCallback)callback;
- (void)postThumbUpWithArticleID:(NSInteger)articleID callback:(SKResponseCallback)callback;
@end
