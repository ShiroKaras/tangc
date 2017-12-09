//
//  SKTopicsView.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/16.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSegmentView.h"

@interface SKTopicsView : UIView
@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
