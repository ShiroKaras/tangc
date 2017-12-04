//
//  SKPublishNewContentViewController.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SKPublishType) {
    SKPublishTypeNew = 1,
    SKPublishTypeRepost,
};

@interface SKPublishNewContentViewController : UIViewController
- (instancetype)initWithType:(SKPublishType)type withUserPost:(SKTopic*)userpost;
@end
