//
//  SKMypageArticleTableViewCell.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKMypageArticleTableViewCell.h"

@interface SKMypageArticleTableViewCell ()
@property (nonatomic, strong) UIImageView *mTitleImageView;
@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) UILabel *mDateLabel;
@property (nonatomic, strong) UILabel *mCommentCountLabel;
@property (nonatomic, strong) UILabel *mLikeLabel;
@end

@implementation SKMypageArticleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mTitleImageView];
        [self.contentView addSubview:self.mTitleLabel];
        
        self.cellHeight = ROUND_WIDTH_FLOAT(134);
    }
    return self;
}

@end
