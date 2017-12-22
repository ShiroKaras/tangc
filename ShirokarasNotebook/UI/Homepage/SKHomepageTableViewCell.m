//
//  SKHomepageTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKHomepageTableViewCell.h"

#define CELL_WIDTH (SCREEN_WIDTH)

@interface SKHomepageTableViewCell ()
@property (nonatomic, strong) UIView *baseContentView;

@property (nonatomic, strong) UILabel *repostLabel;
//OnePic
@property (nonatomic, strong) UIImageView *imageViewOnePic;
//MorePic
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) NSArray<NSString*>* imageUrlArray;
//Article
@property (nonatomic, strong) UIImageView *imageViewArticle;
@property (nonatomic, strong) UILabel *articleLabel;
//是否关注
@property (nonatomic, assign) BOOL isFollow;

@property (nonatomic, strong) UIView *underLine;
@end

@implementation SKHomepageTableViewCell {
    BOOL fav_lock;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 3;
        [self.contentView addSubview:self.baseInfoView];
    }
    return self;
}

- (SKTitleBaseView *)baseInfoView {
    if (!_baseInfoView) {
        _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, ROUND_WIDTH_FLOAT(60)) withTopic:self.topic];
        _baseInfoView.followButton.hidden = YES;
    }
    return _baseInfoView;
}

- (void)setTopic:(SKTopic *)topic {
    _topic = topic;
    self.isFollow = topic.is_follow;
    
    [self setType:topic.type withTopic:topic];
    self.baseInfoView.userInfo = topic.userinfo;
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
    _topic = topic;
    CGSize maxSize = CGSizeMake(ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(50));
    
    //按钮、内容的透明分割线
    _underLine = [UIView new];
    [self.contentView addSubview:_underLine];
    _underLine.backgroundColor = [UIColor clearColor];
    _underLine.size = CGSizeMake(CELL_WIDTH -20, 0.5);
    _underLine.left = 10;
    
    NSString *content = @"";
    
    //转发
    if ((topic.from && topic.from.id!=0)||(topic.from.is_del==1)) {
        content = topic.from.content;
        
        _repostLabel = [UILabel new];
        _repostLabel.text = topic.content;
        _repostLabel.textColor = COMMON_TEXT_COLOR;
        _repostLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
        _repostLabel.numberOfLines = 2;
        CGSize labelSize = [topic.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
        _repostLabel.size = labelSize;
        _repostLabel.left = ROUND_WIDTH_FLOAT(15);
        _repostLabel.top = _baseInfoView.bottom;
        [self.contentView addSubview:_repostLabel];
        [self regxWithContent:topic.content label:_repostLabel];
        
        _underLine.top = _repostLabel.bottom+10;
        
        _baseContentView = [[UIView alloc] initWithFrame:CGRectMake(0, _repostLabel.bottom+ROUND_WIDTH_FLOAT(15), SCREEN_WIDTH, 0)];
        _baseContentView.backgroundColor = COMMON_HIGHLIGHT_BG_COLOR;
        [self.contentView addSubview:_baseContentView];
        
        if (topic.from.is_del) {
            UILabel *errLabel = [UILabel new];
            errLabel.text = @"抱歉，该内容已被作者删除";
            errLabel.textColor = COMMON_TEXT_COLOR;
            errLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
            [errLabel sizeToFit];
            errLabel.centerX = SCREEN_WIDTH/2;
            errLabel.top = _repostLabel.bottom +ROUND_WIDTH_FLOAT(30);
            [self.contentView addSubview:errLabel];
            
            _underLine.top = errLabel.bottom +ROUND_WIDTH_FLOAT(15);
        } else {
            UILabel *oriNameLabel = [UILabel new];
            oriNameLabel.text = [NSString stringWithFormat:@"@%@", topic.from.userinfo.nickname];
            oriNameLabel.textColor = COMMON_TEXT_COLOR;
            oriNameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
            [oriNameLabel sizeToFit];
            oriNameLabel.top = _baseContentView.top +ROUND_WIDTH_FLOAT(15);
            oriNameLabel.left = ROUND_WIDTH_FLOAT(15);
            [self.contentView addSubview:oriNameLabel];
            
            switch (type) {
                case SKHomepageTableViewCellTypeOnePic:{
                    _imageViewOnePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, _repostLabel.bottom+ROUND_WIDTH_FLOAT(15)+ROUND_WIDTH_FLOAT(42), CELL_WIDTH-30, (CELL_WIDTH-30)/4*3)];
                    _imageViewOnePic.layer.cornerRadius = 3;
                    _imageViewOnePic.layer.masksToBounds = YES;
                    _imageViewOnePic.contentMode = UIViewContentModeScaleAspectFill;
                    if (topic.from.images.count>0) {
                        [_imageViewOnePic sd_setImageWithURL:[NSURL URLWithString:topic.from.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                    }
                    [self.contentView addSubview:_imageViewOnePic];
                    
                    _introduceLabel = [UILabel new];
                    _introduceLabel.text = topic.from.content;
                    _introduceLabel.textColor = COMMON_TEXT_COLOR;
                    _introduceLabel.numberOfLines = 2;
                    _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
                    CGSize labelSize = [topic.from.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                    _introduceLabel.size = labelSize;
                    _introduceLabel.top = _imageViewOnePic.bottom+15;
                    _introduceLabel.left = 15;
                    [self.contentView addSubview:_introduceLabel];
                    
                    _underLine.top = _introduceLabel.bottom+10;
                    [self regxWithContent:content label:_introduceLabel];
                    break;
                }
                case SKHomepageTableViewCellTypeMorePic:{
                    UIScrollView *scrollView = [UIScrollView new];
                    scrollView.backgroundColor = [UIColor clearColor];
                    scrollView.top = _repostLabel.bottom+ROUND_WIDTH_FLOAT(15)+ROUND_WIDTH_FLOAT(42);
                    scrollView.left = 15;
                    scrollView.size = CGSizeMake(CELL_WIDTH-30, ROUND_WIDTH_FLOAT(121));
                    scrollView.contentSize = CGSizeMake(topic.from.images.count*ROUND_WIDTH_FLOAT(129)-ROUND_WIDTH_FLOAT(8), ROUND_WIDTH_FLOAT(121));
                    scrollView.showsVerticalScrollIndicator = NO;
                    scrollView.showsHorizontalScrollIndicator = NO;
                    [self.contentView addSubview:scrollView];
                    
                    //添加图片
                    for (int i=0; i<topic.from.images.count; i++) {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(129)*i, 0, ROUND_WIDTH_FLOAT(121), ROUND_WIDTH_FLOAT(121))];
                        imageView.tag = 100+i;
                        imageView.layer.cornerRadius = 3;
                        imageView.layer.masksToBounds = YES;
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        if (topic.from.images.count > 0) {
                            [imageView sd_setImageWithURL:[NSURL URLWithString:topic.from.images[i]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                        }
                        [scrollView addSubview:imageView];
                        //[self showPicWithImageView:imageView url:topic.from.images[i]];
                    }
                    
                    //文字介绍
                    _introduceLabel = [UILabel new];
                    _introduceLabel.text = topic.from.content;
                    _introduceLabel.textColor = COMMON_TEXT_COLOR;
                    _introduceLabel.numberOfLines = 0;
                    _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
                    CGSize labelSize = [topic.from.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                    _introduceLabel.size = labelSize;
                    _introduceLabel.top = scrollView.bottom+15;
                    _introduceLabel.left = 15;
                    [self.contentView addSubview:_introduceLabel];
                    
                    _underLine.top = _introduceLabel.bottom+10;
                    [self regxWithContent:content label:_introduceLabel];
                    break;
                }
                case SKHomepageTableViewCellTypeArticle:{
                    _imageViewArticle = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), _repostLabel.bottom+ROUND_WIDTH_FLOAT(15)+ROUND_WIDTH_FLOAT(42), ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(150))];
                    _imageViewArticle.contentMode = UIViewContentModeScaleAspectFill;
                    _imageViewArticle.layer.cornerRadius = 5;
                    _imageViewArticle.layer.masksToBounds = YES;
                    if (topic.from.images.count>0) {
                        [_imageViewArticle sd_setImageWithURL:[NSURL URLWithString:topic.from.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                    }
                    [self.contentView addSubview:_imageViewArticle];
                    
                    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageViewArticle.width, _imageViewArticle.height)];
                    alphaView.backgroundColor = [UIColor colorWithHex:0x3b3b3b alpha:0.6];
                    [_imageViewArticle addSubview:alphaView];
                    
                    _articleLabel = [UILabel new];
                    _articleLabel.text = topic.from.title;
                    _articleLabel.textColor = [UIColor whiteColor];
                    _articleLabel.numberOfLines = 2;
                    CGSize labelSize = [topic.from.title boundingRectWithSize:CGSizeMake(ROUND_WIDTH_FLOAT(270), ROUND_WIDTH_FLOAT(60)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                    _articleLabel.size = labelSize;
                    _articleLabel.width = ROUND_WIDTH_FLOAT(270);
                    _articleLabel.left = _imageViewArticle.left+ROUND_WIDTH_FLOAT(10);
                    _articleLabel.bottom = _imageViewArticle.bottom-ROUND_WIDTH_FLOAT(10);
                    [self.contentView addSubview:_articleLabel];
                    
                    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_label_article"]];
                    view.size = CGSizeMake(ROUND_WIDTH_FLOAT(38), ROUND_WIDTH_FLOAT(19));
                    view.right = _imageViewArticle.width;
                    view.top = 30;
                    [_imageViewArticle addSubview:view];
                    
                    _underLine.top = _imageViewArticle.bottom+8;
                    
                    break;
                }
                default:
                    break;
            }
        }
    }
    //原创
    else {
        content = topic.content;
        switch (type) {
            case SKHomepageTableViewCellTypeOnePic:{
                _imageViewOnePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, _baseInfoView.bottom, CELL_WIDTH-30, (CELL_WIDTH-30)/4*3)];
                _imageViewOnePic.layer.cornerRadius = 3;
                _imageViewOnePic.layer.masksToBounds = YES;
                _imageViewOnePic.contentMode = UIViewContentModeScaleAspectFill;
                if (topic.images.count >0) {
                    [_imageViewOnePic sd_setImageWithURL:[NSURL URLWithString:topic.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                }
                [self.contentView addSubview:_imageViewOnePic];
                //[self showPicWithImageView:_imageViewOnePic url:topic.images[0]];
                
                _introduceLabel = [UILabel new];
                _introduceLabel.text = topic.content;
                _introduceLabel.textColor = COMMON_TEXT_COLOR;
                _introduceLabel.numberOfLines = 2;
                _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
                CGSize labelSize = [topic.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                _introduceLabel.size = labelSize;
                _introduceLabel.top = _imageViewOnePic.bottom+15;
                _introduceLabel.left = 15;
                [self.contentView addSubview:_introduceLabel];
                
                _underLine.top = _introduceLabel.bottom+10;
                [self regxWithContent:content label:_introduceLabel];
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
                    //[self showPicWithImageView:imageView url:topic.images[i]];
                }
                
                //文字介绍
                _introduceLabel = [UILabel new];
                _introduceLabel.text = topic.content;
                _introduceLabel.textColor = COMMON_TEXT_COLOR;
                _introduceLabel.numberOfLines = 0;
                _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
                CGSize labelSize = [topic.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                _introduceLabel.size = labelSize;
                _introduceLabel.top = scrollView.bottom+15;
                _introduceLabel.left = 15;
                [self.contentView addSubview:_introduceLabel];
                
                _underLine.top = _introduceLabel.bottom+10;
                [self regxWithContent:content label:_introduceLabel];
                break;
            }
            case SKHomepageTableViewCellTypeArticle:{
                _imageViewArticle = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), _baseInfoView.bottom, ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(150))];
                _imageViewArticle.contentMode = UIViewContentModeScaleAspectFill;
                _imageViewArticle.layer.cornerRadius = 5;
                _imageViewArticle.layer.masksToBounds = YES;
                if (topic.images.count >0) {
                    [_imageViewArticle sd_setImageWithURL:[NSURL URLWithString:topic.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                }
                [self.contentView addSubview:_imageViewArticle];
                
                UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageViewArticle.width, _imageViewArticle.height)];
                alphaView.backgroundColor = [UIColor colorWithHex:0x3b3b3b alpha:0.6];
                [_imageViewArticle addSubview:alphaView];
                
                _articleLabel = [UILabel new];
                _articleLabel.text = topic.title;
                _articleLabel.textColor = [UIColor whiteColor];
                _articleLabel.numberOfLines = 2;
                CGSize labelSize = [topic.title boundingRectWithSize:CGSizeMake(ROUND_WIDTH_FLOAT(270), ROUND_WIDTH_FLOAT(60)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                _articleLabel.size = labelSize;
                _articleLabel.width = ROUND_WIDTH_FLOAT(270);
                _articleLabel.left = _imageViewArticle.left+ROUND_WIDTH_FLOAT(10);
                _articleLabel.bottom = _imageViewArticle.bottom-ROUND_WIDTH_FLOAT(10);
                [self.contentView addSubview:_articleLabel];
                
                UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_label_article"]];
                view.size = CGSizeMake(ROUND_WIDTH_FLOAT(38), ROUND_WIDTH_FLOAT(19));
                view.right = _imageViewArticle.width;
                view.top = 30;
                [_imageViewArticle addSubview:view];
                
                _underLine.top = _imageViewArticle.bottom+8;
                
                break;
            }
            default:
                break;
        }
    }
    
    _baseContentView.height = _underLine.bottom-_repostLabel.bottom-ROUND_WIDTH_FLOAT(15);
    
    //关注
    _followButton = [UIButton new];
    [_followButton setBackgroundImage:
     topic.is_follow? [UIImage imageNamed:@"btn_homepage_follow_highlight"] : [UIImage imageNamed:@"btn_homepage_follow"]
                             forState:UIControlStateNormal];
    _followButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(45), ROUND_WIDTH_FLOAT(20));
    _followButton.right = SCREEN_WIDTH-ROUND_WIDTH_FLOAT(20);
    _followButton.centerY = _baseInfoView.centerY;
    [self.contentView addSubview:_followButton];
    //转发
    _repeaterButton = [UIButton new];
    [_repeaterButton setImage:[UIImage imageNamed:@"btn_homepage_forward"] forState:UIControlStateNormal];
    [_repeaterButton setTitle:topic.transmit_num forState:UIControlStateNormal];
    [_repeaterButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_repeaterButton setBackgroundImage:[UIImage imageWithColor:COMMON_HIGHLIGHT_BG_COLOR] forState:UIControlStateHighlighted];
    _repeaterButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [_repeaterButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    _repeaterButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    _repeaterButton.left = 0;
    _repeaterButton.top = _underLine.bottom;
    [self.contentView addSubview:_repeaterButton];
    //评论
    _commentButton = [UIButton new];
    [_commentButton setImage:[UIImage imageNamed:@"btn_homepage_comment"] forState:UIControlStateNormal];
    [_commentButton setTitle:topic.comment_num forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_commentButton setBackgroundImage:[UIImage imageWithColor:COMMON_HIGHLIGHT_BG_COLOR] forState:UIControlStateHighlighted];
    _commentButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    _commentButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    _commentButton.left = _repeaterButton.right;
    _commentButton.top = _underLine.bottom;
    [self.contentView addSubview:_commentButton];
    //点赞
    _favButton = [UIButton new];
    [_favButton setImage:topic.is_thumb?[UIImage imageNamed:@"btn_homepage_like_highlight"]:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
    [_favButton setTitle:topic.thumb_num forState:UIControlStateNormal];
    [_favButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_favButton setBackgroundImage:[UIImage imageWithColor:COMMON_HIGHLIGHT_BG_COLOR] forState:UIControlStateHighlighted];
    _favButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [_favButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    _favButton.size = CGSizeMake(CELL_WIDTH/3, 44);
    _favButton.left = _commentButton.right;
    _favButton.top = _underLine.bottom;
    [self.contentView addSubview:_favButton];
    //点赞
    [[_favButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (fav_lock) {
            return;
        } else
            fav_lock = YES;
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [[self viewController] invokeLoginViewController];
            return;
        }
        if (_topic.is_thumb) {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:topic.id callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"取消点赞");
                _topic.is_thumb = 0;
                [_favButton setImage:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
                [_favButton setTitle:[NSString stringWithFormat:@"%ld", [_favButton.titleLabel.text integerValue]-1] forState:UIControlStateNormal];
                fav_lock = NO;
            }];
        } else {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:_topic.id callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"成功点赞");
                _topic.is_thumb = 1;
                [_favButton setImage:[UIImage imageNamed:@"btn_homepage_like_highlight"] forState:UIControlStateNormal];
                [_favButton setTitle:[NSString stringWithFormat:@"%ld", [_favButton.titleLabel.text integerValue]+1] forState:UIControlStateNormal];
                fav_lock = NO;
            }];
        }
    }];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, _repeaterButton.bottom, SCREEN_WIDTH, 1)];
    sepLine.backgroundColor = COMMON_BG_COLOR;
    [self.contentView addSubview:sepLine];
    
    [self layoutIfNeeded];
    self.cellHeight = sepLine.bottom;
}

- (void)showPicWithImageView:(UIImageView*)mImageView url:(NSURL*)url {
    mImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.backgroundColor = [UIColor colorWithHex:0x000000];
        view.userInteractionEnabled = YES;
        [KEY_WINDOW addSubview:view];
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_HEIGHT_FLOAT(22), ROUND_WIDTH_FLOAT(22), SCREEN_WIDTH-ROUND_WIDTH_FLOAT(44), SCREEN_HEIGHT-ROUND_HEIGHT_FLOAT(44))];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        [imageView sd_setImageWithURL:url];
        
        UITapGestureRecognizer *removeTap = [[UITapGestureRecognizer alloc] init];
        [[removeTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [view removeFromSuperview];
        }];
        [view addGestureRecognizer:removeTap];
    }];
    [mImageView addGestureRecognizer:tap];
}

- (void)regxWithContent:(NSString*)content label:(UILabel*)label {
    if (label.text == nil) {
        return;
    }
    
    // 话题的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // @的规则
    NSString *atPattern = @"\\@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@",topicPattern,atPattern];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    //匹配集合
    NSArray *results = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                  options:@{NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType}
                                                                       documentAttributes:nil error:nil];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        // 设置颜色
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x417DC1] range:result.range];
    }
    //set font
    [attrStr addAttribute:NSFontAttributeName value:PINGFANG_ROUND_FONT_OF_SIZE(14) range:NSMakeRange(0, content.length)];
    label.attributedText = attrStr;
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
