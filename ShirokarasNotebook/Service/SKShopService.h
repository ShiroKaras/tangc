//
//  SKShopService.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/3.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

typedef void (^SKTicketsListCallback)(BOOL success, NSArray<SKTicket*>* ticketsList);
typedef void (^SKGoodsListCallback)(BOOL success, NSArray<SKGoods*>* goodsList);

@interface SKShopService : NSObject

- (void)getTicketsListWithPage:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTicketsListCallback)callback;
- (void)getGoodsListWithPage:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKGoodsListCallback)callback;

- (void)didClickTicketCountWithID:(NSInteger)tid Callback:(SKResponseCallback)callback;
- (void)didClickGoodsCountWithID:(NSInteger)gid Callback:(SKResponseCallback)callback;

@end
