//
//  SKSegmentView.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKSegmentView.h"

#define PADDING 15

@interface SKSegmentView () {
    NSArray *_titleArray;
    NSMutableArray *_cXdistanceArray;
}
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation SKSegmentView

- (instancetype)initWithFrame:(CGRect)frame titleNameArray:(NSArray<NSString*>*)titleArray {
    self = [super initWithFrame:frame];
    _titleArray = titleArray;
    _cXdistanceArray = [NSMutableArray array];
    if (self) {
        for (int i=0; i<titleArray.count; i++) {
            UIButton *button = [UIButton new];
            button.tag = 100+i;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
            button.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
            button.width = (frame.size.width-PADDING*2)/titleArray.count;
            button.height = frame.size.height;
            button.left = PADDING+button.width*i;
            button.top = 0;
            [self addSubview:button];
            float cXdistance = self.width/2- button.centerX;
            NSLog(@"cXdistance: %lf", cXdistance);
            [_cXdistanceArray addObject:@(cXdistance)];
        }
        _markLine = [UIView new];
        _markLine.backgroundColor = [UIColor colorWithHex:0x37ECBA];
        _markLine.size = CGSizeMake(ROUND_WIDTH_FLOAT(20), 2);
        _markLine.bottom = frame.size.height;
        _markLine.centerX = [self viewWithTag:100].centerX;
        [self addSubview:_markLine];
        [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        self.selectedIndex = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [UIView animateWithDuration:0.2 animations:^{
        for (int i=0; i<_titleArray.count; i++){
            [self viewWithTag:100+i].centerX = self.width/2 - [_cXdistanceArray[i] floatValue];
            [self viewWithTag:100+i].bottom = self.height;
        }
        _markLine.centerX = [self viewWithTag:100+self.selectedIndex].centerX;
        _markLine.bottom = self.height;
    }];
}

- (void)didClickButton:(UIButton*)sender {
    self.selectedIndex = sender.tag-100;
    if ([self.delegate respondsToSelector:@selector(segmentView:didClickIndex:)]) {
        [self.delegate segmentView:self didClickIndex:self.selectedIndex];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                if (view.tag == 100+self.selectedIndex) {
                    [(UIButton*)view setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.2 animations:^{
                        _markLine.centerX = view.centerX;
                    }];
                } else {
                    [(UIButton*)view setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
                }
            }
        }
    }
}

@end
