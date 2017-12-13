//
//  SKModel.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKModel.h"
#import "MJExtension.h"

#define HTINIT(T)                                                                \
	-(instancetype)init {                                                    \
		if (self = [super init]) {                                       \
			[T mj_setupReplacedKeyFromPropertyName:^NSDictionary * { \
			    return [self propertyMapper];                        \
			}];                                                      \
		}                                                                \
		return self;                                                     \
	}

@implementation SKResponsePackage
HTINIT(SKResponsePackage)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{ @"code" : @"result.code",
                                      @"message" : @"result.message"
                                      };
    return propertyMapper;
}
@end

@implementation SKLoginUser
@end

@implementation SKUserInfo
@end

@implementation SKUserPost
@end

@implementation SKTopicFrom
-(instancetype)init {
    if (self = [super init]) {
        [SKTopicFrom mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"at_users" : @"SKUserInfo",
                     };
        }];
    }
    return self;
}
/* 转化过程中对字典的值进行过滤和进一步转化 */
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"images"]) {
        if ([oldValue isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:oldValue];
            for (int i=0; i<[array count]; i++) {
                if (![array[i] isKindOfClass:[NSString class]]) {
                    [array replaceObjectAtIndex:i withObject:@""];
                }
            }
            return array;
        } else
            return @[@""];
    }
    return oldValue;
}
@end

@implementation SKTopic
-(instancetype)init {
    if (self = [super init]) {
        [SKTopicFrom mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"at_users" : @"SKUserInfo",
                     };
        }];
    }
    return self;
}

/* 转化过程中对字典的值进行过滤和进一步转化 */
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"images"]) {
        if ([oldValue isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:oldValue];
            for (int i=0; i<[array count]; i++) {
                if (![array[i] isKindOfClass:[NSString class]]) {
                    [array replaceObjectAtIndex:i withObject:@""];
                }
            }
            return array;
        } else
            return @[@""];
    }
    return oldValue;
}
@end

@implementation SKTag
@end

@implementation SKArticle
@end

@implementation SKComment
@end

@implementation SKTicket
@end

@implementation SKGoods
@end

@implementation SKNotification
@end

@implementation SKPicture
@end
