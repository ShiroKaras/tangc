//
//  SKNotificationViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKNotificationViewController.h"
#import "SKSegmentView.h"
#import "SKNotificationTableViewCell.h"
#import "SKNotificationCommentTableViewCell.h"
#import "SKNotificationBaseInfoTableViewCell.h"
#import "SKHomepageMorePicDetailViewController.h"

#define HEADERVIEW_HEIGHT (64+ROUND_HEIGHT_FLOAT(22))
#define TITLEVIEW_WIDTH SCREEN_WIDTH
#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

typedef NS_ENUM(NSInteger, SKNotificationSelectedType) {
    SKNotificationSelectedTypeNotification,
    SKNotificationSelectedTypeComment,
    SKNotificationSelectedTypeLike,
    SKNotificationSelectedTypeCallMe
};

@interface SKNotificationViewController () <UITableViewDelegate, UITableViewDataSource, SKSegmentViewDelegate>
@property (nonatomic, strong) UITableView *tableView_notification;
@property (nonatomic, strong) UITableView *tableView_comment;
@property (nonatomic, strong) UITableView *tableView_like;
@property (nonatomic, strong) UITableView *tableView_callme;

@property (nonatomic, strong) NSMutableArray<SKNotification*> *dataArray;

@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, strong) UIButton *button_follow;
@property (nonatomic, strong) UIButton *button_hot;
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, assign) SKNotificationSelectedType selectedType;
@end

@implementation SKNotificationViewController {
    NSInteger     page;
    NSInteger     _totalPage;//总页数
    BOOL    isFirstCome; //第一次加载帖子时候不需要传入此关键字，当需要加载下一页时：需要传入加载上一页时返回值字段“maxtime”中的内容。
    BOOL    isJuhua;//是否正在下拉刷新或者上拉加载。default NO。
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.selectedType = SKNotificationSelectedTypeNotification;
    
    [UD setValue:@(NO) forKey:@"isNewNotification"];
    ((SKTabbarViewController*)self.tabBarController).redPoint.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    _totalPage = 1;
    isFirstCome = YES;
    isJuhua = NO;
    self.dataArray = [NSMutableArray array];
    
    self.view.backgroundColor = COMMON_BG_COLOR;
    [self addObserver:self forKeyPath:@"selectedType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self createUI];
    self.selectedType = SKNotificationSelectedTypeNotification;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selectedType"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
//    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?44:20, self.view.width, ROUND_WIDTH_FLOAT(44))];
//    tView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:tView];
//    UILabel *tLabel = [UILabel new];
//    tLabel.text = @"消息";
//    tLabel.textColor = COMMON_TEXT_COLOR;
//    tLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
//    [tLabel sizeToFit];
//    [tView addSubview:tLabel];
//    tLabel.centerX = tView.width/2;
//    tLabel.centerY = tView.height/2;
    
    //TableView
    _tableView_notification = [[UITableView alloc] initWithFrame:CGRectMake(0, (kDevice_Is_iPhoneX?44:20)+TITLEVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-49-((kDevice_Is_iPhoneX?44:20)+TITLEVIEW_HEIGHT)) style:UITableViewStylePlain];
    _tableView_notification.delegate = self;
    _tableView_notification.dataSource = self;
    _tableView_notification.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView_notification.backgroundColor = COMMON_BG_COLOR;
    _tableView_notification.showsVerticalScrollIndicator = NO;
    [_tableView_notification registerClass:[SKNotificationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKNotificationTableViewCell class])];
    [_tableView_notification registerClass:[SKNotificationCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKNotificationCommentTableViewCell class])];
    [_tableView_notification registerClass:[SKNotificationBaseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKNotificationBaseInfoTableViewCell class])];
    [self.view addSubview:_tableView_notification];
    
#ifdef __IPHONE_11_0
    if ([_tableView_notification respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _tableView_notification.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
#endif
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //TitleView
    _titleView = [[SKSegmentView alloc] initWithFrame:CGRectMake(0, (kDevice_Is_iPhoneX?44:20), SCREEN_WIDTH, TITLEVIEW_HEIGHT) titleNameArray:@[@"通知", @"评论", @"赞", @"@我"]];
    _titleView.delegate = self;
    _titleView.backgroundColor = [UIColor whiteColor];
//    _titleView.layer.cornerRadius = 3;
//    _titleView.top = HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2;
    _titleView.centerX = self.view.centerX;
    _titleView.userInteractionEnabled = YES;
    [self.view addSubview:_titleView];
    
    //加载更多
    self.tableView_notification.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [[[SKServiceManager sharedInstance] profileService] getUserQueueListWithType:self.selectedType+1 callback:^(BOOL success, NSArray<SKNotification *> *queueList, NSInteger totalPage) {
            _totalPage = totalPage;
            if (page>totalPage) {
                page = totalPage;
                return;
            }
            for (int i=0; i<queueList.count; i++) {
                [self.dataArray addObject:queueList[i]];
            }
            [self.tableView_notification reloadData];
            
            self.dataArray = [NSMutableArray arrayWithArray:queueList];
            [self.tableView_notification reloadData];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView_notification.mj_footer endRefreshing];
        });
    }];
}

- (void)segmentView:(UIView *)view didClickIndex:(NSInteger)index {
    NSLog(@"点击第%ld个标签", index);
    self.selectedType = index;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedType) {
        case SKNotificationSelectedTypeNotification: {
            SKNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKNotificationTableViewCell class])];
            if (cell==nil) {
                cell = [[SKNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKNotificationTableViewCell class])];
            }
            cell.notificationItem = self.dataArray[indexPath.row];
            return cell;
            break;
        }
        case SKNotificationSelectedTypeComment:{
            SKNotificationCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKNotificationCommentTableViewCell class])];
            if (cell==nil) {
                cell = [[SKNotificationCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKNotificationCommentTableViewCell class])];
            }
            cell.notificationItem = self.dataArray[indexPath.row];
            return cell;
            break;
        }
        case SKNotificationSelectedTypeLike:{
            SKNotificationBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKNotificationBaseInfoTableViewCell class])];
            if (cell==nil) {
                cell = [[SKNotificationBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKNotificationBaseInfoTableViewCell class])];
            }
            cell.notificationItem = self.dataArray[indexPath.row];
            cell.usernameAppendLabel.text = @"赞了你";
            [cell.usernameAppendLabel sizeToFit];
            return cell;
            break;
        }
        case SKNotificationSelectedTypeCallMe:{
            SKNotificationBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKNotificationBaseInfoTableViewCell class])];
            if (cell==nil) {
                cell = [[SKNotificationBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKNotificationBaseInfoTableViewCell class])];
            }
            cell.notificationItem = self.dataArray[indexPath.row];
            cell.usernameAppendLabel.text = @"在他的发布中@了你";
            [cell.usernameAppendLabel sizeToFit];
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedType) {
        case SKNotificationSelectedTypeNotification:{
            SKNotificationTableViewCell *cell = (SKNotificationTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
            break;
        }
        case SKNotificationSelectedTypeComment:{
            SKNotificationCommentTableViewCell *cell = (SKNotificationCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
            break;
        }
        case SKNotificationSelectedTypeLike:{
            SKNotificationTableViewCell *cell = (SKNotificationTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
            break;
        }
        case SKNotificationSelectedTypeCallMe:{
            SKNotificationTableViewCell *cell = (SKNotificationTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
            break;
        }
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedType) {
        case SKNotificationSelectedTypeNotification:{
            break;
        }
        case SKNotificationSelectedTypeComment:{
            SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] initWithArticleID:[self.dataArray[indexPath.row].article_id integerValue]];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case SKNotificationSelectedTypeLike:{
            SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] initWithArticleID:[self.dataArray[indexPath.row].article_id integerValue]];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case SKNotificationSelectedTypeCallMe:{
            SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] initWithArticleID:[self.dataArray[indexPath.row].article_id integerValue]];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ScrollView Delegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    DLog(@"%lf", scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y<HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _titleView.left = (self.view.width-TITLEVIEW_WIDTH)/2;
//            _titleView.height = TITLEVIEW_HEIGHT;
//            _titleView.width = TITLEVIEW_WIDTH;
//            _titleView.layer.cornerRadius = 5;
//
//            for (UIView *view in _titleView.subviews) {
//                if ([view isKindOfClass:[UIButton class]]) {
//                    view.top =0;
//                }
//            }
//
//            _titleView.markLine.bottom = _titleView.height;
//        } completion:^(BOOL finished) {
//            [_titleView removeFromSuperview];
//            _titleView.frame = CGRectMake((self.view.width-_titleView.width)/2, HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT);
//            [_tableView_notification addSubview:_titleView];
//        }];
//    } else {
//        [UIView animateWithDuration:0.2 animations:^{
//            _titleView.left = 0;
//            _titleView.width = SCREEN_WIDTH;
//            _titleView.layer.cornerRadius = 0;
//
//            for (UIView *view in _titleView.subviews) {
//                if ([view isKindOfClass:[UIButton class]]) {
//                    view.top =20;
//                }
//            }
//
//            _titleView.markLine.bottom = _titleView.height;
//        } completion:^(BOOL finished) {
//            [_titleView removeFromSuperview];
//            _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20+TITLEVIEW_HEIGHT);
//            [self.view addSubview:_titleView];
//        }];
//    }
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedType"]) {
        if (_selectedType!=SKNotificationSelectedTypeNotification&&[SKStorageManager sharedInstance].loginUser.uuid==nil) {
            [self invokeLoginViewController];
        } else {
            [[[SKServiceManager sharedInstance] profileService] getUserQueueListWithType:self.selectedType+1 callback:^(BOOL success, NSArray<SKNotification *> *queueList, NSInteger totalPage) {
                _totalPage = totalPage;
                self.dataArray = [NSMutableArray arrayWithArray:queueList];
                [self.tableView_notification reloadData];
            }];            
        }
    }
}
@end
