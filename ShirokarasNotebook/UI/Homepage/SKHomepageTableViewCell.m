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

- (void)setTopic:(SKTopic *)topic {
    [self setType:topic.type withTopic:topic];
    [self.baseInfoView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:topic.userinfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
    self.baseInfoView.usernameLabel.text = topic.userinfo.nickname;
    [self.baseInfoView.usernameLabel sizeToFit];
    self.baseInfoView.dateLabel.text = topic.add_time;
    [self.baseInfoView.dateLabel sizeToFit];
    if (topic.type==1||topic.type==2) {
        self.imageUrlArray = topic.images;
    }
}

- (void)setImageUrlArray:(NSArray<NSString *> *)imageUrlArray {
    for (int i=0; i<imageUrlArray.count; i++) {
        [((UIImageView*)[self viewWithTag:100+i]) sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[i]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
    }
}

- (void)setType:(SKHomepageTableViewCellType)type withTopic:(SKTopic*)topic {
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
            _imageViewOnePic.layer.masksToBounds = YES;
            _imageViewOnePic.contentMode = UIViewContentModeScaleAspectFill;
            [_imageViewOnePic sd_setImageWithURL:[NSURL URLWithString:topic.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
            [self.contentView addSubview:_imageViewOnePic];
            
            _introduceLabel = [UILabel new];
            _introduceLabel.text = topic.content;
            _introduceLabel.textColor = COMMON_TEXT_COLOR;
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
            UIScrollView *scrollView = [UIScrollView new];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.top = _baseInfoView.bottom;
            scrollView.left = 15;
            scrollView.size = CGSizeMake(CELL_WIDTH-30, ROUND_WIDTH_FLOAT(121));
            scrollView.contentSize = CGSizeMake(topic.images.count*ROUND_WIDTH_FLOAT(129)-ROUND_WIDTH_FLOAT(8), ROUND_WIDTH_FLOAT(121));
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            [self.contentView addSubview:scrollView];
            
            //添加图片
            for (int i=0; i<topic.images.count; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(129)*i, 0, ROUND_WIDTH_FLOAT(121), ROUND_WIDTH_FLOAT(121))];
                imageView.tag = 100+i;
                imageView.layer.cornerRadius = 3;
                imageView.layer.masksToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [imageView sd_setImageWithURL:[NSURL URLWithString:topic.images[i]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                [scrollView addSubview:imageView];
            }
            
            //文字介绍
            _introduceLabel = [UILabel new];
            _introduceLabel.text = topic.content;
            _introduceLabel.textColor = COMMON_TEXT_COLOR;
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
            _imageViewArticle.layer.cornerRadius = 5;
            _imageViewArticle.layer.masksToBounds = YES;
            [_imageViewArticle sd_setImageWithURL:[NSURL URLWithString:topic.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
            [self.contentView addSubview:_imageViewArticle];
            
            _articleLabel = [UILabel new];
            _articleLabel.text = topic.content;
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
    _repeaterButton = [UIButton new];
    [_repeaterButton setTitle:@"转发" forState:UIControlStateNormal];
    [_repeaterButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_repeaterButton setBackgroundImage:[UIImage imageWithColor:COMMON_BG_COLOR] forState:UIControlStateHighlighted];
    _repeaterButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    _repeaterButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    _repeaterButton.left = 0;
    _repeaterButton.top = underLine.bottom;
    [self.contentView addSubview:_repeaterButton];
    //评论
    _commentButton = [UIButton new];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_commentButton setBackgroundImage:[UIImage imageWithColor:COMMON_BG_COLOR] forState:UIControlStateHighlighted];
    _commentButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    _commentButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    _commentButton.left = _repeaterButton.right;
    _commentButton.top = underLine.bottom;
    [self.contentView addSubview:_commentButton];
    //点赞
    _favButton = [UIButton new];
    [_favButton setTitle:@"点赞" forState:UIControlStateNormal];
    [_favButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_favButton setBackgroundImage:[UIImage imageWithColor:COMMON_BG_COLOR] forState:UIControlStateHighlighted];
    _favButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    _favButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    _favButton.left = _commentButton.right;
    _favButton.top = underLine.bottom;
    [self.contentView addSubview:_favButton];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, _repeaterButton.bottom, SCREEN_WIDTH, 1)];
    sepLine.backgroundColor = COMMON_BG_COLOR;
    [self.contentView addSubview:sepLine];
    
    [self layoutIfNeeded];
    self.cellHeight = sepLine.bottom;
}

@end
