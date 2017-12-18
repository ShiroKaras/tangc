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

#define LABEL_HEIGHT ROUND_WIDTH_FLOAT(30)
#define PADDING_WIDTH ROUND_WIDTH_FLOAT(8)

@interface SDLabTagsView ()
{
    UIScrollView *sdTagsView;
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
    sdTagsView = [[UIScrollView alloc] init];
    sdTagsView.frame  = CGRectMake(0, 0, mDeviceWidth, ROUND_WIDTH_FLOAT(68));
    sdTagsView.contentSize = CGSizeMake(1000, LABEL_HEIGHT*2+ROUND_WIDTH_FLOAT(8));
    sdTagsView.showsHorizontalScrollIndicator = NO;
    sdTagsView.showsVerticalScrollIndicator = NO;
//    sdTagsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    
    int row1 = 0;
    int row2 = 0;
    
    for (int i = 0 ; i < arr.count; i++) {
        SKTag *model =arr[i];
        CGFloat labWidth = [SDHelper widthForLabel:model.name fontSize:ROUND_WIDTH_FLOAT(12)]+ROUND_WIDTH_FLOAT(30);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(PADDING_WIDTH*j + width, row * (LABEL_HEIGHT+PADDING_WIDTH), labWidth, LABEL_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = LABEL_HEIGHT/2;
        view.layer.masksToBounds = YES;
        [sdTagsView addSubview:view];
        
        
        //文本1
        UILabel *label = [[UILabel alloc] init];
        label.textColor = COMMON_TEXT_COLOR;
        label.text = [NSString stringWithFormat:@"#%@#",model.name];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        label.numberOfLines = 1;
        [label sizeToFit];
        label.centerY = view.height/2;
        label.centerX = view.width/2;
        [view addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if ([self.delegate respondsToSelector:@selector(didClickTagAtIndex:)]) {
                for (UIView *mView in sdTagsView.subviews) {
                    mView.backgroundColor = [UIColor whiteColor];
                    for (UILabel *mLabel in mView.subviews) {
                        mLabel.textColor = COMMON_TEXT_COLOR;
                    }
                }
                
                view.backgroundColor = [UIColor colorWithHex:0x98cb99];
                label.textColor = [UIColor whiteColor];
                [self.delegate didClickTagAtIndex:i];
            }
        }];
        [view addGestureRecognizer:tap];
        
        width = width + labWidth;
        
        j++;
        
        //换行条件
        if (row2<row1) {
            row = 1;
            view.frame = CGRectMake(row2+PADDING_WIDTH,row * (LABEL_HEIGHT+PADDING_WIDTH), labWidth, LABEL_HEIGHT);
            row2 = view.right;
        } else {
            row = 0;
            view.frame = CGRectMake(row1+PADDING_WIDTH,row * (LABEL_HEIGHT+PADDING_WIDTH), labWidth, LABEL_HEIGHT);
            row1 = view.right;
        }
        sdTagsView.contentSize = CGSizeMake(MAX(row1, row2)+ROUND_WIDTH_FLOAT(15), LABEL_HEIGHT*2+PADDING_WIDTH);
    }
}



@end
