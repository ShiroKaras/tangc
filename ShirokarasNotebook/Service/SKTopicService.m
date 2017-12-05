//
//  SKTopicService.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/30.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTopicService.h"
#import "SKModel.h"
#import "SKStorageManager.h"

@implementation SKTopicService

- (void)baseRequestWithParam:(NSDictionary *)dict url:(NSString *)url callback:(SKResponseCallback)callback {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    [manager setSecurityPolicy:[CustomSecurityPolicy customSecurityPolicy]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[SKStorageManager sharedInstance].userInfo.uuid forKey:@"uuid"];
    
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


- (void)getIndexFollowListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback {
    [self baseRequestWithParam:nil url:[SKCGIManager indexFollow] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKTopic*>*list = [NSMutableArray array];
        for (int i = 0; i < [response.data[@"lists"] count]; i++) {
            SKTopic *item = [SKTopic mj_objectWithKeyValues:response.data[@"lists"][i]];
            [list addObject:item];
        }
        callback(success, list);
    }];
}

- (void)getIndexHotListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback {
    NSDictionary *param = @{
                            @"page" : @(page),
                            @"pagesize" : @(pagesize)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager indexHot] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKTopic*>*list = [NSMutableArray array];
        for (int i = 0; i < [response.data[@"lists"] count]; i++) {
            SKTopic *item = [SKTopic mj_objectWithKeyValues:response.data[@"lists"][i]];
            [list addObject:item];
        }
        callback(success, list);
    }];
}

- (void)getIndexTopicListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback {
    NSDictionary *param = @{
                            @"page" : @(page),
                            @"pagesize" : @(pagesize)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager indexTopic] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKTopic*>*list = [NSMutableArray array];
        for (int i = 0; i < [response.data[@"lists"] count]; i++) {
            SKTopic *item = [SKTopic mj_objectWithKeyValues:response.data[@"lists"][i]];
            [list addObject:item];
        }
        callback(success, list);
    }];
}

//话题标签列表
- (void)getTopicNameListWithCallback:(SKTopicListCallback)callback {
    [self baseRequestWithParam:nil url:[SKCGIManager topicList] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKTopic*>*list = [NSMutableArray array];
        for (int i = 0; i < [response.data[@"lists"] count]; i++) {
            SKTopic *item = [SKTopic mj_objectWithKeyValues:response.data[@"lists"][i]];
            [list addObject:item];
        }
        callback(success, list);
    }];
}


- (void)postThumbUpWithArticleID:(NSInteger)articleID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"article_id" : @(articleID)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager postThumbUp] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)getArticleDetailWithArticleID:(NSInteger)articleID callback:(SKTopicCallback)callback {
    
}

- (void)postArticleWith:(SKUserPost *)topic callback:(SKResponseCallback)callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                 @"title" : topic.title,
                                                                                 @"content" : topic.content,
                                                                                 @"type" : @(topic.type)
                                                                                 }];
    [param setObject:topic.images forKey:@"images"];
    [param setObject:topic.tags forKey:@"tags"];
    [param setObject:topic.follows forKey:@"follows"];
    [self baseRequestWithParam:param url:[SKCGIManager postArticle] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)getCommentListWithArticleID:(NSInteger)articleID page:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKCommentListCallback)callback {
    NSDictionary *param = @{
                            @"article_id" : @(articleID),
                            @"page" : @(page),
                            @"pagesize" : @(pagesize)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager getCommentList] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKComment*>*list = [NSMutableArray array];
        for (int i = 0; i < [response.data[@"lists"] count]; i++) {
            SKComment *item = [SKComment mj_objectWithKeyValues:response.data[@"lists"][i]];
            [list addObject:item];
        }
        callback(success, list);
    }];
}

- (void)postCommentWithComment:(SKComment *)comment callback:(SKResponseCallback)callback {
    
}

@end
