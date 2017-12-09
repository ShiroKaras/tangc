//
//  SKSegmentView.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKSegmentView;

@protocol SKSegmentViewDelegate <NSObject>
- (void)segmentView:(SKSegmentView *)view didClickIndex:(NSInteger)index;
@end

@interface SKSegmentView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, weak) id<SKSegmentViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame titleNameArray:(NSArray<NSString*>*)titleArray;
@end
