//
//  CHTCollectionViewWaterfallHeader.h
//  Demo
//
//  Created by Neil Kimmett on 21/10/2013.
//  Copyright (c) 2013 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHTCollectionViewWaterfallHeaderDelegate <NSObject>
- (void)didClickTagAtIndex:(NSInteger)index;
@end

@interface CHTCollectionViewWaterfallHeader : UICollectionReusableView
@property (nonatomic, strong) UIImageView *mImageView;
@property (nonatomic, assign) id<CHTCollectionViewWaterfallHeaderDelegate> delegate;
@end
