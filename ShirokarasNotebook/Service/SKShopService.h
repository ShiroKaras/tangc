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

typedef void (^SKTicketsListCallback)(BOOL success, NSArray<SKTickets*>* topicList);

@interface SKShopService : NSObject

- (void)getTicketsListWithPage:(NSInteger)page pagesize:(NSInteger)pagesize callback:(SKTicketsListCallback)callback;

@end
