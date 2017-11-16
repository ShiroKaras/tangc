//
//  SKLog.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/13.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#ifndef SKLog_h
#define SKLog_h

#import <Foundation/Foundation.h>

#import <asl.h>

#define THIS_FILE [(@"" __FILE__) lastPathComponent]

////Do-while?
////https://stackoverflow.com/questions/1067226/c-multi-line-macro-do-while0-vs-scope-block
//
//#define _NSLog(fmt,...) {                                               \
//do                                                                      \
//    {                                                                   \
//    NSString *str = [NSString stringWithFormat:fmt, ##__VA_ARGS__];     \
//    printf("%s\n",[str UTF8String]);                                    \
//    asl_log(NULL, NULL, ASL_LEVEL_NOTICE, "%s", [str UTF8String]);      \
//    }                                                                   \
//    while (0);                                                          \
//}


//#define NSLog(fmt, ...) _NSLog((@"[%@] " fmt), THIS_APP, ##__VA_ARGS__)

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif /* SKLog_h */