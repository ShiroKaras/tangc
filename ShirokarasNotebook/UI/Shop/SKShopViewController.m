//
//  SKShopViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/7.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKShopViewController.h"
#import "SKTicketTableViewCell.h"
#import "SKShopTableViewCell.h"
#import "SKSegmentView.h"

#define HEADERVIEW_HEIGHT ROUND_WIDTH_FLOAT(180)
#define TITLEVIEW_WIDTH ROUND_WIDTH_FLOAT(240)
#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

typedef NS_ENUM(NSInteger, SKMarketSelectedType) {
    SKMarketSelectedTypeTicket,
    SKMarketSelectedTypeShop
};

@interface SKShopViewController () <UITableViewDelegate, UITableViewDataSource, SKSegmentViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKTicket*> *dataArray;
@property (nonatomic, strong) NSMutableArray<SKGoods*> *dataArray_goods;
@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, assign) SKMarketSelectedType selectedType;
@end

@implementation SKShopViewController {
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
 
    self.selectedType = SKMarketSelectedTypeTicket;
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
    [self.tableView registerClass:[SKTicketTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKTicketTableViewCell class])];
    [self.tableView registerClass:[SKShopTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKShopTableViewCell class])];
    [self.view addSubview:_tableView];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(212))];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
    headerImageView.image = COMMON_PLACEHOLDER_IMAGE;
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.layer.masksToBounds = YES;
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
    _titleView = [[SKSegmentView alloc] initWithFrame:CGRectMake(0, 0, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT)  titleNameArray:@[@"优惠券", @"商城"]];
    _titleView.delegate = self;
    _titleView.layer.cornerRadius = 3;
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.top = HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2;
    _titleView.centerX = self.view.centerX;
    _titleView.userInteractionEnabled = YES;
    [_tableView addSubview:_titleView];
    
    self.selectedType = SKMarketSelectedTypeTicket;
}

- (void)didClickFollowButton:(UIButton*)sender {
    self.selectedType = SKMarketSelectedTypeTicket;
}

- (void)didClickHotButton:(UIButton*)sender {
    self.selectedType = SKMarketSelectedTypeShop;
}

#pragma mark - SKSegment Delegate

- (void)segmentView:(SKSegmentView *)view didClickIndex:(NSInteger)index {
    NSLog(@"index: %ld", index);
    self.selectedType = index;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedType) {
        case SKMarketSelectedTypeTicket:{
            SKTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKTicketTableViewCell class])];
            if (cell==nil) {
                cell = [[SKTicketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKTicketTableViewCell class])];
            }
//            cell.ticket = self.dataArray[indexPath.row];
            UITapGestureRecognizer *tapGesture_ticket = [[UITapGestureRecognizer alloc] init];
            [[tapGesture_ticket rac_gestureSignal] subscribeNext:^(id x) {
                [self invokeLoginViewController];
            }];
            [cell.rightImageView addGestureRecognizer:tapGesture_ticket];
            return cell;
        }
        case SKMarketSelectedTypeShop:{
            SKShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKShopTableViewCell class])];
            if (cell==nil) {
                cell = [[SKShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKShopTableViewCell class])];
            }
            cell.leftData = self.dataArray_goods[indexPath.row * 2];
            if (self.dataArray_goods.count - 1 >= indexPath.row * 2 + 1) {
                cell.view_right.hidden = NO;
                cell.rightData = self.dataArray_goods[indexPath.row * 2 + 1];
            } else {
                cell.view_right.hidden = YES;
            }
            return cell;
        }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedType==SKMarketSelectedTypeTicket) {
        SKTicketTableViewCell *cell = (SKTicketTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight+ROUND_WIDTH_FLOAT(15);
    } else if (self.selectedType==SKMarketSelectedTypeShop) {
        return ROUND_WIDTH_FLOAT(199+15);
    } else
        return 0;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.selectedType) {
        case SKMarketSelectedTypeTicket:
            return self.dataArray.count;
        case SKMarketSelectedTypeShop:
            return (int)ceil(self.dataArray_goods.count/2.0);
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
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = (self.view.width-TITLEVIEW_WIDTH)/2;
            _titleView.height = TITLEVIEW_HEIGHT;
            _titleView.width = TITLEVIEW_WIDTH;
            _titleView.layer.cornerRadius = 3;

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
        if (self.selectedType==SKMarketSelectedTypeTicket) {
            [[[SKServiceManager sharedInstance] shopService] getTicketsListWithPage:1 pagesize:10 callback:^(BOOL success, NSArray<SKTicket *> *ticketsList) {
                self.dataArray = [NSMutableArray arrayWithArray:ticketsList];
                [self.tableView reloadData];
                scrollLock = NO;
            }];
        } else if (self.selectedType==SKMarketSelectedTypeShop){
            [[[SKServiceManager sharedInstance] shopService] getGoodsListWithPage:1 pagesize:10 callback:^(BOOL success, NSArray<SKGoods *> *goodsList) {
                self.dataArray_goods = [NSMutableArray arrayWithArray:goodsList];
                [self.tableView reloadData];
                scrollLock = NO;
            }];
        } else {
            
        }
    }
}

@end

