//
//  SKSegmentView.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKSegmentViewDelegate <NSObject>
- (void)segmentView:(UIView*)view didClickIndex:(NSInteger)index;
@end

@interface SKSegmentView : UIView
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, weak) id<SKSegmentViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame titleNameArray:(NSArray<NSString*>*)titleArray;
@end
