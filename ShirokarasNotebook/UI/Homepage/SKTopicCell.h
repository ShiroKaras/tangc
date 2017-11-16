//
//  SKTopicCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/16.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKTopicCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *mCoverImageView;
@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) UIImageView *mAvatarImageView;
@property (nonatomic, strong) UILabel *mUsernameLabel;
@property (nonatomic, assign) float cellHeight;

- (void)setTopic:(NSString *)topic;

@end
