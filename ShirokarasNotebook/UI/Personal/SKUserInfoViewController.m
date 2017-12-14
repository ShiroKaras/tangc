//
//  SKUserInfoViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKUserInfoViewController.h"
#import "UIViewController+ImagePicker.h"
#import "JFCityViewController.h"
#import <PGDatePicker/PGDatePicker.h>

typedef void (^SKUpdateCallback)(NSString *string);

@implementation SKUserInfoViewCell

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName withTitle:(NSString *)title placeholderText:(NSString*)placeholderText {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.size = CGSizeMake(SCREEN_WIDTH, ROUND_WIDTH_FLOAT(44));
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        icon.left = 15;
        icon.centerY = self.height/2;
        [self addSubview:icon];
        
        _titleLabel = [UILabel new];
        _titleLabel.text = title;
        _titleLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
        _titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [_titleLabel sizeToFit];
        _titleLabel.left = icon.right+8;
        _titleLabel.centerY = icon.centerY;
        [self addSubview:_titleLabel];
        
        _placeholderLabel = [UILabel new];
        _placeholderLabel.text = placeholderText;
        _placeholderLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
        _placeholderLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        _placeholderLabel.textAlignment = NSTextAlignmentRight;
        [_placeholderLabel sizeToFit];
        _placeholderLabel.width = ROUND_WIDTH_FLOAT(150);
        _placeholderLabel.right = self.right - ROUND_WIDTH_FLOAT(15);
        _placeholderLabel.centerY = self.height/2;
        [self addSubview:_placeholderLabel];
        
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), self.height-0.5, self.width-ROUND_WIDTH_FLOAT(30), 0.5)];
        underLine.backgroundColor = COMMON_BG_COLOR;
        [self addSubview:underLine];
    }
    return self;
}

@end


@interface SKUserInfoViewController () <JFCityViewControllerDelegate, PGDatePickerDelegate>
@property (nonatomic, strong) SKUserInfo *userInfo;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) SKUserInfoViewCell *nickNameView;
@property (nonatomic, strong) SKUserInfoViewCell *sexView;
@property (nonatomic, strong) SKUserInfoViewCell *birthdayView;
@property (nonatomic, strong) SKUserInfoViewCell *phoneView;
@property (nonatomic, strong) SKUserInfoViewCell *qqView;
@property (nonatomic, strong) SKUserInfoViewCell *cityView;
@end

@implementation SKUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userInfo = [SKUserInfo new];
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
    
    UITapGestureRecognizer *tap_avatar = [[UITapGestureRecognizer alloc] init];
    [[tap_avatar rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self presentSystemPhotoLibraryController];
    }];
    [view0 addGestureRecognizer:tap_avatar];
    
    
    self.nickNameView = [[SKUserInfoViewCell alloc] initWithFrame:CGRectZero imageName:@"img_personalinformationpage_nickname" withTitle:@"昵称" placeholderText:[SKStorageManager sharedInstance].userInfo.nickname];
    self.nickNameView.top = view0.bottom+ROUND_WIDTH_FLOAT(10);
    [self.view addSubview:self.nickNameView];
    UITapGestureRecognizer *tap_nickname = [[UITapGestureRecognizer alloc] init];
    [[tap_nickname rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self createTextViewWithView:self.nickNameView callback:^(NSString *string) {
            self.userInfo.nickname = string;
        }];
    }];
    [self.nickNameView addGestureRecognizer:tap_nickname];
    
    NSInteger sex = [[SKStorageManager sharedInstance].userInfo.sex integerValue];
    NSString *sexStr;
    switch (sex) {
        case 1:
            sexStr = @"男";
            break;
        case 2:
            sexStr = @"女";
            break;
        default:
            sexStr = @"请选择性别";
            break;
    }
    
    self.sexView = [[SKUserInfoViewCell alloc] initWithFrame:CGRectZero imageName:@"img_personalinformationpage_sex" withTitle:@"性别" placeholderText:sexStr];
    self.sexView.top = self.nickNameView.bottom;
    [self.view addSubview:self.sexView];
    UITapGestureRecognizer *tap_sex = [[UITapGestureRecognizer alloc] init];
    [[tap_sex rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self createSexViewWithView:self.sexView callback:^(NSString *string) {
            if ([string isEqualToString:@"1"]) {
                self.sexView.placeholderLabel.text = @"男";
            } else if ([string isEqualToString:@"2"]) {
                self.sexView.placeholderLabel.text = @"女";
            } else {
                self.sexView.placeholderLabel.text = @"请选择性别";
            }
        }];
    }];
    [self.sexView addGestureRecognizer:tap_sex];
    
    
    self.birthdayView = [[SKUserInfoViewCell alloc] initWithFrame:CGRectZero imageName:@"img_personalinformationpage_birthday" withTitle:@"生日" placeholderText:[SKStorageManager sharedInstance].userInfo.birthday==nil?@"请选择日期":[SKStorageManager sharedInstance].userInfo.birthday];
    self.birthdayView.top = self.sexView.bottom;
    [self.view addSubview:self.birthdayView];
    UITapGestureRecognizer *tap_birth = [[UITapGestureRecognizer alloc] init];
    [[tap_birth rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
        datePicker.maximumDate = [NSDate setYear:2017];
        datePicker.delegate = self;
        [datePicker show];
        datePicker.datePickerMode = PGDatePickerModeDate;
    }];
    [self.birthdayView addGestureRecognizer:tap_birth];
    
    self.phoneView = [[SKUserInfoViewCell alloc] initWithFrame:CGRectZero imageName:@"img_personalinformationpage_phone" withTitle:@"手机号" placeholderText:[SKStorageManager sharedInstance].userInfo.phone==nil?@"请输入手机号":[SKStorageManager sharedInstance].userInfo.phone];
    self.phoneView.top = self.birthdayView.bottom+ROUND_WIDTH_FLOAT(10);
    [self.view addSubview:self.phoneView];
    UITapGestureRecognizer *tap_phone = [[UITapGestureRecognizer alloc] init];
    [[tap_phone rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self createTextViewWithView:self.phoneView callback:^(NSString *string) {
            self.userInfo.phone = string;
        }];
    }];
    [self.phoneView addGestureRecognizer:tap_phone];
    
    self.qqView = [[SKUserInfoViewCell alloc] initWithFrame:CGRectZero imageName:@"img_personalinformationpage_qq" withTitle:@"QQ" placeholderText:[SKStorageManager sharedInstance].userInfo.qq==nil?@"请输入QQ号码":[SKStorageManager sharedInstance].userInfo.qq];
    self.qqView.top = self.phoneView.bottom;
    [self.view addSubview:self.qqView];
    UITapGestureRecognizer *tap_qq = [[UITapGestureRecognizer alloc] init];
    [[tap_qq rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self createTextViewWithView:self.qqView callback:^(NSString *string) {
            self.userInfo.qq = string;
        }];
    }];
    [self.qqView addGestureRecognizer:tap_qq];
    
    self.cityView = [[SKUserInfoViewCell alloc] initWithFrame:CGRectZero imageName:@"img_personalinformationpage_city" withTitle:@"城市" placeholderText:[SKStorageManager sharedInstance].userInfo.city==nil?@"请选择城市":[SKStorageManager sharedInstance].userInfo.city];
    self.cityView.top = self.qqView.bottom;
    [self.view addSubview:self.cityView];
    UITapGestureRecognizer *tap_city = [[UITapGestureRecognizer alloc] init];
    [[tap_city rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
        //  设置代理
        cityViewController.delegate = self;
        cityViewController.title = @"城市";
        //  给JFCityViewController添加一个导航控制器
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
    [self.cityView addGestureRecognizer:tap_city];
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[SKStorageManager sharedInstance].userInfo.avatar] placeholderImage:COMMON_AVATAR_PLACEHOLDER_IMAGE];
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
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[[SKServiceManager sharedInstance] profileService] updateUserInfoWithUserInfo:self.userInfo callback:^(BOOL success, SKUserInfo *userInfo) {
            
        }];
    }];
}

- (UIImageView*)arrowImageView {
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_personalpage_nextpage"]];
    return arrow;
}

- (void)createSexViewWithView:(SKUserInfoViewCell*)cell callback:(SKUpdateCallback)callback{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    [self.view addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha =0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [view addGestureRecognizer:tap];
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(200), ROUND_WIDTH_FLOAT(100))];
    textBackView.backgroundColor = [UIColor whiteColor];
    textBackView.layer.cornerRadius = 5;
    textBackView.centerX = view.width/2;
    textBackView.top = ROUND_WIDTH_FLOAT(150);
    [view addSubview:textBackView];
    
    UIButton *male = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40))];
    [male setTitle:@"男" forState:UIControlStateNormal];
    [male setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [male setBackgroundImage:[cell.placeholderLabel.text isEqualToString:@"男"]?[UIImage imageWithColor:COMMON_TEXT_PLACEHOLDER_COLOR] :[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    male.layer.cornerRadius = 5;
    male.layer.masksToBounds = YES;
    male.left = ROUND_WIDTH_FLOAT(30);
    male.top = ROUND_WIDTH_FLOAT(15);
    [textBackView addSubview:male];
    
    UIButton *female = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40))];
    [female setTitle:@"女" forState:UIControlStateNormal];
    [female setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [female setBackgroundImage:[cell.placeholderLabel.text isEqualToString:@"女"]?[UIImage imageWithColor:COMMON_TEXT_PLACEHOLDER_COLOR] :[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    female.layer.cornerRadius = 5;
    female.layer.masksToBounds = YES;
    female.right = textBackView.width -ROUND_WIDTH_FLOAT(30);
    female.top = ROUND_WIDTH_FLOAT(15);
    [textBackView addSubview:female];
    
    [[male rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.userInfo.sex = @"1";
        [male setBackgroundImage:[UIImage imageWithColor:COMMON_TEXT_PLACEHOLDER_COLOR] forState:UIControlStateNormal];
        [female setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }];
    
    [[female rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.userInfo.sex = @"2";
        [male setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [female setBackgroundImage:[UIImage imageWithColor:COMMON_TEXT_PLACEHOLDER_COLOR] forState:UIControlStateNormal];
    }];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, textBackView.height-ROUND_WIDTH_FLOAT(44), ROUND_WIDTH_FLOAT(100), ROUND_WIDTH_FLOAT(44))];
    [textBackView addSubview:okBtn];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [[okBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        callback(self.userInfo.sex);
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha =0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(100), textBackView.height-ROUND_WIDTH_FLOAT(44), ROUND_WIDTH_FLOAT(100), ROUND_WIDTH_FLOAT(44))];
    [textBackView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha =0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
}


- (void)createTextViewWithView:(SKUserInfoViewCell*)cell callback:(SKUpdateCallback)callback{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    [self.view addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha =0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [view addGestureRecognizer:tap];
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(200), ROUND_WIDTH_FLOAT(100))];
    textBackView.backgroundColor = [UIColor whiteColor];
    textBackView.layer.cornerRadius = 5;
    textBackView.centerX = view.width/2;
    textBackView.top = ROUND_WIDTH_FLOAT(150);
    [view addSubview:textBackView];
    
    UITextField *textfield = [UITextField new];
    textfield.placeholder = cell.placeholderLabel.text;
    textfield.left = ROUND_WIDTH_FLOAT(15);
    textfield.top = ROUND_WIDTH_FLOAT(15);
    textfield.width = ROUND_WIDTH_FLOAT(170);
    textfield.height = ROUND_WIDTH_FLOAT(44);
    [textBackView addSubview:textfield];
    [textfield becomeFirstResponder];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, textBackView.height-ROUND_WIDTH_FLOAT(44), ROUND_WIDTH_FLOAT(100), ROUND_WIDTH_FLOAT(44))];
    [textBackView addSubview:okBtn];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [[okBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        cell.placeholderLabel.text = textfield.text;
        callback(textfield.text);
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha =0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(100), textBackView.height-ROUND_WIDTH_FLOAT(44), ROUND_WIDTH_FLOAT(100), ROUND_WIDTH_FLOAT(44))];
    [textBackView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha =0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
}

#pragma mark - JFCityViewControllerDelegate

- (void)cityName:(NSString *)name {
    self.cityView.placeholderLabel.text = name;
    self.userInfo.city = name;
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    self.userInfo.birthday = [NSString stringWithFormat:@"%ld-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day];
    self.birthdayView.placeholderLabel.text = self.userInfo.birthday;
}

#pragma mark - Image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar"];
    [imageData writeToFile:imagePath atomically:YES];
    
    NSString *avatarKey = [NSString avatarName];
    
    [[[SKServiceManager sharedInstance] qiniuService] putData:imageData key:avatarKey token:[[SKStorageManager sharedInstance] qiniuPublicToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        DLog(@"data = %@, key = %@, resp = %@", info, key, resp);
        if (info.statusCode == 200) {
            _userInfo.avatar = [NSString qiniuDownloadURLWithFileName:key];
            [[[SKServiceManager sharedInstance] profileService] updateUserInfoWithUserInfo:self.userInfo callback:^(BOOL success, SKUserInfo *userInfo) {
                [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:COMMON_AVATAR_PLACEHOLDER_IMAGE];
            }];
        } else {
            
        }
    } option:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
