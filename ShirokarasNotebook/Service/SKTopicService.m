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
    [mDict setValue:[SKStorageManager sharedInstance].loginUser.uuid forKey:@"uuid"];
    
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
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKTopic *item = [SKTopic mj_objectWithKeyValues:response.data[@"lists"][i]];
                [list addObject:item];
            }
            callback(success, list, [response.data[@"totalPage"] integerValue]);
        } else {
            callback(success, list, [response.data[@"totalPage"] integerValue]);
        }
    }];
}

- (void)getIndexHotListWithPageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback {
    NSDictionary *param = @{
                            @"page" : @(page),
                            @"pagesize" : @(pagesize)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager indexHot] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKTopic*>*list = [NSMutableArray array];
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKTopic *item = [SKTopic mj_objectWithKeyValues:response.data[@"lists"][i]];
                [list addObject:item];
            }
            callback(success, list, [response.data[@"totalPage"] integerValue]);
        } else {
            callback(success, list, [response.data[@"totalPage"] integerValue]);
        }
    }];
}

- (void)getIndexTopicListWithTopicID:(NSInteger)topic_id PageIndex:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTopicListCallback)callback {
//    if ([SKStorageManager sharedInstance].userInfo.uuid==nil||[[SKStorageManager sharedInstance].userInfo.uuid isEqualToString:@""]) {
//        NSMutableArray<SKTopic*>*list = [NSMutableArray array];
//        callback(NO, list);
//    }
    NSDictionary *param = @{
                            @"page" : @(page),
                            @"pagesize" : @(pagesize)
                            };
    NSMutableDictionary *param_new = [NSMutableDictionary dictionaryWithDictionary:param];
    [param_new setValue:@(topic_id) forKey:@"topic_id"];
    
    [self baseRequestWithParam:param_new url:[SKCGIManager indexTopic] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKTopic*>*list = [NSMutableArray array];
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKTopic *item = [SKTopic mj_objectWithKeyValues:response.data[@"lists"][i]];
                [list addObject:item];
            }
            callback(success, list, [response.data[@"totalPage"] integerValue]);
        } else {
            callback(success, list, [response.data[@"totalPage"] integerValue]);
        }
    }];
}

- (void)getIndexHeaderImagesArrayWithCallback:(SKResponseCallback)callback {
    [self baseRequestWithParam:nil url:[SKCGIManager indexStartInfo] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//话题标签列表
- (void)getTopicNameListWithCallback:(SKTagListCallback)callback {
    [self baseRequestWithParam:nil url:[SKCGIManager topicList] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKTag*>*list = [NSMutableArray array];
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKTag *item = [SKTag mj_objectWithKeyValues:response.data[@"lists"][i]];
                [list addObject:item];
            }
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
    NSDictionary *param = @{
                            @"article_id" : @(articleID)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager getArticleDetail] callback:^(BOOL success, SKResponsePackage *response) {
        if (success) {
            SKTopic *topic = [SKTopic mj_objectWithKeyValues:response.data];
            callback(success, topic);
        } else {
            callback(success, nil);
        }
    }];
}

- (void)postArticleWith:(SKUserPost *)topic callback:(SKResponseCallback)callback {
    NSMutableDictionary *param = [topic mj_keyValues];
    NSData *data = [NSJSONSerialization dataWithJSONObject:topic.images options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [param setValue:jsonString forKey:@"images"];
    if (topic.to_user_id!=nil) {
        NSData *data_users = [NSJSONSerialization dataWithJSONObject:topic.to_user_id options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString_users = [[NSString alloc] initWithData:data_users encoding:NSUTF8StringEncoding];
        [param setValue:jsonString_users forKey:@"to_user_id"];        
    }
    
    [self baseRequestWithParam:param url:[SKCGIManager postArticle] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)postLoginWithToken:(NSString *)token callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"token_verify" :token
                            };
    [self baseRequestWithParam:param url:[SKCGIManager postLogin] callback:^(BOOL success, SKResponsePackage *response) {
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
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKComment *item = [SKComment mj_objectWithKeyValues:response.data[@"lists"][i]];
                [list addObject:item];
            }
        }
        callback(success, list, [response.data[@"totalPage"] integerValue]);
    }];
}

- (void)postCommentWithComment:(SKComment *)comment callback:(SKResponseCallback)callback {
    NSDictionary *param = [comment mj_keyValues];
//    NSData *data_users = [NSJSONSerialization dataWithJSONObject:comment.to_comuser_id options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString_users = [[NSString alloc] initWithData:data_users encoding:NSUTF8StringEncoding];
//    [param setValue:jsonString_users forKey:@"to_comuser_id"];
    
    [self baseRequestWithParam:param url:[SKCGIManager postComment] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)deleteArticleWithArticleID:(NSInteger)aid callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"article_id" : @(aid),
                            };
    [self baseRequestWithParam:param url:[SKCGIManager deleteArticle] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
