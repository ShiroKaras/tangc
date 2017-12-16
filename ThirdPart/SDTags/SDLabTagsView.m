//
//  SDLabTagsView.m
//  SDTagsView
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 slowdony. All rights reserved.
//

#import "SDLabTagsView.h"
#import "SDHeader.h"
#import "SDHelper.h"
@interface SDLabTagsView ()
{
    UIView *sdTagsView;
}
@property (nonatomic,strong)UILabel *tagsLab;
@end
@implementation SDLabTagsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUP];
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setUP{
    // 创建标签容器
    sdTagsView = [[UIView alloc] init];
    sdTagsView.frame  = CGRectMake(0, 0, mDeviceWidth, ROUND_WIDTH_FLOAT(100));
    
    sdTagsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:sdTagsView];
}

+(instancetype)sdLabTagsViewWithTagsArr:(NSArray<SKTag*> *)tagsArr{
    SDLabTagsView *sdLabTagsView =[[SDLabTagsView alloc]init];
    sdLabTagsView.tagsArr =tagsArr;
    [sdLabTagsView setUItags:tagsArr];
    return sdLabTagsView;
}

- (void)setUItags:(NSArray *)arr{
    int width = ROUND_WIDTH_FLOAT(15);
    int j = 0;
    int row = 0;
    
    for (int i = 0 ; i < arr.count; i++) {
        SKTag *model =arr[i];
        CGFloat labWidth = [SDHelper widthForLabel:model.name fontSize:ROUND_WIDTH_FLOAT(12)]+ROUND_WIDTH_FLOAT(40);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5*j + width, row * ROUND_WIDTH_FLOAT(46+8), labWidth, ROUND_WIDTH_FLOAT(46))];
        view.layer.cornerRadius =3;
        view.layer.masksToBounds = YES;
        [sdTagsView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if ([self.delegate respondsToSelector:@selector(didClickTagAtIndex:)]) {
                [self.delegate didClickTagAtIndex:i];
            }
        }];
        [view addGestureRecognizer:tap];
        
        //文本1
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHex:0xF0F4F8];
        label.text = [NSString stringWithFormat:@"#%@#",model.name];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        label.numberOfLines = 1;
        [label sizeToFit];
        label.centerY = view.height/2;
        label.centerX = view.width/2;
        
        //添加渐变
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithHex:0x72AFD3].CGColor,
                           (id)[UIColor colorWithHex:0x37ECBA].CGColor, nil];
        gradient.startPoint = CGPointMake(0, 1);
        gradient.endPoint = CGPointMake(1, 0);
        gradient.locations = @[@0.0, @1];
        [view.layer addSublayer:gradient];
        [view addSubview:label];
        
        width = width + labWidth;
        
        j++;
        if (width > mDeviceWidth - ROUND_WIDTH_FLOAT(30)) {
            j = 0;
            width = ROUND_WIDTH_FLOAT(15);
            row++;
            view.frame = CGRectMake(5*j + width,row * ROUND_WIDTH_FLOAT(46+8), labWidth, ROUND_WIDTH_FLOAT(46));
            width = width + labWidth;
            j++;
        }
    }
}



@end
