//
//  SKServiceManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKServiceManager.h"

@implementation SKServiceManager {
    SKLoginService      *_loginService;
    SKTopicService      *_topicService;
    SKProfileService    *_profileService;
    SKCommonService     *_commonService;
    SKShopService       *_shopService;
    QNUploadManager     *_qiniuService;
}

+ (instancetype)sharedInstance {
    static SKServiceManager *serviceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[SKServiceManager alloc] init];
    });
    return serviceManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _loginService       = [[SKLoginService alloc] init];
        _topicService       = [[SKTopicService alloc] init];
        _profileService     = [[SKProfileService alloc] init];
        _commonService      = [[SKCommonService alloc] init];
        _shopService        = [[SKShopService alloc] init];
        _qiniuService       = [[QNUploadManager alloc] init];
    }
    return self;
}

#pragma mark - Publice Method

- (SKLoginService *)loginService {
    return _loginService;
}

- (SKTopicService *)topicService {
    return _topicService;
}

- (SKProfileService *)profileService {
    return _profileService;
}

- (SKCommonService *)commonService {
    return _commonService;
}

- (SKShopService *)shopService {
    return _shopService;
}

- (QNUploadManager *)qiniuService {
    return _qiniuService;
}
@end
