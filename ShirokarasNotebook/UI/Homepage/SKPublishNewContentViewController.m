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
@end

@implementation SKPublishNewContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    [self createTitleView];
    
    
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

@end
