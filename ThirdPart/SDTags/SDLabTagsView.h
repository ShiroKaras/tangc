//
//  SDLabTagsView.h
//  SDTagsView
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 slowdony. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDLabTagsView;

@protocol SDLabTagsViewDelegate <NSObject>
- (void)didClickTagAtIndex:(NSInteger)index;
@end

@interface SDLabTagsView : UIView
@property (nonatomic,strong)NSArray<SKTag*> *tagsArr;
@property (nonatomic, assign) id<SDLabTagsViewDelegate> delegate;
+(instancetype)sdLabTagsViewWithTagsArr:(NSArray<SKTag*> *)tagsArr;
@end
