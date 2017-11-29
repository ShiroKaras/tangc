//
//  SKProfileService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

typedef void (^SKProfileInfoCallback) (BOOL success, SKProfileInfo *response);
typedef void (^SKUserInfoCallback) (BOOL success, SKUserInfo *response);

@interface SKProfileService : NSObject

@end
