//
//  SKUserInfoViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKUserInfoViewController.h"

@interface SKUserInfoViewController ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@end

@implementation SKUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    [self createTitleView];
    
    //头像
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 20+ROUND_WIDTH_FLOAT(44), self.view.width, ROUND_WIDTH_FLOAT(60))];
    view0.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view0];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), ROUND_WIDTH_FLOAT(10), ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40))];
    _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(20);
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.backgroundColor = COMMON_BG_COLOR;
    [view0 addSubview:_avatarImageView];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_personalpage_nextpage"]];
    arrow.right = view0.width-ROUND_WIDTH_FLOAT(18);
    arrow.centerY = view0.height/2;
    [view0 addSubview:arrow];
    
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"编辑头像";
    textLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
    textLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [textLabel sizeToFit];
    textLabel.right = arrow.left-ROUND_WIDTH_FLOAT(10);
    textLabel.centerY = view0.height/2;
    [view0 addSubview:textLabel];
    
    UIView *nickNameView = [self cellWithImageName:@"img_personalinformationpage_nickname" title:@"昵称" placeholderText:@"请输入昵称"];
    nickNameView.top = view0.bottom+ROUND_WIDTH_FLOAT(10);
    [self.view addSubview:nickNameView];
    
    UIView *sexView = [self cellWithImageName:@"img_personalinformationpage_sex" title:@"性别" placeholderText:@"请选择性别"];
    sexView.top = nickNameView.bottom;
    [self.view addSubview:sexView];
    
    UIView *birthdayView = [self cellWithImageName:@"img_personalinformationpage_birthday" title:@"生日" placeholderText:@"请选择日期"];
    birthdayView.top = sexView.bottom;
    [self.view addSubview:birthdayView];
    
    UIView *phoneView = [self cellWithImageName:@"img_personalinformationpage_phone" title:@"手机号" placeholderText:@"请输入手机号"];
    phoneView.top = birthdayView.bottom+ROUND_WIDTH_FLOAT(10);
    [self.view addSubview:phoneView];
    
    UIView *qqView = [self cellWithImageName:@"img_personalinformationpage_qq" title:@"QQ" placeholderText:@"请输入QQ号码"];
    qqView.top = phoneView.bottom;
    [self.view addSubview:qqView];
    
    UIView *cityView = [self cellWithImageName:@"img_personalinformationpage_city" title:@"城市" placeholderText:@"请选择城市"];
    cityView.top = qqView.bottom;
    [self.view addSubview:cityView];
}

- (void)createTitleView {
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, ROUND_WIDTH_FLOAT(44))];
    [self.view addSubview:titleBackView];
    
    UILabel *mTitleLabel = [UILabel new];
    mTitleLabel.text = @"个人信息";
    mTitleLabel.textColor = COMMON_TEXT_COLOR;
    mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [mTitleLabel sizeToFit];
    [titleBackView addSubview:mTitleLabel];
    mTitleLabel.centerX = titleBackView.width/2;
    mTitleLabel.centerY = titleBackView.height/2;
    
    UIButton *saveButton = [UIButton new];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    saveButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(15);
    [titleBackView addSubview:saveButton];
    saveButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(30), ROUND_WIDTH_FLOAT(21));
    saveButton.right = titleBackView.width -ROUND_WIDTH_FLOAT(15);
    saveButton.centerY = titleBackView.height/2;
}

- (UIImageView*)arrowImageView {
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_personalpage_nextpage"]];
    return arrow;
}

- (UIView *)cellWithImageName:(NSString *)imageName title:(NSString *)title placeholderText:(NSString *)placeholderText {
    UIView *cell = [UIView new];
    cell.backgroundColor = [UIColor whiteColor];
    cell.size = CGSizeMake(SCREEN_WIDTH, ROUND_WIDTH_FLOAT(44));
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    icon.left = 15;
    icon.centerY = cell.height/2;
    [cell addSubview:icon];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
    titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [titleLabel sizeToFit];
    titleLabel.left = icon.right+8;
    titleLabel.centerY = icon.centerY;
    [cell addSubview:titleLabel];
    
    UILabel *placeholderLabel = [UILabel new];
    placeholderLabel.text = placeholderText;
    placeholderLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
    placeholderLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [placeholderLabel sizeToFit];
    placeholderLabel.right = cell.right - ROUND_WIDTH_FLOAT(15);
    placeholderLabel.centerY = cell.height/2;
    [cell addSubview:placeholderLabel];
    
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), cell.height-0.5, cell.width-ROUND_WIDTH_FLOAT(30), 0.5)];
    underLine.backgroundColor = COMMON_BG_COLOR;
    [cell addSubview:underLine];
    
    return cell;
}
@end
