//
//  SKShopTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/12.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKShopTableViewCellChildView : UIView
@property (nonatomic, strong) UIImageView *mImageView;
@property (nonatomic, strong) UILabel *mContentLabel;
@property (nonatomic, strong) UILabel *mMoneyLabel;
@property (nonatomic, strong) UILabel *mCountLabel;
@end

@interface SKShopTableViewCell : UITableViewCell
@property (nonatomic, strong) SKShopTableViewCellChildView *view_left;
@property (nonatomic, strong) SKShopTableViewCellChildView *view_right;
@property (nonatomic, strong) SKGoods *leftData;
@property (nonatomic, strong) SKGoods *rightData;
@end


