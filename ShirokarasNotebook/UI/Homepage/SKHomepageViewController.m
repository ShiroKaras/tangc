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

#define HEADERVIEW_HEIGHT ROUND_WIDTH_FLOAT(180)
#define TITLEVIEW_WIDTH ROUND_WIDTH_FLOAT(240)
#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

typedef NS_ENUM(NSInteger, SKHomepageSelectedType) {
    SKHomepageSelectedTypeFollow,
    SKHomepageSelectedTypeHot
};

@interface SKHomepageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *button_follow;
@property (nonatomic, strong) UIButton *button_hot;
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, assign) SKHomepageSelectedType selectedType;
@end

@implementation SKHomepageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.tableView registerClass:[SKHomepageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    [self.view addSubview:_tableView];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(202))];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
    headerImageView.backgroundColor = [UIColor blackColor];
    [headerView addSubview:headerImageView];
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADERVIEW_HEIGHT, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(22))];
    [headerView addSubview:blankView];
    self.tableView.tableHeaderView = headerView;
    
#ifdef __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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
    [_button_follow setTitle:@"关注" forState:UIControlStateNormal];
    [_button_follow setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    _button_follow.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    _button_follow.size = CGSizeMake(TITLEVIEW_HEIGHT, TITLEVIEW_HEIGHT);
    _button_follow.centerY = _titleView.height/2;
    _button_follow.left = ROUND_WIDTH_FLOAT(60);
    [_titleView addSubview:_button_follow];
    
    _button_hot = [UIButton new];
    [_button_hot addTarget:self action:@selector(didClickHotButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button_hot setTitle:@"热门" forState:UIControlStateNormal];
    [_button_hot setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
    _button_hot.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    _button_hot.size = CGSizeMake(TITLEVIEW_HEIGHT, TITLEVIEW_HEIGHT);
    _button_hot.centerY = _titleView.height/2;
    _button_hot.right = _titleView.width-ROUND_WIDTH_FLOAT(60);
    [_titleView addSubview:_button_hot];
    
    _markLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(20), 2)];
    _markLine.backgroundColor = [UIColor colorWithHex:0x37ECBA];
    _markLine.centerX = _button_follow.centerX;
    _markLine.bottom = _titleView.height;
    [_titleView addSubview:_markLine];
    self.selectedType = SKHomepageSelectedTypeFollow;
}

- (void)didClickFollowButton:(UIButton*)sender {
    self.selectedType = SKHomepageSelectedTypeFollow;
}

- (void)didClickHotButton:(UIButton*)sender {
    self.selectedType = SKHomepageSelectedTypeHot;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    if (cell==nil) {
        cell = [[SKHomepageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKHomepageTableViewCell class])];
    }
    cell.type = SKHomepageTableViewCellTypeArticle;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageTableViewCell *cell = (SKHomepageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageMorePicDetailViewController *controller = [[SKHomepageMorePicDetailViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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
        if (self.selectedType==SKHomepageSelectedTypeFollow) {
            [_button_follow setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
            [_button_hot setTitleColor:COMMON_TEXT_PLACEHOLDER_COLOR forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                _markLine.centerX = _button_follow.centerX;
                _markLine.bottom = _titleView.height;
            }];
        } else if(self.selectedType==SKHomepageSelectedTypeHot){
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
