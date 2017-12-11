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

@interface SKHomepageViewController () <UITableViewDelegate, UITableViewDataSource, PSCarouselDelegate, SKSegmentViewDelegate, SKHomepageTableCellDelegate,UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKTopic *> *dataArray;
@property (nonatomic, strong) NSMutableArray<SKTopic *> *dataArray_collection;

@property (strong, nonatomic) PSCarouselView *carouselView;
@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, strong) SKSegmentView *titleView_collectionV;
//@property (nonatomic, strong) UIButton *button_follow;
//@property (nonatomic, strong) UIButton *button_hot;
//@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, assign) SKHomepageSelectedType selectedType;

@property (nonatomic, strong) SKTopicsView *topoicsView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SKHomepageViewController {
    BOOL scrollLock;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    [self addObserver:self forKeyPath:@"selectedType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self createUI];
    
//    [[[SKServiceManager sharedInstance] topicService] getIndexFollowListWithPageIndex:1 pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList) {
//        self.dataArray = [NSMutableArray arrayWithArray:topicList];
//        [self.tableView reloadData];
//    }];
    
    if([SKStorageManager sharedInstance].userInfo.uuid==nil)    return;
    
    [[[SKServiceManager sharedInstance] topicService] getIndexHeaderImagesArrayWithCallback:^(BOOL success, SKResponsePackage *response) {
        if ([response.data[@"banners"] count]==0){
            return;
        } else {
            self.tableView.tableHeaderView.height = ROUND_WIDTH_FLOAT(282);
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
            [self.tableView.tableHeaderView addSubview:self.carouselView];
        }
    }];
}

- (SKTopicsView *)topoicsView {
    if (!_topoicsView) {
        _topoicsView = [[SKTopicsView alloc] initWithFrame:self.tableView.frame];
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
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = COMMON_BG_COLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[SKHomepageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    [self.view addSubview:_tableView];
    
    //话题列表
    [self.view addSubview:self.collectionView];
    
    [self.view bringSubviewToFront:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(212))];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
    headerImageView.image = COMMON_PLACEHOLDER_IMAGE;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [headerView addSubview:headerImageView];
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADERVIEW_HEIGHT, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(22))];
    [headerView addSubview:blankView];
    self.tableView.tableHeaderView = headerView;
    
#ifdef __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    if ([self.collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    
    //TitleView
    _titleView = [[SKSegmentView alloc] initWithFrame:CGRectMake(0, 0, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT)  titleNameArray:@[@"关注", @"热门", @"话题"]];
    _titleView.delegate = self;
    _titleView.layer.cornerRadius = 3;
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.top = HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2;
    _titleView.centerX = self.view.centerX;
    _titleView.userInteractionEnabled = YES;
    [_tableView addSubview:_titleView];
    
    //TitleView 话题
    _titleView_collectionV = [[SKSegmentView alloc] initWithFrame:CGRectMake(0, 0, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT)  titleNameArray:@[@"关注", @"热门", @"话题"]];
    _titleView_collectionV.delegate = self;
    _titleView_collectionV.layer.cornerRadius = 3;
    _titleView_collectionV.backgroundColor = [UIColor whiteColor];
    _titleView_collectionV.top = HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2;
    _titleView_collectionV.centerX = self.view.centerX;
    _titleView_collectionV.userInteractionEnabled = YES;
    [_collectionView addSubview:_titleView_collectionV];
    
    if ([SKStorageManager sharedInstance].userInfo.uuid==nil||[[SKStorageManager sharedInstance].userInfo.uuid isEqualToString:@""]) {
        self.selectedType = SKHomepageSelectedTypeHot;
        _titleView.selectedIndex = SKHomepageSelectedTypeHot;
        _titleView_collectionV.selectedIndex = SKHomepageSelectedTypeHot;
    } else {
        self.selectedType = SKHomepageSelectedTypeFollow;
        _titleView.selectedIndex = SKHomepageSelectedTypeFollow;
        _titleView_collectionV.selectedIndex = SKHomepageSelectedTypeFollow;
    }
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(SPACE, SPACE, 0, SPACE);
        layout.headerHeight = HEADERVIEW_HEIGHT+ TITLEVIEW_HEIGHT/2 +20+ROUND_WIDTH_FLOAT(100);
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = SPACE;
        layout.minimumInteritemSpacing = SPACE;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
    }
    return _collectionView;
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
    [cell setTopic:self.dataArray_collection[indexPath.row].content];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize maxSize = CGSizeMake(CELL_WIDTH-20, ROUND_WIDTH_FLOAT(45));//labelsize的最大值
    CGSize labelSize = [self.dataArray_collection[indexPath.row].content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(10)} context:nil].size;
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH+ROUND_WIDTH_FLOAT(6)+labelSize.height+ROUND_WIDTH_FLOAT(51));
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
    self.selectedType = index;
    if (view==_titleView) {
        _titleView_collectionV.selectedIndex = index;
    } else if (view == _titleView_collectionV) {
        _titleView.selectedIndex = index;
    }
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    if (cell==nil) {
        cell = [[SKHomepageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    }
    cell.topic = self.dataArray[indexPath.row];
    //转发
    [[cell.repeaterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        SKPublishNewContentViewController *controller = [[SKPublishNewContentViewController alloc] initWithType:SKPublishTypeRepost withUserPost:self.dataArray[indexPath.row]];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //评论
    [[cell.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        SKPublishNewContentViewController *controller = [[SKPublishNewContentViewController alloc] initWithType:SKPublishTypeComment withUserPost:self.dataArray[indexPath.row]];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //关注
    [[cell.followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.dataArray[indexPath.row].is_follow) {
            [[[SKServiceManager sharedInstance] profileService] unFollowsUserID:[NSString stringWithFormat:@"%ld", (long)self.dataArray[indexPath.row].userinfo.id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"取消关注");
                    self.dataArray[indexPath.row].is_follow = 0;
                    [cell.followButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_follow"] forState:UIControlStateNormal];
                }
            }];
        } else {
            [[[SKServiceManager sharedInstance] profileService] doFollowsUserID:[NSString stringWithFormat:@"%ld", (long)self.dataArray[indexPath.row].userinfo.id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"成功关注");
                    self.dataArray[indexPath.row].is_follow = 1;
                    [cell.followButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_follow_highlight"] forState:UIControlStateNormal];
                }
            }];
        }
    }];
    //点赞
    [[cell.favButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.dataArray[indexPath.row].is_thumb) {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:self.dataArray[indexPath.row].is_thumb callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"取消点赞");
                self.dataArray[indexPath.row].is_thumb = 0;
                [cell.favButton setImage:[UIImage imageNamed:@"btn_homepage_like"] forState:UIControlStateNormal];
            }];
        } else {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:self.dataArray[indexPath.row].is_thumb callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"成功点赞");
                self.dataArray[indexPath.row].is_thumb = 1;
                [cell.favButton setImage:[UIImage imageNamed:@"btn_homepage_like_highlight"] forState:UIControlStateNormal];
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
    SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] initWithTopic:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickfollowButtonWithTopic:(SKTopic *)topic {
    NSLog(@"%@", topic.content);
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollLock) return;
    if (scrollView==self.tableView) {
        self.collectionView.contentOffset = scrollView.contentOffset;
    } else if (scrollView == self.collectionView) {
        self.tableView.contentOffset = scrollView.contentOffset;
    }
    if (scrollView.contentOffset.y<HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2) {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = (self.view.width-TITLEVIEW_WIDTH)/2;
            _titleView.height = TITLEVIEW_HEIGHT;
            _titleView.width = TITLEVIEW_WIDTH;
            _titleView.layer.cornerRadius = 3;

            _titleView_collectionV.left = (self.view.width-TITLEVIEW_WIDTH)/2;
            _titleView_collectionV.height = TITLEVIEW_HEIGHT;
            _titleView_collectionV.width = TITLEVIEW_WIDTH;
            _titleView_collectionV.layer.cornerRadius = 3;
            
        } completion:^(BOOL finished) {
            [_titleView removeFromSuperview];
            _titleView.frame = CGRectMake((self.view.width-_titleView.width)/2, HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT);
            
            [_titleView_collectionV removeFromSuperview];
            _titleView_collectionV.frame = CGRectMake((self.view.width-_titleView_collectionV.width)/2, HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT);
            [self.tableView addSubview:_titleView];
            [self.collectionView addSubview:_titleView_collectionV];
            
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = 0;
            _titleView.height = 20+TITLEVIEW_HEIGHT;
            _titleView.width = SCREEN_WIDTH;
            _titleView.layer.cornerRadius = 0;
           
            _titleView_collectionV.left = 0;
            _titleView_collectionV.height = 20+TITLEVIEW_HEIGHT;
            _titleView_collectionV.width = SCREEN_WIDTH;
            _titleView_collectionV.layer.cornerRadius = 0;
        } completion:^(BOOL finished) {
            [_titleView removeFromSuperview];
            _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20+TITLEVIEW_HEIGHT);
            [self.view addSubview:_titleView];
            
            [_titleView_collectionV removeFromSuperview];
            _titleView_collectionV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20+TITLEVIEW_HEIGHT);
            [self.view addSubview:_titleView_collectionV];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedType"]) {
        scrollLock = YES;
        if (self.selectedType==SKHomepageSelectedTypeFollow) {
            [self.view bringSubviewToFront:self.tableView];
            [[[SKServiceManager sharedInstance] topicService] getIndexFollowListWithPageIndex:1 pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList) {
                self.dataArray = [NSMutableArray arrayWithArray:topicList];
                [self.tableView reloadData];
                scrollLock = NO;
            }];
        } else if(self.selectedType==SKHomepageSelectedTypeHot){
            [self.view bringSubviewToFront:self.tableView];
            [[[SKServiceManager sharedInstance] topicService] getIndexHotListWithPageIndex:1 pagesize:10 callback:^(BOOL success, NSArray<SKUserPost *> *topicList) {
                self.dataArray = [NSMutableArray arrayWithArray:topicList];
                [self.tableView reloadData];
                scrollLock = NO;
            }];
        } else if(self.selectedType == SKHomepageSelectedTypeTopics){
            [self.view bringSubviewToFront:_collectionView];
            [[[SKServiceManager sharedInstance] topicService] getIndexTopicListWithTopicID:0 PageIndex:1 pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList) {
                self.dataArray_collection = [NSMutableArray arrayWithArray:topicList];
                [self.collectionView reloadData];
                scrollLock = NO;
            }];
        }
    }
}

@end
