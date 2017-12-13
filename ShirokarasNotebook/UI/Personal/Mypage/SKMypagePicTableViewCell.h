//
//  SKMypagePicTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKMypagePicTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray<UIImage*> *imageViewArray;
@property (nonatomic, strong) UIImageView *imageView0;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;

@property (nonatomic, strong) UILabel *countLabel0;
@property (nonatomic, strong) UILabel *countLabel1;
@property (nonatomic, strong) UILabel *countLabel2;

@property (nonatomic, assign) float cellHeight;
@end
