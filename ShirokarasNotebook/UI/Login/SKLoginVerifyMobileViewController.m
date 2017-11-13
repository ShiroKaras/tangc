//
//  SKLoginVerifyMobileViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/13.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKLoginVerifyMobileViewController.h"
#import "SKHomepageViewController.h"

@interface SKLoginVerifyMobileViewController ()

@end

@implementation SKLoginVerifyMobileViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //skip
    UIButton *button_skip = [UIButton new];
    [button_skip setTitle:@"跳过" forState:UIControlStateNormal];
    [button_skip setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button_skip.size = CGSizeMake(44, 44);
    button_skip.top = 20;
    button_skip.right = self.view.right -20;
    [self.view addSubview:button_skip];
    
    UILabel *kLabel = [UILabel new];
    kLabel.text = @"登录成功\n请绑定手机号";
    kLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(30);
    kLabel.numberOfLines = 2;
    [kLabel sizeToFit];
    kLabel.top = ROUND_HEIGHT_FLOAT(80);
    kLabel.left = ROUND_WIDTH_FLOAT(30);
    [self.view addSubview:kLabel];
    
    UITextField *mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, kLabel.bottom+32, self.view.width-60, 60)];
    mobileTextField.placeholder = @"请输入手机号";
    mobileTextField.textColor = COMMON_TEXT_2_COLOR;
    [mobileTextField setValue:COMMON_TEXT_2_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    mobileTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 60)];
    mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    mobileTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:mobileTextField];
    [mobileTextField becomeFirstResponder];
    
    UITextField *verifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, mobileTextField.bottom+10, self.view.width-60, 60)];
    verifyCodeTextField.placeholder = @"请输入验证码";
    verifyCodeTextField.textColor = COMMON_TEXT_2_COLOR;
    [verifyCodeTextField setValue:COMMON_TEXT_2_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    verifyCodeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 60)];
    verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:verifyCodeTextField];
    
    UIButton *button_getVerifyCode = [UIButton new];
    [button_getVerifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button_getVerifyCode setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button_getVerifyCode.backgroundColor = [UIColor lightGrayColor];
    button_getVerifyCode.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
    button_getVerifyCode.layer.cornerRadius = 15;
    button_getVerifyCode.size = CGSizeMake(90, 30);
    button_getVerifyCode.right = verifyCodeTextField.right;
    button_getVerifyCode.centerY = verifyCodeTextField.centerY;
    [self.view addSubview:button_getVerifyCode];
    
    UIButton *nextButton = [UIButton new];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"绑定" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor darkGrayColor];
    nextButton.layer.cornerRadius = ROUND_HEIGHT_FLOAT(25);
    nextButton.width = ROUND_WIDTH_FLOAT(220);
    nextButton.height = ROUND_HEIGHT_FLOAT(50);
    nextButton.centerX = self.view.centerX;
    nextButton.top = verifyCodeTextField.bottom +30;
    [self.view addSubview:nextButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)nextButtonClick:(UIButton *)sender {
    SKHomepageViewController *controller = [[SKHomepageViewController alloc] init];
    SKNavigationController *root = [[SKNavigationController alloc] initWithRootViewController:controller];
    AppDelegateInstance.window.rootViewController = root;
    [AppDelegateInstance.window makeKeyAndVisible];
}
@end
