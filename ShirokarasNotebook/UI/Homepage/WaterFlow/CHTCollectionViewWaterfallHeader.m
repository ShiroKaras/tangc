//
//  CHTCollectionViewWaterfallHeader.m
//  Demo
//
//  Created by Neil Kimmett on 21/10/2013.
//  Copyright (c) 2013 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallHeader.h"
#import "SDLabTagsView.h"
#import "TagsModel.h"

@interface CHTCollectionViewWaterfallHeader () <SDLabTagsViewDelegate>
@property (nonatomic,strong) NSMutableArray<SKTag*> *dataArray;
@end

@implementation CHTCollectionViewWaterfallHeader

#pragma mark - Accessors
- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
      _mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, ROUND_WIDTH_FLOAT(180))];
      _mImageView.contentMode = UIViewContentModeScaleAspectFill;
      _mImageView.layer.masksToBounds = YES;
      _mImageView.image = [UIImage imageNamed:@"MaskCopy"];
      [self addSubview:_mImageView];
      
      [[[SKServiceManager sharedInstance] topicService] getTopicNameListWithCallback:^(BOOL success, NSArray<SKTag *> *tagList) {
          self.dataArray = [NSMutableArray arrayWithArray:tagList];
          
          SDLabTagsView *sdTagsView =[SDLabTagsView sdLabTagsViewWithTagsArr:self.dataArray];
          sdTagsView.delegate = self;
          sdTagsView.frame =CGRectMake(0,_mImageView.bottom+ROUND_WIDTH_FLOAT(22+15),self.width,ROUND_WIDTH_FLOAT(100));
          [self addSubview:sdTagsView];
      }];
      
//      NSArray *array = @[@"#最美手账#", @"最萌摆拍小物", @"每天一张生活日常", @"好物分享"];
  }
  return self;
}

- (void)didClickTagAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(didClickTagAtIndex:)]) {
        [self.delegate didClickTagAtIndex:self.dataArray[index].id];
    }
}

@end
