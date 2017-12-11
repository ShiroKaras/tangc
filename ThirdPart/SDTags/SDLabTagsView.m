//
//  SDLabTagsView.m
//  SDTagsView
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 slowdony. All rights reserved.
//

#import "SDLabTagsView.h"
#import "SDHeader.h"
#import "TagsModel.h"
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

+(instancetype)sdLabTagsViewWithTagsArr:(NSArray *)tagsArr{
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
        TagsModel *model =arr[i];
        CGFloat labWidth = [SDHelper widthForLabel:model.title fontSize:ROUND_WIDTH_FLOAT(12)]+ROUND_WIDTH_FLOAT(40);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5*j + width, row * ROUND_WIDTH_FLOAT(46+8), labWidth, ROUND_WIDTH_FLOAT(46))];
        view.layer.cornerRadius =3;
        view.layer.masksToBounds = YES;
        [sdTagsView addSubview:view];
        //文本1
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHex:0xF0F4F8];
        label.text =model.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        label.numberOfLines = 1;
        [label sizeToFit];
        label.top = ROUND_WIDTH_FLOAT(10);
        label.centerX = view.width/2;
        //文本2
        UILabel *label2 = [[UILabel alloc] init];
        label2.textColor = [UIColor whiteColor];
        label2.text =@"55人参与";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
        label2.numberOfLines = 1;
        [label2 sizeToFit];
        label2.top = ROUND_WIDTH_FLOAT(27);
        label2.centerX = view.width/2;
        
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
        [view addSubview:label2];
        
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
