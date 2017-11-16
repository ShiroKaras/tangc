//
//  CommonDefine.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/7.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

#define IS_LANDSCAPE UIDeviceOrientationIsLandscape((UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation)
#define SCREEN_WIDTH (IOS_VERSION >= 8.0 ? [[UIScreen mainScreen] bounds].size.width : (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width))
#define SCREEN_HEIGHT (IOS_VERSION >= 8.0 ? [[UIScreen mainScreen] bounds].size.height : (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height))
#define SCREEN_BOUNDS (CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IPHONE6_PLUS_SCREEN_WIDTH 414
#define IPHONE6_SCREEN_WIDTH 375
#define IPHONE5_SCREEN_WIDTH 320
#define IPHONE4_SCREEN_HEIGHT 480

#define UIColorMake(r, g, b) [[UIColor alloc] initWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

//Image
#define ResourcePath(path)  [[NSBundle mainBundle] pathForResource:path ofType:nil]
#define ImageWithPath(path) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], path]]

//Masonry
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

// 布局换算比例
#define ROUND_WIDTH(w) @(((w) / 320.0) * SCREEN_WIDTH)
#define ROUND_HEIGHT(h) @(((h) / 568.0) * SCREEN_HEIGHT)

#define ROUND_WIDTH_FLOAT(w) ((w) / 320.0) * SCREEN_WIDTH
#define ROUND_HEIGHT_FLOAT(h) ((h) / 568.0) * SCREEN_HEIGHT

//#define ARTICLE_URL_STRING @"http://101.201.39.169:8001/views/article.html"
//#define ANSWER_URL_STRING @"http://101.201.39.169:8001/views/answer.html"

#define MOON_FONT_OF_SIZE(s) [UIFont fontWithName:@"Moon-Bold" size:s]
#define PINGFANG_FONT_OF_SIZE(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]
#define PINGFANG_ROUND_FONT_OF_SIZE(s) [UIFont fontWithName:@"PingFangSC-Regular" size:ROUND_WIDTH_FLOAT(s)]

#define COMMON_GREEN_COLOR [UIColor colorWithHex:0x24ddb2]
#define COMMON_PINK_COLOR [UIColor colorWithHex:0xd40e88]
#define COMMON_RED_COLOR [UIColor colorWithHex:0xed203b]

#define COMMON_SELECTED_COLOR [UIColor colorWithHex:0x505050]
#define COMMON_SEPARATOR_COLOR [UIColor colorWithHex:0xE6E6E6]

#define COMMON_BG_COLOR [UIColor colorWithHex:0xF0F4F8]
#define COMMON_TITLE_BG_COLOR [UIColor colorWithHex:0x1F1F1F]

#define COMMON_TEXT_COLOR   [UIColor colorWithHex:0x1F4035]
#define COMMON_TEXT_PLACEHOLDER_COLOR [UIColor colorWithHex:0xBCCCC7]

#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"img_mascot_article_list_cover_default"]

#define KEYWINDS_ROOT_CONTROLLER [[[[UIApplication sharedApplication] delegate] window] rootViewController]
#define KEY_WINDOW [[[UIApplication sharedApplication] delegate] window]
#define APPLICATION_DELEGATE [[UIApplication sharedApplication] delegate]
#define AppDelegateInstance ((AppDelegate *)([UIApplication sharedApplication].delegate))

#define NO_NETWORK ([[AFNetworkReachabilityManager sharedManager] isReachable] == NO)

#define UIViewParentController(__view) ({                  \
UIResponder *__responder = __view;                 \
while ([__responder isKindOfClass:[UIView class]]) \
__responder = [__responder nextResponder]; \
(UIViewController *)__responder;                   \
})

#define UD [NSUserDefaults standardUserDefaults]

#endif /* CommonDefine_h */
