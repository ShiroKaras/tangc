//
//  SKHomepageTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKHomepageTableViewCell.h"

@interface SKHomepageTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *followButton;

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
        self.layer.cornerRadius = 5;
        
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor greenColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.top = 10;
        _avatarImageView.left = 10;
        _avatarImageView.size = CGSizeMake(40, 40);
        [self.contentView addSubview:_avatarImageView];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"username";
        _usernameLabel.textColor = [UIColor greenColor];
        [_usernameLabel sizeToFit];
        _usernameLabel.left = _avatarImageView.right +20;
        _usernameLabel.centerY = _avatarImageView.centerY;
        [self.contentView addSubview:_usernameLabel];
        
        //关注按钮
        _followButton = [UIButton new];
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followButton.backgroundColor = [UIColor lightGrayColor];
        _followButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _followButton.layer.cornerRadius = 12;
        _followButton.size = CGSizeMake(40, 24);
        _followButton.left = SCREEN_WIDTH-20-_followButton.width -20;
        _followButton.centerY = _avatarImageView.centerY;
        [self.contentView addSubview:_followButton];
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
    underLine.size = CGSizeMake(SCREEN_WIDTH-10, 0.5);
    underLine.left = 0;
    [self.contentView addSubview:underLine];
    
    switch (type) {
        case SKHomepageTableViewCellTypeOnePic:{
            _imageViewOnePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, _avatarImageView.bottom+10, SCREEN_WIDTH-10, (SCREEN_WIDTH-10)/4*3)];
            _imageViewOnePic.backgroundColor = [UIColor yellowColor];
            [self.contentView addSubview:_imageViewOnePic];
            
            _introduceLabel = [UILabel new];
            _introduceLabel.text = @"test\ntest";
            _introduceLabel.numberOfLines = 2;
            _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(13);
            [_introduceLabel sizeToFit];
            _introduceLabel.top = _imageViewOnePic.bottom+3;
            _introduceLabel.left = 10;
            [self.contentView addSubview:_introduceLabel];
            
            underLine.top = _introduceLabel.bottom+3;
            break;
        }
        case SKHomepageTableViewCellTypeMorePic:{
            UIScrollView *scrollView = [UIScrollView new];
            scrollView.backgroundColor = [UIColor greenColor];
            scrollView.top = _avatarImageView.bottom+10;
            scrollView.left = 0;
            scrollView.size = CGSizeMake(SCREEN_WIDTH-10, 200);
            scrollView.contentSize = CGSizeMake(scrollView.width*2, 200);
            scrollView.showsVerticalScrollIndicator = NO;
            [self.contentView addSubview:scrollView];
            
            //添加图片
            for (int i=0; i<5; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+190*i, 10, 180, 180)];
                imageView.backgroundColor = [UIColor yellowColor];
                [scrollView addSubview:imageView];
            }
            
            //文字介绍
            _introduceLabel = [UILabel new];
            _introduceLabel.text = @"test\ntest";
            _introduceLabel.numberOfLines = 2;
            _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(13);
            [_introduceLabel sizeToFit];
            _introduceLabel.top = scrollView.bottom+3;
            _introduceLabel.left = 10;
            [self.contentView addSubview:_introduceLabel];
            
            underLine.top = _introduceLabel.bottom+3;
            
            break;
        }
        case SKHomepageTableViewCellTypeArticle:{
            _imageViewArticle = [[UIImageView alloc] initWithFrame:CGRectMake(10, _avatarImageView.bottom+10, SCREEN_WIDTH-30, 200)];
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
    
    //评论转发
    
    
    [self layoutIfNeeded];
    self.cellHeight = underLine.bottom+50;
}

@end
