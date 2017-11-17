//
//  SKNotificationViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKNotificationViewController.h"
#import "SKNotificationTableViewCell.h"
#import "SKSegmentView.h"

#define HEADERVIEW_HEIGHT (64+ROUND_HEIGHT_FLOAT(22))
#define TITLEVIEW_WIDTH SCREEN_WIDTH
#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

typedef NS_ENUM(NSInteger, SKNotificationSelectedType) {
    SKMarketSelectedTypeTicket,
    SKMarketSelectedTypeShop
};

@interface SKNotificationViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, strong) UIButton *button_follow;
@property (nonatomic, strong) UIButton *button_hot;
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, assign) SKNotificationSelectedType selectedType;
@end

@implementation SKNotificationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    [self createUI];
    [self addObserver:self forKeyPath:@"selectedType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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
    [self.tableView registerClass:[SKNotificationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKNotificationTableViewCell class])];
    [self.view addSubview:_tableView];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT+40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
    headerImageView.backgroundColor = COMMON_BG_COLOR;
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
    _titleView = [[SKSegmentView alloc] initWithFrame:CGRectMake(0, 0, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT) titleNameArray:@[@"通知", @"评论", @"赞", @"@我"]];
    _titleView.layer.cornerRadius = 3;
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.top = HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2;
    _titleView.centerX = self.view.centerX;
    _titleView.userInteractionEnabled = YES;
    [self.tableView addSubview:_titleView];
}

- (void)didClickFollowButton:(UIButton*)sender {
    self.selectedType = SKMarketSelectedTypeTicket;
}

- (void)didClickHotButton:(UIButton*)sender {
    self.selectedType = SKMarketSelectedTypeShop;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKNotificationTableViewCell class])];
    if (cell==nil) {
        cell = [[SKNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKNotificationTableViewCell class])];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKNotificationTableViewCell *cell = (SKNotificationTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight+15;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return _dataArray.count;
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    DLog(@"%lf", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2) {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = (self.view.width-TITLEVIEW_WIDTH)/2;
            _titleView.height = TITLEVIEW_HEIGHT;
            _titleView.width = TITLEVIEW_WIDTH;
            _titleView.layer.cornerRadius = 5;
            
            for (UIView *view in _titleView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    view.top =0;
                }
            }
            
            _titleView.markLine.bottom = _titleView.height;
        } completion:^(BOOL finished) {
            [_titleView removeFromSuperview];
            _titleView.frame = CGRectMake((self.view.width-_titleView.width)/2, HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT);
            [self.tableView addSubview:_titleView];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = 0;
            _titleView.width = SCREEN_WIDTH;
            _titleView.layer.cornerRadius = 0;
            
            for (UIView *view in _titleView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    view.top =20;
                }
            }
            
            _titleView.markLine.bottom = _titleView.height;
        } completion:^(BOOL finished) {
            [_titleView removeFromSuperview];
            _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20+TITLEVIEW_HEIGHT);
            [self.view addSubview:_titleView];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedType"]) {
        
    }
}
@end
