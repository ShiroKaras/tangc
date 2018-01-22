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
#import "SKThumbTableViewCell.h"

#define CELL_WIDTH (SCREEN_WIDTH)

typedef NS_ENUM(NSInteger, SKDetailListType) {
    SKDetailListTypeComment,
    SKDetailListTypeThumb
};

@interface SKHomepageMorePicDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKComment*> *dataArray_comment;
@property (nonatomic, strong) NSMutableArray<SKUserInfo*> *dataArray_thumb;
@property (nonatomic, strong) SKTopic *topic;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SKTitleBaseView *baseInfoView;

@property (nonatomic, strong) UIButton *repeaterButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *favButton;

@property (nonatomic, strong) UIButton *delButton;

@property (nonatomic, strong) UILabel *repostLabel;
@property (nonatomic, strong) UIView *baseContentView;
@property (nonatomic, strong) UIView *underLine;
//OnePic
@property (nonatomic, strong) UIImageView *imageViewOnePic;
//MorePic
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) NSArray<NSString*>* imageUrlArray;
//Article
@property (nonatomic, strong) UIImageView *articleHeaderImageView;  //原创头图
@property (nonatomic, strong) UILabel *articleTitleLabel;           //原创标题
@property (nonatomic, strong) UITextView *articleView;              //原创正文
@property (nonatomic, strong) UIImageView *imageViewArticle;        //转发头图
@property (nonatomic, strong) UILabel *articleLabel;                //转发标题

@property (nonatomic, strong) UIView *pointView;

@property (nonatomic, assign) SKDetailListType listType;

@property (nonatomic, strong) HTBlankView *blankView;
@end

@implementation SKHomepageMorePicDetailViewController {
    NSInteger     page;
    NSInteger     _totalPage;//总页数
    BOOL    isFirstCome; //第一次加载帖子时候不需要传入此关键字，当需要加载下一页时：需要传入加载上一页时返回值字段“maxtime”中的内容。
    BOOL    isJuhua;//是否正在下拉刷新或者上拉加载。default NO。
    
    BOOL isShowDelButton;
    BOOL isShowNoMessage;
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

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"listType"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[SKServiceManager sharedInstance] topicService] getArticleDetailWithArticleID:_topic.id callback:^(BOOL success, SKTopic *topic) {
        self.topic = topic;
        [self createUI];
        self.listType = SKDetailListTypeComment;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    float viewBottomHeight = kDevice_Is_iPhoneX?83:49;
    page = 1;
    _totalPage = 1;
    isFirstCome = YES;
    isJuhua = NO;
    
    _blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoComment];
    _blankView.centerX = SCREEN_WIDTH/2;
    
    [self createTitleView];
    
    self.dataArray_comment = [NSMutableArray array];
    self.dataArray_thumb = [NSMutableArray array];
    [self addObserver:self forKeyPath:@"listType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.view.backgroundColor = COMMON_BG_COLOR;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ((kDevice_Is_iPhoneX?44:20)+ROUND_WIDTH_FLOAT(44)), self.view.width, self.view.height-((kDevice_Is_iPhoneX?44:20)+ROUND_WIDTH_FLOAT(44))-viewBottomHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[SKHomepageDetaillTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    [self.tableView registerClass:[SKThumbTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKThumbTableViewCell class])];
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
}

- (void)createTitleView {
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?44:20, 200, ROUND_WIDTH_FLOAT(44))];
    tView.backgroundColor = [UIColor clearColor];
    tView.centerX = self.view.centerX;
    [self.view addSubview:tView];
    
    UILabel *mTitleLabel = [UILabel new];
    mTitleLabel.text = @"正文";
    mTitleLabel.textColor = COMMON_TEXT_COLOR;
    mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [mTitleLabel sizeToFit];
    [tView addSubview:mTitleLabel];
    mTitleLabel.centerX = tView.width/2;
    mTitleLabel.centerY = tView.height/2;
}


- (void)createUI {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(220))];
    self.headerView.backgroundColor = [UIColor clearColor];
    
    //原创
    if (self.topic.from.id==0) {
        if (self.topic.type == SKHomepageDetailTypeOnePic || self.topic.type == SKHomepageDetailTypeMorePic) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.width, self.headerView.height-ROUND_WIDTH_FLOAT(20))];
            backView.backgroundColor = [UIColor whiteColor];
            [self.headerView addSubview:backView];
            
            //用户信息
            _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, backView.width, ROUND_WIDTH_FLOAT(60)) withTopic:self.topic];
            _baseInfoView.backgroundColor = [UIColor whiteColor];
            _baseInfoView.userInfo = _topic.from.id!=0?_topic.from.userinfo:_topic.userinfo;
            _baseInfoView.dateLabel.text = self.topic.add_time;
            [_baseInfoView.dateLabel sizeToFit];
            [backView addSubview:_baseInfoView];
            
            CGSize maxSize = CGSizeMake(ROUND_WIDTH_FLOAT(290), MAXFLOAT);
            
            NSString *contentText = _topic.from.id!=0?_topic.from.content:_topic.content;
            UILabel *contentLabel = [UILabel new];
            contentLabel.text = contentText;
            [self regxWithContent:contentText label:contentLabel];
            contentLabel.numberOfLines = 0;
            CGSize labelSize = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
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
                [self showPicWithImageView:imageView url:[NSURL URLWithString:imagesArray[i]]];
                
                self.headerView.height = imageView.bottom +ROUND_WIDTH_FLOAT(56);
                backView.height = self.headerView.height-ROUND_WIDTH_FLOAT(20);
            }
        } else if (self.topic.type == SKHomepageDetailTypeArticle) {
            self.tableView.top = 0;
            self.tableView.height = self.view.height-10;
            self.tableView.backgroundColor = COMMON_BG_COLOR;
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
            
            //文章标题
            _articleTitleLabel = [UILabel new];
            _articleTitleLabel.text = self.topic.title;
            _articleTitleLabel.textColor = COMMON_TEXT_COLOR;
            _articleTitleLabel.numberOfLines = 2;
            CGSize labelSize = [self.topic.title boundingRectWithSize:CGSizeMake(ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(60)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(18)} context:nil].size;
            _articleTitleLabel.size = labelSize;
            _articleTitleLabel.width = ROUND_WIDTH_FLOAT(290);
            _articleTitleLabel.left = ROUND_WIDTH_FLOAT(15);
            _articleTitleLabel.top = _baseInfoView.bottom +ROUND_WIDTH_FLOAT(5);
            [self.headerView addSubview:_articleTitleLabel];
            
            //文章
            _articleView = [[UITextView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), _articleTitleLabel.bottom, self.view.frame.size.width-ROUND_WIDTH_FLOAT(30), 400)];
            _articleView.backgroundColor = [UIColor clearColor];
            // 获取html数据
            NSString *htmlString = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",_articleView.width,_topic.content];

            // 利用可变属性字符串来接收html数据
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:7];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSFontAttributeName value:PINGFANG_FONT_OF_SIZE(14) range:NSMakeRange(0, [attributedString length])];
            
            // 给textView赋值的时候就得用attributedText来赋了
            _articleView.attributedText = attributedString;
            
            _articleView.height = _articleView.contentSize.height;
            [self.headerView addSubview:_articleView];
            
            [self.tableView beginUpdates];
            self.headerView.height = self.baseInfoView.bottom+_articleView.contentSize.height;
            [self.tableView setTableHeaderView:self.headerView];
            [self.tableView endUpdates];
        }
    }
    //转发
    else {
        CGSize maxSize = CGSizeMake(ROUND_WIDTH_FLOAT(290), MAXFLOAT);
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.width-10, self.headerView.height-ROUND_WIDTH_FLOAT(20))];
        backView.backgroundColor = [UIColor whiteColor];
        [self.headerView addSubview:backView];
        
        //按钮、内容的透明分割线
        _underLine = [UIView new];
        [backView addSubview:_underLine];
        _underLine.backgroundColor = [UIColor clearColor];
        _underLine.size = CGSizeMake(self.view.width -20, 0.5);
        _underLine.left = 10;
        
        //用户信息
        _baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, backView.width, ROUND_WIDTH_FLOAT(60)) withTopic:self.topic];
        _baseInfoView.backgroundColor = [UIColor whiteColor];
        _baseInfoView.userInfo = self.topic.userinfo;
        _baseInfoView.dateLabel.text = self.topic.add_time;
        [_baseInfoView.dateLabel sizeToFit];
        [backView addSubview:_baseInfoView];
        
        _repostLabel = [UILabel new];
        _repostLabel.text = self.topic.content;
        [self regxWithContent:self.topic.content label:_repostLabel];
        //        _repostLabel.textColor = COMMON_TEXT_COLOR;
        //        _repostLabel.numberOfLines = 0;
        _repostLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
        CGSize labelSize = [self.topic.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
        _repostLabel.size = labelSize;
        _repostLabel.left = ROUND_WIDTH_FLOAT(15);
        _repostLabel.top = _baseInfoView.bottom;
        [backView addSubview:_repostLabel];
        
        _baseContentView = [[UIView alloc] initWithFrame:CGRectMake(0, _repostLabel.bottom+ROUND_WIDTH_FLOAT(15), SCREEN_WIDTH, 0)];
        _baseContentView.backgroundColor = COMMON_HIGHLIGHT_BG_COLOR;
        [backView addSubview:_baseContentView];
        
        UILabel *oriNameLabel = [UILabel new];
        oriNameLabel.text = [NSString stringWithFormat:@"@%@", self.topic.from.userinfo.nickname];
        oriNameLabel.textColor = COMMON_TEXT_COLOR;
        oriNameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [oriNameLabel sizeToFit];
        oriNameLabel.top = _baseContentView.top +ROUND_WIDTH_FLOAT(15);
        oriNameLabel.left = ROUND_WIDTH_FLOAT(15);
        [backView addSubview:oriNameLabel];
        
        switch (self.topic.from.type) {
            case SKHomepageDetailTypeOnePic:{
                _imageViewOnePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, _repostLabel.bottom+ROUND_WIDTH_FLOAT(15)+ROUND_WIDTH_FLOAT(42), self.view.width-30, (self.view.width-30)/4*3)];
                _imageViewOnePic.layer.cornerRadius = 3;
                _imageViewOnePic.layer.masksToBounds = YES;
                _imageViewOnePic.contentMode = UIViewContentModeScaleAspectFill;
                if (self.topic.from.images.count>0) {
                    [_imageViewOnePic sd_setImageWithURL:[NSURL URLWithString:self.topic.from.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                }
                [backView addSubview:_imageViewOnePic];
                [self showPicWithImageView:_imageViewOnePic url:self.topic.from.images[0]];
                
                _introduceLabel = [UILabel new];
                _introduceLabel.text = self.topic.from.content;
                [self regxWithContent:self.topic.from.content label:_introduceLabel];
                //                _introduceLabel.textColor = COMMON_TEXT_COLOR;
                //                _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
                _introduceLabel.numberOfLines = 0;
                CGSize labelSize = [self.topic.from.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                _introduceLabel.size = labelSize;
                _introduceLabel.top = _imageViewOnePic.bottom+15;
                _introduceLabel.left = 15;
                [backView addSubview:_introduceLabel];
                
                _underLine.top = _introduceLabel.bottom+10;
                break;
            }
            case SKHomepageDetailTypeMorePic:{
                UIScrollView *scrollView = [UIScrollView new];
                scrollView.backgroundColor = [UIColor clearColor];
                scrollView.top = _repostLabel.bottom+ROUND_WIDTH_FLOAT(15)+ROUND_WIDTH_FLOAT(42);
                scrollView.left = 15;
                scrollView.size = CGSizeMake(CELL_WIDTH-30, ROUND_WIDTH_FLOAT(121));
                scrollView.contentSize = CGSizeMake(self.topic.from.images.count*ROUND_WIDTH_FLOAT(129)-ROUND_WIDTH_FLOAT(8), ROUND_WIDTH_FLOAT(121));
                scrollView.showsVerticalScrollIndicator = NO;
                scrollView.showsHorizontalScrollIndicator = NO;
                [backView addSubview:scrollView];
                
                //添加图片
                for (int i=0; i<self.topic.from.images.count; i++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(129)*i, 0, ROUND_WIDTH_FLOAT(121), ROUND_WIDTH_FLOAT(121))];
                    imageView.tag = 100+i;
                    imageView.layer.cornerRadius = 3;
                    imageView.layer.masksToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    if (self.topic.from.images.count > 0) {
                        [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.from.images[i]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                    }
                    [scrollView addSubview:imageView];
                    [self showPicWithImageView:imageView url:self.topic.from.images[i]];
                }
                
                //文字介绍
                _introduceLabel = [UILabel new];
                _introduceLabel.text = self.topic.from.content;
                [self regxWithContent:self.topic.from.content label:_introduceLabel];
                //                _introduceLabel.textColor = COMMON_TEXT_COLOR;
                //                _introduceLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
                _introduceLabel.numberOfLines = 0;
                CGSize labelSize = [self.topic.from.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                _introduceLabel.size = labelSize;
                _introduceLabel.top = scrollView.bottom+15;
                _introduceLabel.left = 15;
                [backView addSubview:_introduceLabel];
                
                _underLine.top = _introduceLabel.bottom+10;
                break;
            }
            case SKHomepageDetailTypeArticle:{
                _imageViewArticle = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), _repostLabel.bottom+ROUND_WIDTH_FLOAT(15)+ROUND_WIDTH_FLOAT(42), ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(150))];
                _imageViewArticle.contentMode = UIViewContentModeScaleAspectFill;
                _imageViewArticle.layer.cornerRadius = 5;
                _imageViewArticle.layer.masksToBounds = YES;
                if (self.topic.from.images.count>0) {
                    [_imageViewArticle sd_setImageWithURL:[NSURL URLWithString:self.topic.from.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
                }
                [backView addSubview:_imageViewArticle];
                
                UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageViewArticle.width, _imageViewArticle.height)];
                alphaView.backgroundColor = [UIColor colorWithHex:0x3b3b3b alpha:0.6];
                [_imageViewArticle addSubview:alphaView];
                
                _articleLabel = [UILabel new];
                _articleLabel.text = self.topic.from.title;
                _articleLabel.textColor = [UIColor whiteColor];
                _articleLabel.numberOfLines = 0;
                CGSize labelSize = [self.topic.title boundingRectWithSize:CGSizeMake(ROUND_WIDTH_FLOAT(270), ROUND_WIDTH_FLOAT(60)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14)} context:nil].size;
                _articleLabel.size = labelSize;
                _articleLabel.width = ROUND_WIDTH_FLOAT(270);
                _articleLabel.left = _imageViewArticle.left+ROUND_WIDTH_FLOAT(10);
                _articleLabel.bottom = _imageViewArticle.bottom-ROUND_WIDTH_FLOAT(10);
                [backView addSubview:_articleLabel];
                
                UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_label_article"]];
                view.size = CGSizeMake(ROUND_WIDTH_FLOAT(38), ROUND_WIDTH_FLOAT(19));
                view.right = _imageViewArticle.width;
                view.top = 30;
                [_imageViewArticle addSubview:view];
                
                UIButton *enterArticle = [[UIButton alloc] initWithFrame:_imageViewArticle.frame];
                [backView addSubview:enterArticle];
                [[enterArticle rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    SKHomepageMorePicDetailViewController *c = [[SKHomepageMorePicDetailViewController alloc] initWithTopic:self.topic.from];
                    [self.navigationController pushViewController:c animated:YES];
                }];
                
                _underLine.top = _imageViewArticle.bottom+8;
                break;
            }
            default:
                break;
        }
        _baseContentView.height = _underLine.bottom-_repostLabel.bottom-ROUND_WIDTH_FLOAT(15);
        self.headerView.height = _baseContentView.bottom + ROUND_WIDTH_FLOAT(20);
    }
    self.tableView.tableHeaderView = self.headerView;
    
    //加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        if (_listType==SKDetailListTypeComment) {
            [[[SKServiceManager sharedInstance] topicService] getCommentListWithArticleID:self.topic.id page:page pagesize:10 callback:^(BOOL success, NSArray<SKComment *> *commentList, NSInteger totalPage) {
                _totalPage = totalPage;
                if (page>totalPage) {
                    page = totalPage;
                    return;
                }
                for (int i=0; i<commentList.count; i++) {
                    [self.dataArray_comment addObject:commentList[i]];
                }
                [self.tableView reloadData];
            }];
        } else if (_listType == SKDetailListTypeThumb) {
            [[[SKServiceManager sharedInstance] topicService] getThumbListWithArticleID:self.topic.id page:page pagesize:10 callback:^(BOOL success, NSArray<SKUserInfo *> *list, NSInteger totalPage) {
                _totalPage = totalPage;
                if (page>totalPage) {
                    page = totalPage;
                    return;
                }
                for (int i=0; i<list.count; i++) {
                    [self.dataArray_thumb addObject:list[i]];
                }
                [self.tableView reloadData];
            }];
        }
        
        
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
    _repeaterButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
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
    _commentButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
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
    _favButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [_favButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    _favButton.size = CGSizeMake(self.view.width/3, 49);
    _favButton.left = _commentButton.right;
    _favButton.top = 0;
    [view addSubview:_favButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = COMMON_SEPARATOR_COLOR;
    [view addSubview:line];
    
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
    moreButton.top = kDevice_Is_iPhoneX?44:20;
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


- (void)regxWithContent:(NSString*)content label:(UILabel*)label {
    if (label.text == nil) {
        return;
    }
    
    // 话题的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // @的规则
    NSString *atPattern = @"\\@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@",topicPattern,atPattern];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    //匹配集合
    NSArray *results = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                  options:@{NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType}
                                                                       documentAttributes:nil error:nil];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        // 设置颜色
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x417DC1] range:result.range];
    }
    //set font
    [attrStr addAttribute:NSFontAttributeName value:PINGFANG_ROUND_FONT_OF_SIZE(14) range:NSMakeRange(0, content.length)];
    label.attributedText = attrStr;
}

- (void)showPicWithImageView:(UIImageView*)mImageView url:(NSURL*)url {
    mImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.backgroundColor = [UIColor colorWithHex:0x000000];
        view.userInteractionEnabled = YES;
        [KEY_WINDOW addSubview:view];
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ROUND_HEIGHT_FLOAT(22), ROUND_WIDTH_FLOAT(22), SCREEN_WIDTH-ROUND_WIDTH_FLOAT(44), SCREEN_HEIGHT-ROUND_HEIGHT_FLOAT(44))];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        [imageView sd_setImageWithURL:url];
        
        UITapGestureRecognizer *removeTap = [[UITapGestureRecognizer alloc] init];
        [[removeTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [view removeFromSuperview];
        }];
        [view addGestureRecognizer:removeTap];
    }];
    [mImageView addGestureRecognizer:tap];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_listType) {
        case SKDetailListTypeComment:{
            SKHomepageDetaillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
            if (cell==nil) {
                cell = [[SKHomepageDetaillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
            }
            cell.comment = self.dataArray_comment[indexPath.row];
            return cell;
        }
        case SKDetailListTypeThumb:{
            SKThumbTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKThumbTableViewCell class])];
            if (cell==nil) {
                cell = [[SKThumbTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKThumbTableViewCell class])];
            }
            cell.userInfo = self.dataArray_thumb[indexPath.row];
            return cell;
        }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_listType) {
        case SKDetailListTypeComment:{
            SKHomepageDetaillTableViewCell *cell = (SKHomepageDetaillTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
        }
        case SKDetailListTypeThumb: {
            return 60;
        }
        default:
            return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(37))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = COMMON_SEPARATOR_COLOR;
    [headerView addSubview:line];
    line.bottom = headerView.height;
 
    //评论
    UIButton *commentButton = [UIButton new];
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    commentButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [headerView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(37)));
        make.left.equalTo(@5);
        make.centerY.equalTo(headerView);
    }];
    [[commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.view layoutIfNeeded];
        [_pointView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(20), 1));
            make.bottom.equalTo(headerView);
            make.centerX.equalTo(commentButton);
        }];
        
        self.listType = SKDetailListTypeComment;
    }];
    
    UILabel *commentLabel = [UILabel new];
    commentLabel.text = [NSString stringWithFormat:@"%@", self.topic.comment_num];
    commentLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
    commentLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [commentLabel sizeToFit];
    [headerView addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentButton.mas_right);
        make.centerY.equalTo(commentButton);
    }];
    
    //赞
    UILabel *thumbLabel = [UILabel new];
    thumbLabel.text = [NSString stringWithFormat:@"%@", self.topic.thumb_num];
    thumbLabel.textColor = COMMON_TEXT_CONTENT_COLOR;
    thumbLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [thumbLabel sizeToFit];
    [headerView addSubview:thumbLabel];
    [thumbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(ROUND_WIDTH_FLOAT(-15));
        make.centerY.equalTo(commentButton);
    }];
    
    UIButton *thumbButton = [UIButton new];
    [thumbButton setTitle:@"赞" forState:UIControlStateNormal];
    [thumbButton setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    thumbButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [headerView addSubview:thumbButton];
    [thumbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(37)));
        make.right.equalTo(thumbLabel.mas_left);
        make.centerY.equalTo(headerView);
    }];
    [[thumbButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.view layoutIfNeeded];
        [_pointView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(20), 1));
            make.bottom.equalTo(headerView);
            make.centerX.equalTo(thumbButton);
        }];
        self.listType = SKDetailListTypeThumb;
    }];
    
    _pointView = [UIView new];
    _pointView.backgroundColor = COMMON_GREEN_COLOR;
    [headerView addSubview:_pointView];
    [_pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(20), 1));
        make.bottom.equalTo(headerView).offset(-1);
        if (_listType==SKDetailListTypeComment) {
            make.centerX.equalTo(commentButton);
        } else if (_listType == SKDetailListTypeThumb) {
            make.centerX.equalTo(thumbButton);
        }
    }];
    
    return headerView;
}

#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ROUND_WIDTH_FLOAT(37);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_listType) {
        case SKDetailListTypeComment:
            return self.dataArray_comment.count;
        case SKDetailListTypeThumb:
            return self.dataArray_thumb.count;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"listType"]) {
        switch (_listType) {
            case SKDetailListTypeComment:{
                [[[SKServiceManager sharedInstance] topicService] getCommentListWithArticleID:self.topic.id page:1 pagesize:10 callback:^(BOOL success, NSArray<SKComment *> *commentList, NSInteger totalPage) {
                    _totalPage = totalPage;
                    self.dataArray_comment = [NSMutableArray arrayWithArray:commentList];
                    if (commentList.count==0) {
                        [_tableView addSubview:_blankView];
                    } else {
                        [self.view sendSubviewToBack:_blankView];
                        [_blankView removeFromSuperview];
                    }
                    [self.tableView reloadData];
                    [self.tableView layoutIfNeeded];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //刷新完成
                        _blankView.top = self.headerView.height+80;
                    });
                }];
                break;
            }
            case SKDetailListTypeThumb: {
                [[[SKServiceManager sharedInstance] topicService] getThumbListWithArticleID:self.topic.id page:1 pagesize:10 callback:^(BOOL success, NSArray<SKUserInfo *> *list, NSInteger totalPage) {
                    _totalPage = totalPage;
                    self.dataArray_thumb = [NSMutableArray arrayWithArray:list];
                    [_blankView removeFromSuperview];
                    [self.tableView reloadData];
                }];
                break;
            }
            default:
                break;
        }
    }
}

@end
