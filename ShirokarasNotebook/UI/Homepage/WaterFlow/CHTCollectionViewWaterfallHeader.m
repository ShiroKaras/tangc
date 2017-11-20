//
//  CHTCollectionViewWaterfallHeader.m
//  Demo
//
//  Created by Neil Kimmett on 21/10/2013.
//  Copyright (c) 2013 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallHeader.h"

@implementation CHTCollectionViewWaterfallHeader

#pragma mark - Accessors
- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
      _mImageView = [[UIImageView alloc] initWithFrame:self.frame];
      _mImageView.contentMode = UIViewContentModeScaleAspectFill;
      _mImageView.layer.masksToBounds = YES;
      _mImageView.image = [UIImage imageNamed:@"MaskCopy"];
      [self addSubview:_mImageView];
  }
  return self;
}

@end
