//
//  SKTopicService.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/30.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLogicHeader.h"

typedef void (^SKTopicListCallback)(BOOL success, NSArray<SKTopic*>* topicList);

@interface SKTopicService : NSObject

- (void)getTopicListWithCallback:(SKTopicListCallback)callback;
- (void)comuserFollowsWithCallback:(SKResponseCallback)callback;

@end
