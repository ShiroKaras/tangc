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

@interface CHTCollectionViewWaterfallHeader ()
@property (nonatomic,strong)NSMutableArray *dataArr;
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
      
      NSMutableArray<TagsModel*> *dataArray = [NSMutableArray array];
      NSArray *array = @[@"#最美手账#", @"最萌摆拍小物", @"每天一张生活日常", @"好物分享"];
      
      SDLabTagsView *sdTagsView =[SDLabTagsView sdLabTagsViewWithTagsArr:self.dataArr];
      sdTagsView.frame =CGRectMake(0,_mImageView.bottom+ROUND_WIDTH_FLOAT(22+15),self.width,ROUND_WIDTH_FLOAT(100));
      [self addSubview:sdTagsView];
  }
  return self;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr){
        NSString *path =[[NSBundle mainBundle ]pathForResource:@"tagsData.plist" ofType:nil];
        NSArray *dataArr =[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *tempArr =[NSMutableArray array];
        for (NSDictionary *dict in dataArr){
            TagsModel *model =[[TagsModel alloc]initWithTagsDict:dict];
            [tempArr addObject:model];
        }
        _dataArr =[tempArr copy];
    }
    return _dataArr;
}

@end
