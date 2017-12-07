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

#define HEADERVIEW_HEIGHT ROUND_WIDTH_FLOAT(180)
#define TITLEVIEW_WIDTH ROUND_WIDTH_FLOAT(240)
#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

typedef NS_ENUM(NSInteger, SKHomepageSelectedType) {
    SKHomepageSelectedTypeFollow,
    SKHomepageSelectedTypeHot
};

@interface SKHomepageViewController () <UITableViewDelegate, UITableViewDataSource, PSCarouselDelegate, SKSegmentViewDelegate, SKHomepageTableCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SKTopic *> *dataArray;

@property (strong, nonatomic) PSCarouselView *carouselView;
@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, strong) UIButton *button_follow;
@property (nonatomic, strong) UIButton *button_hot;
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, assign) SKHomepageSelectedType selectedType;
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
    [[[SKServiceManager sharedInstance] topicService] getIndexFollowListWithPageIndex:1 pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList) {
        self.dataArray = [NSMutableArray arrayWithArray:topicList];
        [self.tableView reloadData];
    }];
    
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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[SKHomepageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    [self.view addSubview:_tableView];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(212))];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
    headerImageView.backgroundColor = [UIColor blackColor];
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
    self.selectedType = SKHomepageSelectedTypeFollow;
}

- (void)didClickFollowButton:(UIButton*)sender {
    self.selectedType = SKHomepageSelectedTypeFollow;
}

- (void)didClickHotButton:(UIButton*)sender {
    self.selectedType = SKHomepageSelectedTypeHot;
}

#pragma mark - PSCarouselDelegate

- (void)carousel:(PSCarouselView *)carousel didMoveToPage:(NSUInteger)page {
    NSLog(@"Page:%ld", page);
    
}

- (void)carousel:(PSCarouselView *)carousel didTouchPage:(NSUInteger)pag {
    
}

#pragma mark - SKSegment Delegate

- (void)segmentView:(UIView *)view didClickIndex:(NSInteger)index {
    self.selectedType = index;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    if (cell==nil) {
        cell = [[SKHomepageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    }
    cell.topic = self.dataArray[indexPath.row];
    cell.delegate = self;
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
            }];
        } else {
            [[[SKServiceManager sharedInstance] topicService] postThumbUpWithArticleID:self.dataArray[indexPath.row].is_thumb callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"成功点赞");
                self.dataArray[indexPath.row].is_thumb = 1;
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
    if (scrollView.contentOffset.y<HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2) {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = (self.view.width-TITLEVIEW_WIDTH)/2;
            _titleView.height = TITLEVIEW_HEIGHT;
            _titleView.width = TITLEVIEW_WIDTH;
            _titleView.layer.cornerRadius = 3;
            
            _button_follow.centerX = _titleView.width/2-60;
            _button_follow.top = 0;
            _button_hot.centerX = _titleView.width/2 +60;
            _button_hot.top = 0;
            
            _markLine.bottom = _titleView.height;
            _markLine.centerX = _button_follow.centerX;
        } completion:^(BOOL finished) {
            [_titleView removeFromSuperview];
            _titleView.frame = CGRectMake((self.view.width-_titleView.width)/2, HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT);
            [self.tableView addSubview:_titleView];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = 0;
            _titleView.height = 20+TITLEVIEW_HEIGHT;
            _titleView.width = SCREEN_WIDTH;
            _titleView.layer.cornerRadius = 0;
            
            _button_follow.centerX = _titleView.width/2-60;
            _button_follow.top = 20;
            _button_hot.centerX = _titleView.width/2 +60;
            _button_hot.top = 20;
            
            _markLine.bottom = _titleView.height;
            _markLine.centerX = _button_follow.centerX;
        } completion:^(BOOL finished) {
            [_titleView removeFromSuperview];
            _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20+TITLEVIEW_HEIGHT);
            [self.view addSubview:_titleView];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedType"]) {
        scrollLock = YES;
        if (self.selectedType==SKHomepageSelectedTypeFollow) {
            [_button_follow setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
            [_button_hot setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                _markLine.centerX = _button_follow.centerX;
                _markLine.bottom = _titleView.height;
            }];
            [[[SKServiceManager sharedInstance] topicService] getIndexFollowListWithPageIndex:1 pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList) {
                self.dataArray = [NSMutableArray arrayWithArray:topicList];
                [self.tableView reloadData];
                scrollLock = NO;
            }];
        } else if(self.selectedType==SKHomepageSelectedTypeHot){
            [_button_follow setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
            [_button_hot setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                _markLine.centerX = _button_hot.centerX;
                _markLine.bottom = _titleView.height;
            }];
            [[[SKServiceManager sharedInstance] topicService] getIndexHotListWithPageIndex:1 pagesize:10 callback:^(BOOL success, NSArray<SKUserPost *> *topicList) {
                self.dataArray = [NSMutableArray arrayWithArray:topicList];
                [self.tableView reloadData];
                scrollLock = NO;
            }];
        } else {
            
        }
    }
}

@end
