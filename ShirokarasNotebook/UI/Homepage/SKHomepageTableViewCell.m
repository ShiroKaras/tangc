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
@property (nonatomic, strong) NSArray<NSString*>* imageUrlArray;
@end

@implementation SKHomepageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
        
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
        
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = [UIColor greenColor];
        scrollView.top = _avatarImageView.bottom+10;
        scrollView.left = 0;
        scrollView.size = CGSizeMake(SCREEN_WIDTH, 200);
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 200);
        scrollView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        
        //添加图片
        for (int i=0; i<5; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+190*i, 10, 180, 180)];
            imageView.backgroundColor = [UIColor yellowColor];
            [scrollView addSubview:imageView];
        }
        
        UIView *underLine = [UIView new];
        underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
        underLine.top = scrollView.bottom+49;
        underLine.left = 0;
        underLine.size = CGSizeMake(SCREEN_WIDTH, 0.5);
        [self.contentView addSubview:underLine];
        
        //评论转发
        
        [self layoutIfNeeded];
        self.cellHeight = scrollView.bottom+50;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
