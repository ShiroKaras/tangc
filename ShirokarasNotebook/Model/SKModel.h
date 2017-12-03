//
//  SKModel.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "MJExtension.h"
#import <Foundation/Foundation.h>

@interface SKResult : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@end

// 基本返回包
@interface SKResponsePackage : NSObject
@property (nonatomic, assign) NSInteger errcode; // 结果信息
@property (nonatomic, copy) NSString *errmsg; // 结果信息
@property (nonatomic, strong) id data;          // 返回数据
@end

//登录信息
@interface SKLoginUser : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *open_id;      // 第三方平台ID
@property (nonatomic, copy) NSString *login_type;   // weibo | qq | weixin
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@end

//用户基本信息
@interface SKUserInfo : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *qq;
@end

//用户发送的信息
@interface SKUserPost : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger type;       //1:单图图文 2：多图图文 3：文章
@property (nonatomic, copy) NSString *parent_id;    //转发的原始文章ID
@property (nonatomic, strong) NSArray *images;      //图片地址
@property (nonatomic, strong) NSArray *tags;        //tags
@property (nonatomic, strong) NSArray *follows;     //关注的用户ID组成
@end

//内容Item
@interface SKTopic : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *comuser_id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *comment_num;
@property (nonatomic, copy) NSString *transmit_num;
@property (nonatomic, copy) NSString *thumb_num;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, assign) NSInteger is_follow;
@property (nonatomic, assign) NSInteger is_thumb;
@property (nonatomic, strong) SKUserInfo *userinfo;
@end

