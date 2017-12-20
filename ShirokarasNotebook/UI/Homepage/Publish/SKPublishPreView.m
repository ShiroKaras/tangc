//
//  SKPublishPreView.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPublishPreView.h"
#import "SKPublishNewContentViewController.h"
#import "HWScanViewController.h"
@implementation SKPublishPreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
        backView.alpha = 0.95;
        [self addSubview:backView];
        
        UIButton *closeButton = [UIButton new];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_releasepage_close"] forState:UIControlStateNormal];
        [self addSubview:closeButton];
        closeButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(22), ROUND_WIDTH_FLOAT(22));
        closeButton.centerX = self.width/2;
        closeButton.bottom = self.bottom-ROUND_WIDTH_FLOAT(15);
        [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha =0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
        
        UIButton *postImageButton = [UIButton new];
        [postImageButton setBackgroundImage:[UIImage imageNamed:@"btn_releasepage_photo"] forState:UIControlStateNormal];
        [self addSubview:postImageButton];
        postImageButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(55), ROUND_WIDTH_FLOAT(79));
        postImageButton.bottom = self.bottom-103;
        postImageButton.centerX = self.width/2-80;
        [[postImageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            SKPublishNewContentViewController *controller = [[SKPublishNewContentViewController alloc] initWithType:SKPublishTypeNew withUserPost:nil];
            [[self viewController].navigationController pushViewController:controller animated:YES];
            [self removeFromSuperview];
        } completed:^{
        }];
        
        UIButton *postPcButton = [UIButton new];
        [postPcButton setBackgroundImage:[UIImage imageNamed:@"btn_releasepage_computer"] forState:UIControlStateNormal];
        [self addSubview:postPcButton];
        postPcButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(55), ROUND_WIDTH_FLOAT(79));
        postPcButton.bottom = self.bottom-103;
        postPcButton.centerX = self.width/2+80;
        [[postPcButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            HWScanViewController *controller = [[HWScanViewController alloc] init];
            [[self viewController].navigationController pushViewController:controller animated:YES];
            [self removeFromSuperview];
        } completed:^{
        }];
    }
    return self;
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
