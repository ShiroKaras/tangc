//
//  SKHomepageTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SKHomepageTableViewCellType) {
    SKHomepageTableViewCellTypeOnePic,
    SKHomepageTableViewCellTypeMorePic,
    SKHomepageTableViewCellTypeArticle,
};

@interface SKHomepageTableViewCell : UITableViewCell
@property (nonatomic, assign) SKHomepageTableViewCellType type;
@property (nonatomic, assign) float cellHeight;

@end
