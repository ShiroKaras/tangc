//
//  SKHomepageTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKHomepageTableViewCell.h"
#import "SKTitleBaseView.h"

#define CELL_WIDTH (SCREEN_WIDTH)

@interface SKHomepageTableViewCell ()
@property (nonatomic, strong) SKTitleBaseView *baseInfoView;

//OnePic
@property (nonatomic, strong) UIImageView *imageViewOnePic;
//MorePic
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) NSArray<NSString*>* imageUrlArray;
//Article
@property (nonatomic, strong) UIImageView *imageViewArticle;
@property (nonatomic, strong) UILabel *articleLabel;
@end

@implementation SKHomepageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 3;
        
        _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, ROUND_WIDTH_FLOAT(60))];
        [self.contentView addSubview:_baseInfoView];
    }
    return self;
}

//-(void)setFrame:(CGRect)frame {
//    frame.origin.x +=5;
//    frame.origin.y += 10;
//    frame.size.height-=10;
//    frame.size.width-=10;
//    [super setFrame:frame];
//}

- (void)setType:(SKHomepageTableViewCellType)type {
    for (UIView *view in self.contentView.subviews) {
        if (![view isKindOfClass:[SKTitleBaseView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIView *underLine = [UIView new];
    [self.contentView addSubview:underLine];
    underLine.backgroundColor = [UIColor clearColor];
    underLine.size = CGSizeMake(CELL_WIDTH -20, 0.5);
    underLine.left = 10;
    
    switch (type) {
        case SKHomepageTableViewCellTypeOnePic:{
            _imageViewOnePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, _baseInfoView.bottom, CELL_WIDTH-30, (CELL_WIDTH-30)/4*3)];
            _imageViewOnePic.layer.cornerRadius = 3;
            _imageViewOnePic.backgroundColor = [UIColor colorWithHex:0xD8DDF9];
            [self.contentView addSubview:_imageViewOnePic];
            
            _introduceLabel = [UILabel new];
            _introduceLabel.text = @"卓大王 星空系列开放预售啦！\n成品价45，预售价40，数量有限先到先得！";
            _introduceLabel.textColor = [UIColor colorWithHex:0x1F4035];
            _introduceLabel.numberOfLines = 2;
            _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
            [_introduceLabel sizeToFit];
            _introduceLabel.width = _imageViewOnePic.width-20;
            _introduceLabel.top = _imageViewOnePic.bottom+15;
            _introduceLabel.left = 15;
            [self.contentView addSubview:_introduceLabel];
            
            underLine.top = _introduceLabel.bottom+10;
            break;
        }
        case SKHomepageTableViewCellTypeMorePic:{
            self.imageUrlArray = @[@"1",@"1",@"1",@"1",@"1"];
            
            UIScrollView *scrollView = [UIScrollView new];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.top = _baseInfoView.bottom;
            scrollView.left = 15;
            scrollView.size = CGSizeMake(CELL_WIDTH-30, ROUND_WIDTH_FLOAT(121));
            scrollView.contentSize = CGSizeMake(self.imageUrlArray.count*ROUND_WIDTH_FLOAT(129)-ROUND_WIDTH_FLOAT(8), ROUND_WIDTH_FLOAT(121));
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            [self.contentView addSubview:scrollView];
            
            //添加图片
            for (int i=0; i<5; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(129)*i, 0, ROUND_WIDTH_FLOAT(121), ROUND_WIDTH_FLOAT(121))];
                imageView.layer.cornerRadius = 3;
                imageView.backgroundColor = [UIColor colorWithHex:0xD8DDF9];
                [scrollView addSubview:imageView];
            }
            
            //文字介绍
            _introduceLabel = [UILabel new];
            _introduceLabel.text = @"卓大王 星空系列开放预售啦！\n成品价45，预售价40，数量有限先到先得！";
            _introduceLabel.textColor = [UIColor colorWithHex:0x1F4035];
            _introduceLabel.numberOfLines = 0;
            _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
            [_introduceLabel sizeToFit];
            _introduceLabel.top = scrollView.bottom+15;
            _introduceLabel.left = 15;
            [self.contentView addSubview:_introduceLabel];
            
            underLine.top = _introduceLabel.bottom+10;
            
            break;
        }
        case SKHomepageTableViewCellTypeArticle:{
            _imageViewArticle = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), _baseInfoView.bottom, ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(75))];
            _imageViewArticle.backgroundColor = [UIColor colorWithHex:0xD8DDF9];
            _imageViewArticle.layer.cornerRadius = 5;
            _imageViewArticle.layer.masksToBounds = YES;
            [self.contentView addSubview:_imageViewArticle];
            
            _articleLabel = [UILabel new];
            _articleLabel.text = @"craft romm 进化史";
            _articleLabel.textColor = [UIColor whiteColor];
            _articleLabel.font = PINGFANG_FONT_OF_SIZE(14);
            [_articleLabel sizeToFit];
            _articleLabel.left = _imageViewArticle.left+ROUND_WIDTH_FLOAT(10);
            _articleLabel.centerY = _imageViewArticle.centerY;
            [self.contentView addSubview:_articleLabel];
            
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithHex:0x74EBD5];
            view.layer.cornerRadius = ROUND_WIDTH_FLOAT(19)/2;
            view.size = CGSizeMake(ROUND_WIDTH_FLOAT(38+19), ROUND_WIDTH_FLOAT(19));
            view.right = _imageViewArticle.width+ROUND_WIDTH_FLOAT(19);
            view.centerY = _imageViewArticle.height/2;
            [_imageViewArticle addSubview:view];
            
            UILabel *label = [UILabel new];
            label.text = @"文章";
            label.textColor = [UIColor whiteColor];
            label.font = PINGFANG_FONT_OF_SIZE(9);
            [label sizeToFit];
            label.left = ROUND_WIDTH_FLOAT(10);
            label.centerY = view.height/2;
            [view addSubview:label];
            
            underLine.top = _imageViewArticle.bottom+8;
            
            break;
        }
        default:
            break;
    }
    
    //转发
    UIButton *repeaterButton = [UIButton new];
    [repeaterButton setTitle:@"转发" forState:UIControlStateNormal];
    [repeaterButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [repeaterButton setBackgroundImage:[UIImage imageWithColor:COMMON_BG_COLOR] forState:UIControlStateHighlighted];
    repeaterButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    repeaterButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    repeaterButton.left = 0;
    repeaterButton.top = underLine.bottom;
    [self.contentView addSubview:repeaterButton];
    //评论
    UIButton *commentButton = [UIButton new];
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [commentButton setBackgroundImage:[UIImage imageWithColor:COMMON_BG_COLOR] forState:UIControlStateHighlighted];
    commentButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    commentButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    commentButton.left = repeaterButton.right;
    commentButton.top = underLine.bottom;
    [self.contentView addSubview:commentButton];
    //点赞
    UIButton *favButton = [UIButton new];
    [favButton setTitle:@"点赞" forState:UIControlStateNormal];
    [favButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [favButton setBackgroundImage:[UIImage imageWithColor:COMMON_BG_COLOR] forState:UIControlStateHighlighted];
    favButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    favButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    favButton.left = commentButton.right;
    favButton.top = underLine.bottom;
    [self.contentView addSubview:favButton];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, repeaterButton.bottom, SCREEN_WIDTH, 1)];
    sepLine.backgroundColor = COMMON_BG_COLOR;
    [self.contentView addSubview:sepLine];
    
    [self layoutIfNeeded];
    self.cellHeight = sepLine.bottom;
}

@end