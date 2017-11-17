//
//  SKSegmentView.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKSegmentView : UIView

@property (nonatomic, strong) UIView *markLine;

- (instancetype)initWithFrame:(CGRect)frame titleNameArray:(NSArray<NSString*>*)titleArray;

@end
