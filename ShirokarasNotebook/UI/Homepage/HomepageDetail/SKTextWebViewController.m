//
//  SKTextWebViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/18.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTextWebViewController.h"

@interface SKTextWebViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) SKTopic *topic;
@end

@implementation SKTextWebViewController

- (instancetype)initWithTopic:(SKTopic*)topic;
{
    self = [super init];
    if (self) {
        self.topic = topic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400)];
    // 设置textView边框宽度和颜色
    self.textView.layer.borderWidth = 2.0f;
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    
    // 获取html数据
    NSString *htmlString = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",self.textView.width,_topic.content];
    
    // 利用可变属性字符串来接收html数据
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    // 给textView赋值的时候就得用attributedText来赋了
    self.textView.attributedText = attributedString;
    NSLog(@"contentSize: %@", NSStringFromCGSize(self.textView.contentSize));
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
