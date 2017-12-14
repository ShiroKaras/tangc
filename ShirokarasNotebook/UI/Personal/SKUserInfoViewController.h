//
//  SKUserInfoViewController.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKUserInfoViewCell : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName withTitle:(NSString *)title placeholderText:(NSString*)placeholderText;
@end


@interface SKUserInfoViewController : UIViewController
@end
