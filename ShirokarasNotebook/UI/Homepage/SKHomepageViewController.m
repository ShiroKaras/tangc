//
//  SKHomepageViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/7.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKHomepageViewController.h"
#import "SKHomepageTableViewCell.h"
#import "SKHomepageMorePicDetailViewController.h"
#import "SKSegmentView.h"
#import "SKServiceManager.h"
#import "PSCarouselView.h"

#import "SKPublishNewContentViewController.h"
#import "SKTextWebViewController.h"
#import "SKTopicsView.h"

#define HEADERVIEW_HEIGHT ROUND_WIDTH_FLOAT(180)
#define TITLEVIEW_WIDTH ROUND_WIDTH_FLOAT(240)
#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

//Topics
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#import "SKTopicCell.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"
#define SPACE 15
#define CELL_WIDTH ((SCREEN_WIDTH-SPACE*3)/2)

typedef NS_ENUM(NSInteger, SKHomepageSelectedType) {
    SKHomepageSelectedTypeFollow,
    SKHomepageSelectedTypeHot,
    SKHomepageSelectedTypeTopics
};

@interface SKHomepageViewController () <UITableViewDelegate, UITableViewDataSource, PSCarouselDelegate, SKSegmentViewDelegate, SKHomepageTableCellDelegate,UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, CHTCollectionViewWaterfallHeaderDelegate>
@property (nonatomic, strong) UITableView *tableView_hot;
@property (nonatomic, strong) UITableView *tableView_follow;
@property (nonatomic, strong) NSMutableArray<SKTopic *> *dataArray_follow;
@property (nonatomic, strong) NSMutableArray<SKTopic *> *dataArray_hot;
@property (nonatomic, strong) NSMutableArray<SKTopic *> *dataArray_collection;

@property (strong, nonatomic) PSCarouselView *carouselView;
@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, strong) SKSegmentView *titleView_collectionV;
@property (nonatomic, strong) SKSegmentView *titleView_top;
@property (nonatomic, assign) SKHomepageSelectedType selectedType;

@property (nonatomic, strong) SKTopicsView *topoicsView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectedTopicID; //被选中的话题id

@property (assign, nonatomic)   UIStatusBarStyle            statusBarStyle;  /**< 状态栏样式 */
@property (assign, nonatomic)   BOOL                        statusBarHidden;  /**< 状态栏隐藏 */

@property (nonatomic, strong) NSIndexPath *indxCut_hot; // 用来记录被点击的cell
@property (nonatomic, strong) NSIndexPath *indxCut_follow; // 用来记录被点击的cell

@property (nonatomic, strong) HTBlankView *blankView;
@end

@implementation SKHomepageViewController {
    BOOL scrollLock;
    
    NSInteger     page;
    NSInteger     _totalPage;//总页数
//    BOOL    isFirstCome; //第一次加载帖子时候不需要传入此关键字，当需要加载下一页时：需要传入加载上一页时返回值字段“maxtime”中的内容。
    BOOL    isJuhua;//是否正在下拉刷新或者上拉加载。default NO。
    
    NSInteger   page_collection;
    NSInteger   _totalPage_collection;
    
    CGPoint contentOffSet;
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    _statusBarHidden = NO;
    if ([SKStorageManager sharedInstance].loginUser.uuid==nil&&self.selectedType!=SKHomepageSelectedTypeHot) {
        self.selectedType = SKHomepageSelectedTypeHot;
        self.titleView_top.selectedIndex = SKHomepageSelectedTypeHot;
    }
    ((SKTabbarViewController*)self.tabBarController).redPoint.hidden = ![[UD objectForKey:@"isNewNotification"] integerValue];
    
    [self.tableView_hot scrollToRowAtIndexPath:self.indxCut_hot atScrollPosition:UITableViewScrollPositionTop animated:NO]; // tableView的方法 一行代码 他会滚动到你指定的CELL的位置
    [self.tableView_follow scrollToRowAtIndexPath:self.indxCut_follow atScrollPosition:UITableViewScrollPositionTop animated:NO]; // tableView的方法 一行代码 他会滚动到你指定的CELL的位置
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.dataArray_follow = nil;
    self.dataArray_hot = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    page = 1;
    _totalPage = 1;
    isJuhua = NO;
    
    page_collection =1;
    _totalPage_collection =1;
    
    self.dataArray_follow = [NSMutableArray array];
    self.dataArray_hot = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addObserver:self forKeyPath:@"selectedType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self createUI];
    [self refresh];
    
    [[[SKServiceManager sharedInstance] topicService] getIndexHeaderImagesArrayWithCallback:^(BOOL success, SKResponsePackage *response) {
        if ([response.data[@"banners"] count]==0){
            return;
        } else {
            self.tableView_hot.tableHeaderView.height = ROUND_WIDTH_FLOAT(282);
            self.carouselView = [[PSCarouselView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(10), ROUND_WIDTH_FLOAT(212), ROUND_WIDTH_FLOAT(300), ROUND_WIDTH_FLOAT(60))];
            self.carouselView.placeholder = [UIImage imageNamed:@"img_banner_loading"];
            self.carouselView.layer.cornerRadius = 3;
            self.carouselView.contentMode = UIViewContentModeScaleAspectFill;
            self.carouselView.autoMoving = YES;
            self.carouselView.movingTimeInterval = 1.5f;
            NSMutableArray *imageUrls = [NSMutableArray array];
            for (int i=0; i<[response.data[@"banners"] count]; i++) {
                [imageUrls addObject:response.data[@"banners"][i][@"images"]];
            }
            self.carouselView.imageURLs = imageUrls;
            self.carouselView.pageDelegate = self;
            [self.tableView_hot.tableHeaderView addSubview:self.carouselView];
        }
    }];
}

- (SKTopicsView *)topoicsView {
    if (!_topoicsView) {
        _topoicsView = [[SKTopicsView alloc] initWithFrame:self.tableView_hot.frame];
    }
    return _topoicsView;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selectedType"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    //TableView follow
    _tableView_follow = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kDevice_Is_iPhoneX?(self.view.height-83+20):(self.view.height-49)) style:UITableViewStylePlain];
    _tableView_follow.delegate = self;
    _tableView_follow.dataSource = self;
    _tableView_follow.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView_follow.backgroundColor = COMMON_BG_COLOR;
    _tableView_follow.showsVerticalScrollIndicator = NO;
    [_tableView_follow registerClass:[SKHomepageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    
    //TableView hot
    _tableView_hot = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kDevice_Is_iPhoneX?(self.view.height-83+20):(self.view.height-49)) style:UITableViewStylePlain];
    _tableView_hot.delegate = self;
    _tableView_hot.dataSource = self;
    _tableView_hot.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView_hot.backgroundColor = COMMON_BG_COLOR;
    _tableView_hot.showsVerticalScrollIndicator = NO;
    [_tableView_hot registerClass:[SKHomepageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    
    [self.view addSubview:_tableView_follow];
    [self.view addSubview:_tableView_hot];
    //话题列表
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:_tableView_hot];
    
    //follow header
    UIView *headerView_follow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(212))];
    headerView_follow.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImageView_follow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
    headerImageView_follow.image = [UIImage imageNamed:@"img_homepage_brand"];
    headerImageView_follow.layer.masksToBounds = YES;
    headerImageView_follow.contentMode = UIViewContentModeScaleAspectFill;
    [headerView_follow addSubview:headerImageView_follow];
    [[[SKServiceManager sharedInstance] topicService] getIndexHeaderImagesArrayWithCallback:^(BOOL success, SKResponsePackage *response) {
        [headerImageView_follow sd_setImageWithURL:response.data[@"index_top"]];
    }];
    
    UIView *blankView_follow = [[UIView alloc] initWithFrame:CGRectMake(0, HEADERVIEW_HEIGHT, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(22))];
    [headerView_follow addSubview:blankView_follow];
    _tableView_follow.tableHeaderView = headerView_follow;
    
    //hot header
    UIView *headerView_hot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(212))];
    headerView_hot.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImageView_hot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
    headerImageView_hot.image = [UIImage imageNamed:@"img_homepage_brand"];
    headerImageView_hot.layer.masksToBounds = YES;
    headerImageView_hot.contentMode = UIViewContentModeScaleAspectFill;
    [headerView_hot addSubview:headerImageView_hot];
    [[[SKServiceManager sharedInstance] topicService] getIndexHeaderImagesArrayWithCallback:^(BOOL success, SKResponsePackage *response) {
        [headerImageView_hot sd_setImageWithURL:response.data[@"index_top"]];
    }];
    
    UIView *blankView_hot= [[UIView alloc] initWithFrame:CGRectMake(0, HEADERVIEW_HEIGHT, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(22))];
    [headerView_hot addSubview:blankView_hot];
    _tableView_hot.tableHeaderView = headerView_hot;
    
    __weak typeof(self) weakSelf = self;
    _tableView_follow.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            _statusBarHidden = YES;
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
        [weakSelf getNetworkData:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView_follow.mj_header endRefreshing];
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                _statusBarHidden = NO;
                [self prefersStatusBarHidden];
                [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            }
        });
    }];
    
    _tableView_follow.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getNetworkData:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView_follow.mj_footer endRefreshing];
        });
    }];
    
    _tableView_hot.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            _statusBarHidden = YES;
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
        [weakSelf getNetworkData:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView_hot.mj_header endRefreshing];
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                _statusBarHidden = NO;
                [self prefersStatusBarHidden];
                [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            }
        });
    }];
    
    _tableView_hot.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getNetworkData:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView_hot.mj_footer endRefreshing];
        });
    }];
    
#ifdef __IPHONE_11_0
    if ([_tableView_hot respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _tableView_hot.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    if ([_tableView_follow respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _tableView_follow.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    if ([self.collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
#endif

    //TitleView 置顶
    _titleView_top = [[SKSegmentView alloc] initWithFrame:CGRectMake(0, 0, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT)  titleNameArray:@[@"关注", @"热门", @"话题"]];
    _titleView_top.layer.cornerRadius = 3;
    _titleView_top.delegate = self;
    _titleView_top.backgroundColor = [UIColor whiteColor];
    _titleView_top.top = ROUND_WIDTH_FLOAT(158);
    _titleView_top.centerX = self.view.centerX;
    _titleView_top.userInteractionEnabled = YES;
    [self.view addSubview:_titleView_top];
    
    if ([SKStorageManager sharedInstance].loginUser.uuid==nil||[[SKStorageManager sharedInstance].loginUser.uuid isEqualToString:@""]) {
        self.selectedType = SKHomepageSelectedTypeHot;
        _titleView_top.selectedIndex = SKHomepageSelectedTypeHot;
    } else {
        self.selectedType = SKHomepageSelectedTypeFollow;
        _titleView_top.selectedIndex = SKHomepageSelectedTypeFollow;
    }
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - MJRefresh

-(void)refresh
{
    [self getNetworkData:YES];
}

-(void)loadMore
{
    [self getNetworkData:NO];
}

- (void)getNetworkData:(BOOL)isRefresh {
    if (isRefresh) {
        page = 1;
    }else{
        page++;
    }

    if (self.selectedType==SKHomepageSelectedTypeFollow) {
        [self.view bringSubviewToFront:_tableView_follow];
        [self.view bringSubviewToFront:_titleView_top];
        [[[SKServiceManager sharedInstance] topicService] getIndexFollowListWithPageIndex:page pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList, NSInteger totalPage) {
            _totalPage = totalPage;
            if (page>totalPage) {
                page = totalPage;
            }
            if (isRefresh) {
                self.dataArray_follow = [NSMutableArray arrayWithArray:topicList];
            } else {
                for (int i=0; i<topicList.count; i++) {
                    [self.dataArray_follow addObject:topicList[i]];
                }
            }
            if (topicList.count==0) {
                _blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoMessage2];
                [_tableView_follow addSubview:_blankView];
                _blankView.centerY = SCREEN_HEIGHT/2+100;
                _blankView.centerX = SCREEN_WIDTH/2;
            } else {
                [_blankView removeFromSuperview];
            }
            [_tableView_follow reloadData];
            scrollLock = NO;
        }];
    } else if (self.selectedType == SKHomepageSelectedTypeHot) {
        [self.view bringSubviewToFront:_tableView_hot];
        [self.view bringSubviewToFront:_titleView_top];
        [[[SKServiceManager sharedInstance] topicService] getIndexHotListWithPageIndex:page pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList, NSInteger totalPage) {
            _totalPage = totalPage;
            if (page>totalPage) {
                page = totalPage;
                return;
            }
            if (isRefresh) {
                self.dataArray_hot = [NSMutableArray arrayWithArray:topicList];
            } else {
                for (int i=0; i<topicList.count; i++) {
                    [self.dataArray_hot addObject:topicList[i]];
                }
            }
            if (topicList.count==0&&page==1) {
                
            }
            
            [_tableView_hot reloadData];
            
            scrollLock = NO;
        }];
    } else if (self.selectedType == SKHomepageSelectedTypeTopics) {
        [self.view bringSubviewToFront:self.collectionView];
        [self.view bringSubviewToFront:_titleView_top];
        [[[SKServiceManager sharedInstance] topicService] getIndexTopicListWithTopicID:self.selectedTopicID PageIndex:page pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList, NSInteger totalPage) {
            _totalPage = totalPage;
            if (page>totalPage) {
                page = totalPage;
                return;
            }
            if (isRefresh) {
                self.dataArray_collection = [NSMutableArray arrayWithArray:topicList];
            } else {
                for (int i=0; i<topicList.count; i++) {
                    [self.dataArray_collection addObject:topicList[i]];
                }
            }
            if (topicList.count==0&&page==1) {
                
            }
            
            [self.collectionView reloadData];
            
            scrollLock = NO;
        }];
    } else {
        
    }
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(SPACE, SPACE, 0, SPACE);
        layout.headerHeight = ROUND_WIDTH_FLOAT(212)+ROUND_WIDTH_FLOAT(78);
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = SPACE;
        layout.minimumInteritemSpacing = SPACE;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kDevice_Is_iPhoneX?(self.view.height-83+20):(self.view.height-49)) collectionViewLayout:layout];
//        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = COMMON_BG_COLOR;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SKTopicCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page_collection =1;
            [[[SKServiceManager sharedInstance] topicService] getIndexTopicListWithTopicID:self.selectedTopicID PageIndex:page pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList, NSInteger totalPage) {
                _totalPage_collection = totalPage;
                if (_totalPage_collection>totalPage) {
                    _totalPage_collection = totalPage;
                    return;
                }
                self.dataArray_collection = [NSMutableArray arrayWithArray:topicList];
                if (topicList.count==0&&page_collection==1) {
                    
                }
                [self.collectionView reloadData];
                scrollLock = NO;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView.mj_header endRefreshing];
            });
        }];
        
        //加载更多
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page_collection++;
            [[[SKServiceManager sharedInstance] topicService] getIndexTopicListWithTopicID:self.selectedTopicID PageIndex:page pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList, NSInteger totalPage) {
                _totalPage_collection = totalPage;
                if (page_collection>totalPage) {
                    page_collection = totalPage;
                    return;
                }
                for (int i=0; i<topicList.count; i++) {
                    [self.dataArray_collection addObject:topicList[i]];
                }
                if (topicList.count==0&&page_collection==1) {
                    
                }
                [self.collectionView reloadData];
                scrollLock = NO;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView.mj_footer endRefreshing];
            });
        }];
    }
    return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] initWithTopic:self.dataArray_collection[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray_collection.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SKTopicCell *cell = (SKTopicCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell.mCoverImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray_collection[indexPath.row].images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
    [cell.mAvatarImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray_collection[indexPath.row].userinfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
    cell.mUsernameLabel.text = self.dataArray_collection[indexPath.row].userinfo.nickname;
    cell.topic = self.dataArray_collection[indexPath.row];
    //点赞
    [[cell.favButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
            return;
        }
        if (self.dataArray_collection[indexPath.row].is_thumb) {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:self.dataArray_collection[indexPath.row].id callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"取消点赞");
                self.dataArray_collection[indexPath.row].is_thumb = 0;
                [cell.favButton setImage:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
                [cell.favButton setTitle:[NSString stringWithFormat:@"%ld", [cell.favButton.titleLabel.text integerValue]-1] forState:UIControlStateNormal];
            }];
        } else {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:self.dataArray_collection[indexPath.row].id callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"成功点赞");
                self.dataArray_collection[indexPath.row].is_thumb = 1;
                [cell.favButton setImage:[UIImage imageNamed:@"btn_homepage_like_highlight"] forState:UIControlStateNormal];
                [cell.favButton setTitle:[NSString stringWithFormat:@"%ld", [cell.favButton.titleLabel.text integerValue]+1] forState:UIControlStateNormal];
            }];
        }
    }];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        ((CHTCollectionViewWaterfallHeader*)reusableView).delegate = self;
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

- (void)didClickTagAtIndex:(NSInteger)index {
    [[[SKServiceManager sharedInstance] topicService] getIndexTopicListWithTopicID:index PageIndex:1 pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList, NSInteger totalPage) {
        self.selectedTopicID = index;
        self.dataArray_collection = [NSMutableArray arrayWithArray:topicList];
        [self.collectionView reloadData];
        scrollLock = NO;
    }];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize maxSize = CGSizeMake(CELL_WIDTH-20, ROUND_WIDTH_FLOAT(45));//labelsize的最大值
    CGSize labelSize = [self.dataArray_collection[indexPath.row].content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(10)} context:nil].size;
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH+ROUND_WIDTH_FLOAT(6)+labelSize.height+ROUND_WIDTH_FLOAT(31));
}

#pragma mark - PSCarouselDelegate

- (void)carousel:(PSCarouselView *)carousel didMoveToPage:(NSUInteger)page {
    NSLog(@"Page:%ld", page);
}

- (void)carousel:(PSCarouselView *)carousel didTouchPage:(NSUInteger)pag {
    
}

#pragma mark - SKSegment Delegate

- (void)segmentView:(SKSegmentView *)view didClickIndex:(NSInteger)index {
    NSLog(@"index: %ld", index);
    if (index == SKHomepageSelectedTypeFollow && [SKStorageManager sharedInstance].loginUser.uuid==nil) {
        [self invokeLoginViewController];
        return;
    } else {
        self.selectedType = index;
    }
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    if (cell==nil) {
        cell = [[SKHomepageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    }
    
    switch (self.selectedType) {
        case SKHomepageSelectedTypeFollow:{
            return [self contentWithCell:cell dataArray:self.dataArray_follow indexPath:indexPath];
        }
        case SKHomepageSelectedTypeHot:{
            return [self contentWithCell:cell dataArray:self.dataArray_hot indexPath:indexPath];
        }
        default:
            return nil;
    }
}

- (SKHomepageTableViewCell *)contentWithCell:(SKHomepageTableViewCell*)cell dataArray:(NSMutableArray<SKTopic*>*)dataArray indexPath:(NSIndexPath*)indexPath{
    cell.topic = dataArray[indexPath.row];
    
    //转发
    [[cell.repeaterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
            return;
        }
        SKPublishNewContentViewController *controller = [[SKPublishNewContentViewController alloc] initWithType:SKPublishTypeRepost withUserPost:dataArray[indexPath.row]];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //评论
    [[cell.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
            return;
        }
        SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] initWithTopic:dataArray[indexPath.row]];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //关注
    cell.followButton.hidden = [[SKStorageManager sharedInstance].userInfo.nickname isEqualToString:dataArray[indexPath.row].userinfo.nickname];
    cell.baseInfoView.followButton.hidden = YES;
    [[cell.followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
            return;
        }
        if (dataArray[indexPath.row].is_follow) {
            [[[SKServiceManager sharedInstance] profileService] unFollowsUserID:[NSString stringWithFormat:@"%ld", (long)dataArray[indexPath.row].userinfo.id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"取消关注");
                    dataArray[indexPath.row].is_follow = 0;
                    [cell.followButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_follow"] forState:UIControlStateNormal];
                }
            }];
        } else {
            [[[SKServiceManager sharedInstance] profileService] doFollowsUserID:[NSString stringWithFormat:@"%ld", (long)dataArray[indexPath.row].userinfo.id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"成功关注");
                    dataArray[indexPath.row].is_follow = 1;
                    [cell.followButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_follow_highlight"] forState:UIControlStateNormal];
                }
            }];
        }
    }];
    //点赞
    [[cell.favButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
            return;
        }
        if (dataArray[indexPath.row].is_thumb) {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:dataArray[indexPath.row].id callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"取消点赞");
                dataArray[indexPath.row].is_thumb = 0;
                [cell.favButton setImage:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
                [cell.favButton setTitle:[NSString stringWithFormat:@"%ld", [cell.favButton.titleLabel.text integerValue]-1] forState:UIControlStateNormal];
            }];
        } else {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:dataArray[indexPath.row].id callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"成功点赞");
                dataArray[indexPath.row].is_thumb = 1;
                [cell.favButton setImage:[UIImage imageNamed:@"btn_homepage_like_highlight"] forState:UIControlStateNormal];
                [cell.favButton setTitle:[NSString stringWithFormat:@"%ld", [cell.favButton.titleLabel.text integerValue]+1] forState:UIControlStateNormal];
            }];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageTableViewCell *cell = (SKHomepageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedType) {
        case SKHomepageSelectedTypeFollow:{
            if(self.dataArray_follow[indexPath.row].from.is_del){
                //原文已删除
            } else {
                self.indxCut_follow = indexPath;
                SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] initWithTopic:self.dataArray_follow[indexPath.row]];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        case SKHomepageSelectedTypeHot: {
            if(self.dataArray_hot[indexPath.row].from.is_del){
                //原文已删除
            } else {
                self.indxCut_hot = indexPath;
                SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] initWithTopic:self.dataArray_hot[indexPath.row]];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        default:
            break;
    }
}

- (void)didClickfollowButtonWithTopic:(SKTopic *)topic {
    NSLog(@"%@", topic.content);
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.selectedType) {
        case SKHomepageSelectedTypeFollow:
            return self.dataArray_follow.count;
        case SKHomepageSelectedTypeHot:
            return  self.dataArray_hot.count;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollLock) return;
    
    if (scrollView.contentOffset.y<HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2) {
        _titleView_top.top = ROUND_WIDTH_FLOAT(158)- scrollView.contentOffset.y;
    } else {
        _titleView_top.top = 0;
    }
    if (_titleView_top.top==0) {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView_top.width = self.view.width;
            _titleView_top.left = 0;
            _titleView_top.height = TITLEVIEW_HEIGHT+(kDevice_Is_iPhoneX?44:20);
            _titleView_top.layer.cornerRadius = 0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView_top.width = TITLEVIEW_WIDTH;
            _titleView_top.centerX = self.view.centerX;
            _titleView_top.height = TITLEVIEW_HEIGHT;
            _titleView_top.layer.cornerRadius = 3;
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedType"]) {
        scrollLock = YES;
        _titleView_top.selectedIndex = self.selectedType;
        [self refresh];
    }
}

@end
