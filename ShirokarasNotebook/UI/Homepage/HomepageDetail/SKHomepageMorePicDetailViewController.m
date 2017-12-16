//
//  SKHomepageMorePicDetailViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/14.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKHomepageMorePicDetailViewController.h"
#import "SKHomepageDetaillTableViewCell.h"
#import "SKTitleBaseView.h"
#import "HTWebController.h"

@interface SKHomepageMorePicDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKComment*> *dataArray;
@property (nonatomic, strong) SKTopic *topic;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SKTitleBaseView *baseInfoView;
@property (nonatomic, strong) UIWebView *articleView;
@property (nonatomic, strong) UIImageView *articleHeaderImageView;
@end

@implementation SKHomepageMorePicDetailViewController {
    NSInteger     page;
    NSInteger     _totalPage;//总页数
    BOOL    isFirstCome; //第一次加载帖子时候不需要传入此关键字，当需要加载下一页时：需要传入加载上一页时返回值字段“maxtime”中的内容。
    BOOL    isJuhua;//是否正在下拉刷新或者上拉加载。default NO。
}

- (instancetype)initWithTopic:(SKTopic*)topic {
    self = [super init];
    if (self) {
        _topic = topic;
    }
    return self;
}

- (instancetype)initWithArticleID:(NSInteger)articleID {
    self = [super init];
    if (self) {
        _topic = [SKTopic new];
        _topic.id = articleID;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    _totalPage = 1;
    isFirstCome = YES;
    isJuhua = NO;
    self.dataArray = [NSMutableArray array];
    
    self.view.backgroundColor = COMMON_BG_COLOR;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?(64+22):64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[SKHomepageDetaillTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    [self.view addSubview:_tableView];
    
#ifdef __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
#endif
    
    [[[SKServiceManager sharedInstance] topicService] getArticleDetailWithArticleID:_topic.from?_topic.from.id:_topic.id callback:^(BOOL success, SKTopic *topic) {
        self.topic = topic;
        [self createUI];
    }];
    [[[SKServiceManager sharedInstance] topicService] getCommentListWithArticleID:self.topic.id page:1 pagesize:10 callback:^(BOOL success, NSArray<SKComment *> *commentList, NSInteger totalPage) {
        _totalPage = totalPage;
        self.dataArray = [NSMutableArray arrayWithArray:commentList];
        [self.tableView reloadData];
    }];
}

- (void)createUI {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(220))];
    self.headerView.backgroundColor = [UIColor clearColor];
    
    if (self.topic.type == SKHomepageDetailTypeOnePic || self.topic.type == SKHomepageDetailTypeMorePic) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.width-10, self.headerView.height-ROUND_WIDTH_FLOAT(20))];
        backView.backgroundColor = [UIColor whiteColor];
        [self.headerView addSubview:backView];
        _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, backView.width, ROUND_WIDTH_FLOAT(60))];
        _baseInfoView.backgroundColor = [UIColor whiteColor];
        _baseInfoView.userInfo = _topic.from?_topic.from.userinfo:_topic.userinfo;
        [backView addSubview:_baseInfoView];
        
        CGSize maxSize = CGSizeMake(ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(40));
        
        NSString *contentText = _topic.from?_topic.from.content:_topic.content;
        UILabel *contentLabel = [UILabel new];
        contentLabel.text = contentText;
        contentLabel.textColor = COMMON_TEXT_COLOR;
        contentLabel.numberOfLines = 2;
        contentLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        CGSize labelSize = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(12)} context:nil].size;
        contentLabel.size = labelSize;
        contentLabel.top = _baseInfoView.bottom;
        contentLabel.left = ROUND_WIDTH_FLOAT(15);
        [backView addSubview:contentLabel];
        
        NSArray *imagesArray = _topic.from?_topic.from.images:_topic.images;
        float width = (SCREEN_WIDTH-ROUND_WIDTH_FLOAT(30+11))/3;
        for (int i=0; i<imagesArray.count; i++) {
            int j = i%3;
            int k = floor(i/3);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagesArray[i]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 3;
            [backView addSubview:imageView];
            imageView.left = ROUND_WIDTH_FLOAT(15)+j*ROUND_WIDTH_FLOAT(93+5.5);
            imageView.top = k*(ROUND_WIDTH_FLOAT(5.5)+ROUND_WIDTH_FLOAT(93+5.5)) +contentLabel.bottom+ROUND_WIDTH_FLOAT(15);
            
            self.headerView.height = imageView.bottom +ROUND_WIDTH_FLOAT(56);
            backView.height = self.headerView.height-ROUND_WIDTH_FLOAT(20);
        }
    } else if (self.topic.type == SKHomepageDetailTypeArticle) {
        self.tableView.top = 0;
        self.tableView.height = self.view.height-10;
        
        _articleHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ROUND_WIDTH_FLOAT(155))];
        [_articleHeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.topic.images[0]] placeholderImage:COMMON_PLACEHOLDER_IMAGE];
        _articleHeaderImageView.layer.masksToBounds = YES;
        [self.headerView addSubview:_articleHeaderImageView];
        
        _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, _articleHeaderImageView.bottom, _headerView.width, ROUND_WIDTH_FLOAT(60))];
        _baseInfoView.userInfo = _topic.from?_topic.from.userinfo:_topic.userinfo;
        [self.headerView addSubview:_baseInfoView];
        _headerView.height = _baseInfoView.bottom;
        
        _articleView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _articleHeaderImageView.bottom, self.view.width, 300)];
        _articleView.delegate = self;
        _articleView.opaque = NO;
        _articleView.backgroundColor = [UIColor clearColor];
        _articleView.dataDetectorTypes = UIDataDetectorTypeNone;
        _articleView.scrollView.backgroundColor = [UIColor clearColor];
        NSString *htmlString = [self htmlStringWithContent:self.topic.content];
        [_articleView loadHTMLString:htmlString baseURL:nil];
        //        NSString *padding = @"document.body.style.padding='6px 13px 0px 13px';";
        //        [_articleView stringByEvaluatingJavaScriptFromString:padding];
        [self.headerView addSubview:_articleView];
    }
    
    self.tableView.tableHeaderView = self.headerView;
    
    //加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [[[SKServiceManager sharedInstance] topicService] getCommentListWithArticleID:self.topic.id page:page pagesize:10 callback:^(BOOL success, NSArray<SKComment *> *commentList, NSInteger totalPage) {
            _totalPage = totalPage;
            if (page>totalPage) {
                page = totalPage;
                return;
            }
            for (int i=0; i<commentList.count; i++) {
                [self.dataArray addObject:commentList[i]];
            }
            [self.tableView reloadData];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
    
    [_articleView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    //关注动作
    [[_baseInfoView.followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.topic.is_follow) {
            [[[SKServiceManager sharedInstance] profileService] unFollowsUserID:[NSString stringWithFormat:@"%ld", (long)self.topic.userinfo.id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"取消关注");
                    self.topic.is_follow = 0;
                    [_baseInfoView.followButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_follow"] forState:UIControlStateNormal];
                }
            }];
        } else {
            [[[SKServiceManager sharedInstance] profileService] doFollowsUserID:[NSString stringWithFormat:@"%ld", (long)self.topic.userinfo.id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"成功关注");
                    self.topic.is_follow = 1;
                    [_baseInfoView.followButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_follow_highlight"] forState:UIControlStateNormal];
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize fittingSize = [_articleView sizeThatFits:CGSizeZero];
        NSLog(@"WebSize(Observer): %@", NSStringFromCGSize(fittingSize));
        _articleView.frame = CGRectMake(0, self.baseInfoView.bottom, fittingSize.width, fittingSize.height);
        [self.tableView beginUpdates];
        self.headerView.height = self.baseInfoView.bottom+fittingSize.height;
        [self.tableView setTableHeaderView:self.headerView];
        [self.tableView endUpdates];
    }
}

- (NSString *)htmlStringWithContent:(NSString *)content {
    
    NSString *css =[NSString stringWithFormat:@"<html> \n"
                    "<head> \n"
                    "<style type=\"text/css\"> \n"
                    "a{text-decoration: none;\n}"
                    "</style> \n"
                    "</head> \n"
                    "<body font-family: '-apple-system','PingFangSC-Regular'; style=\"line-height:21px; font-size:14px\" text=\"#1F4035\" bgcolor=\"#FFFFFF\">\n"
                    "<span style=\"font-family: \'-apple-system\',\'PingFangSC-Regular\';\">%@</span> \n"
                    "</body> \n"
                    "<span style=\"font-family: \'-apple-system\',\'PingFangSC-Regular\';\"> \n"
                    
                    "</html>",self.topic.content];
    
    NSString *htmlString = css;
    return htmlString;
}

#pragma mark - WebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    NSLog(@"WebSize(didFinishLoad): %@", NSStringFromCGSize(fittingSize));
    webView.frame = CGRectMake(0, self.baseInfoView.bottom, fittingSize.width, fittingSize.height);
    [self.tableView beginUpdates];
    self.headerView.height = self.baseInfoView.bottom+fittingSize.height;
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView endUpdates];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageDetaillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    if (cell==nil) {
        cell = [[SKHomepageDetaillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    }
    cell.comment = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageDetaillTableViewCell *cell = (SKHomepageDetaillTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(37))];
    headerView.backgroundColor = [UIColor clearColor];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 30)];
//    view.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:view];
//    //指定圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = view.bounds;
//    maskLayer.path = maskPath.CGPath;
//    view.layer.mask = maskLayer;

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [NSString stringWithFormat:@"评论（%ld）", self.dataArray.count];
    titleLabel.textColor = COMMON_TEXT_COLOR;
    titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [titleLabel sizeToFit];
    titleLabel.left = 10;
    titleLabel.centerY = 15;
    [headerView addSubview:titleLabel];
    return headerView;
}

#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
