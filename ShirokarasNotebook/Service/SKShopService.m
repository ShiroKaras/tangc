//
//  SKShopService.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/3.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKShopService.h"

@implementation SKShopService

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

- (void)getTicketsListWithPage:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTicketsListCallback)callback {
    NSDictionary *param = @{
                            @"page" : @(page),
                            @"pagesize" : @(pagesize)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager ticketsList] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKTicket*>*list = [NSMutableArray array];
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKTicket *item = [SKTicket mj_objectWithKeyValues:response.data[@"lists"][i]];
                [list addObject:item];
            }
        }
        callback(success, list);
    }];
}

- (void)getGoodsListWithPage:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKGoodsListCallback)callback {
    NSDictionary *param = @{
                            @"page" : @(page),
                            @"pagesize" : @(pagesize)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager ticketsList] callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKGoods*>*list = [NSMutableArray array];
        if ([response.data isKindOfClass:[NSDictionary class]]) {
            for (int i = 0; i < [response.data[@"lists"] count]; i++) {
                SKGoods *item = [SKGoods mj_objectWithKeyValues:response.data[@"lists"][i]];
                [list addObject:item];
            }
        }
        callback(success, list);
    }];
}

- (void)didClickTicketCountWithID:(NSInteger)tid Callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"article_id" : @(tid)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager ticketsListClick] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)didClickGoodsCountWithID:(NSInteger)gid Callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"article_id" : @(gid)
                            };
    [self baseRequestWithParam:param url:[SKCGIManager goodsListClick] callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}


@end
