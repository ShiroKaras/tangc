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
@property (nonatomic, copy) NSString *method;   // 方法名
@property (nonatomic, assign) NSInteger errcode; // 结果信息
@property (nonatomic, copy) NSString *errmsg; // 结果信息
@property (nonatomic, strong) id data;          // 返回数据
@end

//登录信息
@interface SKLoginUser : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *open_id;     // 第三方平台ID
@property (nonatomic, copy) NSString *plant_type;    // weibo | qq | weixin
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_avatar;
//@property (nonatomic, copy) NSString *user_password;
@end

//用户基本信息
@interface SKUserInfo : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *uuid;
@end

@interface SKTopic : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@end
