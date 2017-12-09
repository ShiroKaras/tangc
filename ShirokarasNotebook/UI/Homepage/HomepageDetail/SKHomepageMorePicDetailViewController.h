//
//  SKHomepageMorePicDetailViewController.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/14.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SKHomepageDetailType) {
    SKHomepageDetailTypeOnePic = 1,
    SKHomepageDetailTypeMorePic,
    SKHomepageDetailTypeArticle,
};

@interface SKHomepageMorePicDetailViewController : UIViewController

- (instancetype)initWithTopic:(SKTopic*)topic;

@end
