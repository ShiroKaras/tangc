//
//  SKPublishNewContentViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPublishNewContentViewController.h"

@interface SKPublishNewContentViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textCountLabel;
@property (nonatomic, strong) UIView *buttonsBackView;
@end

@implementation SKPublishNewContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    [self createTitleView];
    
    //=========================文本部分=========================
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 20+ROUND_WIDTH_FLOAT(44+15), self.view.width-30, ROUND_WIDTH_FLOAT(105))];
    _textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    
    _textCountLabel = [UILabel new];
    _textCountLabel.text = @"200/200";
    _textCountLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
    _textCountLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
    [_textCountLabel sizeToFit];
    _textCountLabel.top = _textView.bottom+ROUND_WIDTH_FLOAT(15);
    _textCountLabel.right = _textView.right;
    [self.view addSubview:_textCountLabel];
    
    [[_textView.rac_textSignal filter:^BOOL(NSString *value) {
        return value;
    }]
     subscribeNext:^(NSString *x) {
         if (x.length>=140) {
             _textView.text = [x substringWithRange:NSMakeRange(0, 140)];
         }
         
         //更新字数
         _textCountLabel.text = [NSString stringWithFormat:@"%ld/200", x.length];
         [_textCountLabel sizeToFit];
         _textCountLabel.right = _textView.right;
         // 话题的规则
         NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
         // @的规则
         NSString *atPattern = @"\\@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
         
         NSString *pattern = [NSString stringWithFormat:@"%@|%@",topicPattern,atPattern];
         NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
         //匹配集合
         NSArray *results = [regex matchesInString:x options:0 range:NSMakeRange(0, x.length)];
         
         NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[x dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                            documentAttributes:nil error:nil];
         // 3.遍历结果
         for (NSTextCheckingResult *result in results) {
             NSLog(@"%@  %@",NSStringFromRange(result.range),[x substringWithRange:result.range]);
             //set font
             [attrStr addAttribute:NSFontAttributeName value:PINGFANG_FONT_OF_SIZE(14) range:NSMakeRange(0, x.length)];
             // 设置颜色
             [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
         }
         self.textView.attributedText = attrStr;
         _textView.font = PINGFANG_FONT_OF_SIZE(14);
     }];
    
    [self.view endEditing:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap)];
    [self.view addGestureRecognizer:tapGesture];
    
    //=========================图片组=========================
    
    float width = (SCREEN_WIDTH-ROUND_WIDTH_FLOAT(30+11))/3;
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        imageView.layer.cornerRadius = 3;
        imageView.backgroundColor = COMMON_GREEN_COLOR;
        [self.view addSubview:imageView];
        imageView.left = ROUND_WIDTH_FLOAT(15)+i*ROUND_WIDTH_FLOAT(93+5.5);
        imageView.top = _textCountLabel.bottom+ROUND_WIDTH_FLOAT(15);
    }
    
    //=========================按钮组=========================
    
    _buttonsBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-44, self.view.width, 44)];
    _buttonsBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_buttonsBackView];
    
    //监听键盘通知
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardWillShowNotification
      object:nil]
     subscribeNext:^(NSNotification *notification) {
         NSDictionary *info = [notification userInfo];
         NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
         CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
         _buttonsBackView.frame = CGRectMake(0, self.view.height - keyboardFrame.size.height - 44, self.view.width, 44);
     }];
    
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardWillHideNotification
      object:nil]
     subscribeNext:^(NSNotification *notification) {
         _buttonsBackView.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
     }];
    
    UIButton *topicButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [topicButton setImage:[UIImage imageNamed:@"btn_forwardpage_addtopic"] forState:UIControlStateNormal];
    [topicButton setImage:[UIImage imageNamed:@"btn_forwardpage_addtopic_highlight"] forState:UIControlStateHighlighted];
    topicButton.left = ROUND_WIDTH_FLOAT(8);
    topicButton.centerY = _buttonsBackView.height/2;
    [_buttonsBackView addSubview:topicButton];
    
    UIButton *repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [repeatButton setImage:[UIImage imageNamed:@"btn_forwardpage_remind"] forState:UIControlStateNormal];
    [repeatButton setImage:[UIImage imageNamed:@"btn_forwardpage_remind_highlight"] forState:UIControlStateHighlighted];
    repeatButton.left = topicButton.right+ ROUND_WIDTH_FLOAT(4);
    repeatButton.centerY = _buttonsBackView.height/2;
    [_buttonsBackView addSubview:repeatButton];
    
    UIButton *hideKeyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [hideKeyboardButton addTarget:self action:@selector(viewDidTap) forControlEvents:UIControlEventTouchUpInside];
    [hideKeyboardButton setImage:[UIImage imageNamed:@"btn_forwardpage_retract"] forState:UIControlStateNormal];
    [hideKeyboardButton setImage:[UIImage imageNamed:@"btn_forwardpage_retract_highlight"] forState:UIControlStateHighlighted];
    hideKeyboardButton.right = _buttonsBackView.width-8;
    hideKeyboardButton.centerY = _buttonsBackView.height/2;
    [_buttonsBackView addSubview:hideKeyboardButton];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createTitleView {
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, ROUND_WIDTH_FLOAT(44))];
    [self.view addSubview:titleBackView];
    
    UIButton *saveButton = [UIButton new];
    [saveButton setTitle:@"发布" forState:UIControlStateNormal];
    [saveButton setTitleColor:COMMON_TEXT_CONTENT_COLOR forState:UIControlStateNormal];
    saveButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(15);
    [titleBackView addSubview:saveButton];
    saveButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(30), ROUND_WIDTH_FLOAT(21));
    saveButton.right = titleBackView.width -ROUND_WIDTH_FLOAT(15);
    saveButton.centerY = titleBackView.height/2;
}

- (void)viewDidTap {
    [self.view endEditing:NO];
}

@end
