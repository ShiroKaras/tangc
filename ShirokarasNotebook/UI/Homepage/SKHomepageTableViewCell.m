//
//  SKHomepageTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKHomepageTableViewCell.h"
#import "SKTitleBaseView.h"

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
        
        _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10, ROUND_WIDTH_FLOAT(50))];
        [self.contentView addSubview:_baseInfoView];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x +=5;
    frame.origin.y += 10;
    frame.size.height-=10;
    frame.size.width-=10;
    [super setFrame:frame];
}

- (void)setType:(SKHomepageTableViewCellType)type {
    
    UIView *underLine = [UIView new];
    underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
    underLine.size = CGSizeMake(SCREEN_WIDTH-30, 0.5);
    underLine.left = 10;
    [self.contentView addSubview:underLine];
    
    switch (type) {
        case SKHomepageTableViewCellTypeOnePic:{
            _imageViewOnePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, _baseInfoView.bottom, SCREEN_WIDTH-10, (SCREEN_WIDTH-10)/4*3)];
            _imageViewOnePic.backgroundColor = [UIColor yellowColor];
            [self.contentView addSubview:_imageViewOnePic];
            
            _introduceLabel = [UILabel new];
            _introduceLabel.text = @"卓大王 星空系列开放预售啦！\n成品价45，预售价40，数量有限先到先得！";
            _introduceLabel.textColor = COMMON_TEXT_COLOR;
            _introduceLabel.numberOfLines = 0;
            _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(13);
            [_introduceLabel sizeToFit];
            _introduceLabel.width = _imageViewOnePic.width-20;
            _introduceLabel.top = _imageViewOnePic.bottom+7;
            _introduceLabel.left = 10;
            [self.contentView addSubview:_introduceLabel];
            
            underLine.top = _introduceLabel.bottom+3;
            break;
        }
        case SKHomepageTableViewCellTypeMorePic:{
            self.imageUrlArray = @[@"1",@"1",@"1",@"1",@"1"];
            
            UIScrollView *scrollView = [UIScrollView new];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.top = _baseInfoView.bottom;
            scrollView.left = 10;
            scrollView.size = CGSizeMake(SCREEN_WIDTH-30, ROUND_WIDTH_FLOAT(121));
            scrollView.contentSize = CGSizeMake(self.imageUrlArray.count*ROUND_WIDTH_FLOAT(131)-ROUND_WIDTH_FLOAT(10), ROUND_WIDTH_FLOAT(121));
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            [self.contentView addSubview:scrollView];
            
            //添加图片
            for (int i=0; i<5; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(131)*i, 0, ROUND_WIDTH_FLOAT(121), ROUND_WIDTH_FLOAT(121))];
                imageView.layer.cornerRadius = 3;
                imageView.backgroundColor = [UIColor colorWithHex:0xD8DDF9];
                [scrollView addSubview:imageView];
            }
            
            //文字介绍
            _introduceLabel = [UILabel new];
            _introduceLabel.text = @"卓大王 星空系列开放预售啦！\n成品价45，预售价40，数量有限先到先得！";
            _introduceLabel.textColor = COMMON_TEXT_COLOR;
            _introduceLabel.numberOfLines = 0;
            _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(13);
            [_introduceLabel sizeToFit];
            _introduceLabel.top = scrollView.bottom+7;
            _introduceLabel.left = 10;
            [self.contentView addSubview:_introduceLabel];
            
            underLine.top = _introduceLabel.bottom+3;
            
            break;
        }
        case SKHomepageTableViewCellTypeArticle:{
            _imageViewArticle = [[UIImageView alloc] initWithFrame:CGRectMake(10, _baseInfoView.bottom, SCREEN_WIDTH-30, 200)];
            _imageViewArticle.backgroundColor = [UIColor orangeColor];
            _imageViewArticle.layer.cornerRadius = 5;
            [self.contentView addSubview:_imageViewArticle];
            
            _articleLabel = [UILabel new];
            _articleLabel.text = @"craft romm 进化史";
            _articleLabel.textColor = [UIColor whiteColor];
            _articleLabel.font = PINGFANG_FONT_OF_SIZE(15);
            [_articleLabel sizeToFit];
            _articleLabel.left = _imageViewArticle.left+10;
            _articleLabel.bottom = _imageViewArticle.bottom - 10;
            [self.contentView addSubview:_articleLabel];
            
            underLine.top = _imageViewArticle.bottom+8;
            
            break;
        }
        default:
            break;
    }
    
    //转发
    UIButton *repeaterButton = [UIButton new];
    [repeaterButton setTitle:@"转发" forState:UIControlStateNormal];
    [repeaterButton setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
    [repeaterButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    repeaterButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    repeaterButton.size = CGSizeMake((SCREEN_WIDTH-10)/3, 42);
    repeaterButton.left = 0;
    repeaterButton.top = underLine.bottom;
    [self.contentView addSubview:repeaterButton];
    //评论
    UIButton *commentButton = [UIButton new];
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
    [commentButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    commentButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    commentButton.size = CGSizeMake((SCREEN_WIDTH-10)/3, 42);
    commentButton.left = repeaterButton.right;
    commentButton.top = underLine.bottom;
    [self.contentView addSubview:commentButton];
    //点赞
    UIButton *favButton = [UIButton new];
    [favButton setTitle:@"点赞" forState:UIControlStateNormal];
    [favButton setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
    [favButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    favButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    favButton.size = CGSizeMake((SCREEN_WIDTH-10)/3, 42);
    favButton.left = commentButton.right;
    favButton.top = underLine.bottom;
    [self.contentView addSubview:favButton];
    
    [self layoutIfNeeded];
    self.cellHeight = underLine.bottom+ROUND_WIDTH_FLOAT(42);
}

@end
