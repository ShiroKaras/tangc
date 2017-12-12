//
//  SKShopViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/7.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKShopViewController.h"
#import "SKTicketTableViewCell.h"

#define HEADERVIEW_HEIGHT ROUND_WIDTH_FLOAT(180)
#define TITLEVIEW_WIDTH ROUND_WIDTH_FLOAT(240)
#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

typedef NS_ENUM(NSInteger, SKMarketSelectedType) {
    SKMarketSelectedTypeTicket,
    SKMarketSelectedTypeShop
};

@interface SKShopViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKTicket*> *dataArray;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *button_follow;
@property (nonatomic, strong) UIButton *button_hot;
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, assign) SKMarketSelectedType selectedType;
@end

@implementation SKShopViewController

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
 
    [[[SKServiceManager sharedInstance] shopService] getTicketsListWithPage:0 pagesize:10 callback:^(BOOL success, NSArray<SKTicket *> *ticketsList) {
        self.dataArray = [NSMutableArray arrayWithArray:ticketsList];
        [self.tableView reloadData];
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
    [self.tableView registerClass:[SKTicketTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKTicketTableViewCell class])];
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
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
#endif
    
    //TitleView
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT)];
    _titleView.layer.cornerRadius = 3;
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.top = HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2;
    _titleView.centerX = self.view.centerX;
    _titleView.userInteractionEnabled = YES;
    [self.tableView addSubview:_titleView];
    
    _button_follow = [UIButton new];
    [_button_follow addTarget:self action:@selector(didClickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button_follow setTitle:@"优惠券" forState:UIControlStateNormal];
    [_button_follow setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    _button_follow.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    _button_follow.size = CGSizeMake(TITLEVIEW_HEIGHT*2, TITLEVIEW_HEIGHT);
    _button_follow.centerY = _titleView.height/2;
    _button_follow.centerX = _titleView.width/2-60;
    [_titleView addSubview:_button_follow];
    
    _button_hot = [UIButton new];
    [_button_hot addTarget:self action:@selector(didClickHotButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button_hot setTitle:@"商城" forState:UIControlStateNormal];
    [_button_hot setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
    _button_hot.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    _button_hot.size = CGSizeMake(TITLEVIEW_HEIGHT*2, TITLEVIEW_HEIGHT);
    _button_hot.centerY = _titleView.height/2;
    _button_hot.centerX = _titleView.width/2 +60;
    [_titleView addSubview:_button_hot];
    
    _markLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(20), 2)];
    _markLine.backgroundColor = COMMON_GREEN_COLOR;
    _markLine.centerX = _button_follow.centerX;
    _markLine.bottom = _titleView.height;
    [_titleView addSubview:_markLine];
    self.selectedType = SKMarketSelectedTypeTicket;
}

- (void)didClickFollowButton:(UIButton*)sender {
    self.selectedType = SKMarketSelectedTypeTicket;
}

- (void)didClickHotButton:(UIButton*)sender {
    self.selectedType = SKMarketSelectedTypeShop;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKTicketTableViewCell class])];
    if (cell==nil) {
        cell = [[SKTicketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKTicketTableViewCell class])];
    }
    cell.ticket = self.dataArray[indexPath.row];
    UITapGestureRecognizer *tapGesture_ticket = [[UITapGestureRecognizer alloc] init];
    [[tapGesture_ticket rac_gestureSignal] subscribeNext:^(id x) {
        [self invokeLoginViewController];
    }];
    [cell.rightImageView addGestureRecognizer:tapGesture_ticket];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKTicketTableViewCell *cell = (SKTicketTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight+15;
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
    DLog(@"%lf", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2) {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = (self.view.width-TITLEVIEW_WIDTH)/2;
            _titleView.height = TITLEVIEW_HEIGHT;
            _titleView.width = TITLEVIEW_WIDTH;
            _titleView.layer.cornerRadius = 5;
            
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
        if (self.selectedType==SKMarketSelectedTypeTicket) {
            [_button_follow setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
            [_button_hot setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                _markLine.centerX = _button_follow.centerX;
                _markLine.bottom = _titleView.height;
            }];
        } else if (self.selectedType==SKMarketSelectedTypeShop){
            [_button_follow setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
            [_button_hot setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                _markLine.centerX = _button_hot.centerX;
                _markLine.bottom = _titleView.height;
            }];
        } else {
            
        }
    }
}

@end

