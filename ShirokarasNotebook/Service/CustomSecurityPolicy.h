//
//  CustomSecurityPolicy.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/23.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface CustomSecurityPolicy : NSObject

+ (AFSecurityPolicy *)customSecurityPolicy;

@end
