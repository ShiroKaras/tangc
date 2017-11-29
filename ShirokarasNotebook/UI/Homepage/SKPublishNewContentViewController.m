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
@end

@implementation SKPublishNewContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    [self createTitleView];
    
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 300, 300)];
    _textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    [[_textView.rac_textSignal filter:^BOOL(NSString *value) {
        return value;
    }]
     subscribeNext:^(NSString *x) {
         // 话题的规则
         NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
         // @的规则
         NSString *atPattern = @"\\@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
         
         NSString *pattern = [NSString stringWithFormat:@"%@|%@",topicPattern,atPattern];
         NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
         //匹配集合
         NSArray *results = [regex matchesInString:x options:0 range:NSMakeRange(0, x.length)];
         // 3.遍历结果
         for (NSTextCheckingResult *result in results) {
             NSLog(@"%@  %@",NSStringFromRange(result.range),[x substringWithRange:result.range]);
             NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[x dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
             // 设置颜色
             [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
             self.textView.attributedText = attrStr;
         }
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
