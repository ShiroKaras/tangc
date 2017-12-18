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
#import "SKPublishNewContentViewController.h"

@interface SKHomepageMorePicDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKComment*> *dataArray;
@property (nonatomic, strong) SKTopic *topic;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SKTitleBaseView *baseInfoView;
@property (nonatomic, strong) UITextView *articleView;
@property (nonatomic, strong) UIImageView *articleHeaderImageView;

@property (nonatomic, strong) UIButton *repeaterButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *favButton;

@property (nonatomic, strong) UIButton *delButton;

@end

@implementation SKHomepageMorePicDetailViewController {
    NSInteger     page;
    NSInteger     _totalPage;//总页数
    BOOL    isFirstCome; //第一次加载帖子时候不需要传入此关键字，当需要加载下一页时：需要传入加载上一页时返回值字段“maxtime”中的内容。
    BOOL    isJuhua;//是否正在下拉刷新或者上拉加载。default NO。
    
    BOOL isShowDelButton;
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
    float viewBottomHeight = kDevice_Is_iPhoneX?83:49;
    page = 1;
    _totalPage = 1;
    isFirstCome = YES;
    isJuhua = NO;
    self.dataArray = [NSMutableArray array];
    
    self.view.backgroundColor = COMMON_BG_COLOR;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?(64+22):64, self.view.width, self.view.height-(kDevice_Is_iPhoneX?(64+22):64)-viewBottomHeight) style:UITableViewStylePlain];
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
    
    [[[SKServiceManager sharedInstance] topicService] getArticleDetailWithArticleID:_topic.from.id!=0?_topic.from.id:_topic.id callback:^(BOOL success, SKTopic *topic) {
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
        
        //用户信息
        _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, backView.width, ROUND_WIDTH_FLOAT(60)) withTopic:self.topic];
        _baseInfoView.backgroundColor = [UIColor whiteColor];
        _baseInfoView.userInfo = _topic.from.id!=0?_topic.from.userinfo:_topic.userinfo;
        _baseInfoView.dateLabel.text = self.topic.add_time;
        [_baseInfoView.dateLabel sizeToFit];
        [backView addSubview:_baseInfoView];
        
        CGSize maxSize = CGSizeMake(ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(40));
        
        NSString *contentText = _topic.from.id!=0?_topic.from.content:_topic.content;
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
        
        NSArray *imagesArray = _topic.from.id!=0?_topic.from.images:_topic.images;
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
        
        //文章头图
        _articleHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ROUND_WIDTH_FLOAT(155))];
        _articleHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (self.topic.images.count >0) {
            [_articleHeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.topic.images[0]] placeholderImage:COMMON_PLACEHOLDER_IMAGE];
        }
        _articleHeaderImageView.layer.masksToBounds = YES;
        [self.headerView addSubview:_articleHeaderImageView];
        
        //用户信息
        _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, _articleHeaderImageView.bottom, _headerView.width, ROUND_WIDTH_FLOAT(60)) withTopic:self.topic];
        _baseInfoView.userInfo = _topic.from.id!=0?_topic.from.userinfo:_topic.userinfo;
        [self.headerView addSubview:_baseInfoView];
        _baseInfoView.dateLabel.text = self.topic.add_time;
        [_baseInfoView.dateLabel sizeToFit];
        _headerView.height = _baseInfoView.bottom;
        
        //文章
        _articleView = [[UITextView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), self.baseInfoView.bottom, self.view.frame.size.width-ROUND_WIDTH_FLOAT(30), 400)];
        _articleView.backgroundColor = [UIColor clearColor];
        // 获取html数据
        NSString *htmlString = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",_articleView.width,_topic.content];
        // 利用可变属性字符串来接收html数据
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        // 给textView赋值的时候就得用attributedText来赋了
        _articleView.attributedText = attributedString;
        _articleView.height = _articleView.contentSize.height;
        [self.headerView addSubview:_articleView];
        
        [self.tableView beginUpdates];
        self.headerView.height = self.baseInfoView.bottom+_articleView.contentSize.height;
        [self.tableView setTableHeaderView:self.headerView];
        [self.tableView endUpdates];
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
    
    //关注动作
    [[_baseInfoView.followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
            return;
        }
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
    
    float viewBottomHeight = kDevice_Is_iPhoneX?83:49;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-viewBottomHeight, self.view.width, viewBottomHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //转发
    _repeaterButton = [UIButton new];
    [_repeaterButton setImage:[UIImage imageNamed:@"btn_homepage_forward"] forState:UIControlStateNormal];
    [_repeaterButton setTitle:@"转发" forState:UIControlStateNormal];
    [_repeaterButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_repeaterButton setBackgroundImage:[UIImage imageWithColor:COMMON_HIGHLIGHT_BG_COLOR] forState:UIControlStateHighlighted];
    _repeaterButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    [_repeaterButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    _repeaterButton.size = CGSizeMake(self.view.width/3, 49);
    _repeaterButton.left = 0;
    _repeaterButton.top = 0;
    [view addSubview:_repeaterButton];
    //评论
    _commentButton = [UIButton new];
    [_commentButton setImage:[UIImage imageNamed:@"btn_homepage_comment"] forState:UIControlStateNormal];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_commentButton setBackgroundImage:[UIImage imageWithColor:COMMON_HIGHLIGHT_BG_COLOR] forState:UIControlStateHighlighted];
    _commentButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    _commentButton.size = CGSizeMake(self.view.width/3, 49);
    _commentButton.left = _repeaterButton.right;
    _commentButton.top = 0;
    [view addSubview:_commentButton];
    //点赞
    _favButton = [UIButton new];
    [_favButton setImage:self.topic.is_thumb?[UIImage imageNamed:@"btn_homepage_like_highlight"]:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
    [_favButton setTitle:@"赞" forState:UIControlStateNormal];
    [_favButton setTitleColor:[UIColor colorWithHex:0x6B827A] forState:UIControlStateNormal];
    [_favButton setBackgroundImage:[UIImage imageWithColor:COMMON_HIGHLIGHT_BG_COLOR] forState:UIControlStateHighlighted];
    _favButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    [_favButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    _favButton.size = CGSizeMake(self.view.width/3, 49);
    _favButton.left = _commentButton.right;
    _favButton.top = 0;
    [view addSubview:_favButton];
    
    //转发
    [[_repeaterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        SKPublishNewContentViewController *controller = [[SKPublishNewContentViewController alloc] initWithType:SKPublishTypeRepost withUserPost:self.topic];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //评论
    [[_commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        SKPublishNewContentViewController *controller = [[SKPublishNewContentViewController alloc] initWithType:SKPublishTypeComment withUserPost:self.topic];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //点赞
    [_favButton setImage:self.topic.is_thumb?[UIImage imageNamed:@"btn_homepage_like_highlight"]:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
    [[_favButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
            return;
        }
        if (self.topic.is_thumb) {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:self.topic.id callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"取消点赞");
                self.topic.is_thumb = 0;
                [_favButton setImage:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
            }];
        } else {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:self.topic.id callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"成功点赞");
                self.topic.is_thumb = 1;
                [_favButton setImage:[UIImage imageNamed:@"btn_homepage_like_highlight"] forState:UIControlStateNormal];
            }];
        }
    }];
    
    isShowDelButton = NO;
    
    UIButton *moreButton = [UIButton new];
    [moreButton setImage:[UIImage imageNamed:@"btn_detailpage_share"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"btn_detailpage_share_highlight"] forState:UIControlStateHighlighted];
    moreButton.size = CGSizeMake(44, 44);
    moreButton.top = 20;
    moreButton.right = self.view.right-10;
    [self.view addSubview:moreButton];
    [[moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (!isShowDelButton) {
            [UIView animateWithDuration:0.2 animations:^{
                _delButton.height = 44;
            } completion:^(BOOL finished) {
                isShowDelButton = YES;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                _delButton.height = 0;
            } completion:^(BOOL finished) {
                isShowDelButton = NO;
            }];
        }
    }];
    
    moreButton.hidden = ![[SKStorageManager sharedInstance].loginUser.nickname isEqualToString:self.topic.userinfo.nickname];
    
    _delButton = [UIButton new];
    _delButton.backgroundColor = COMMON_TEXT_COLOR;
    _delButton.layer.masksToBounds = YES;
    [_delButton setTitle:@"删除" forState:UIControlStateNormal];
    [_delButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _delButton.layer.cornerRadius = 5;
    _delButton.size = CGSizeMake(80, 0);
    _delButton.top = moreButton.bottom+5;
    _delButton.right = moreButton.right;
    [self.view addSubview:_delButton];
    [[_delButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.2 animations:^{
            _delButton.height = 0;
        } completion:^(BOOL finished) {
            isShowDelButton = NO;
        }];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"确认删除？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [[[SKServiceManager sharedInstance] topicService] deleteArticleWithArticleID:self.topic.id callback:^(BOOL success, SKResponsePackage *response) {
                                                                      if (response.errcode==0) {
                                                                          [self.navigationController popoverPresentationController];
                                                                      }
                                                                  }];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) { }];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
