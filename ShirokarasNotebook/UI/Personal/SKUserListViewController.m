//
//  SKUserListViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKUserListViewController.h"

@interface SKUserListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SKUserInfo*> *dataArray;
@property (nonatomic, assign) SKUserListType type;
@end

@implementation SKUserListViewController

- (instancetype)initWithType:(SKUserListType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+ROUND_WIDTH_FLOAT(44), self.view.width, self.view.height-20-ROUND_WIDTH_FLOAT(44)) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[SKUserListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKUserListTableViewCell class])];
    [self.view addSubview:_tableView];
    
    if (self.type == SKUserListTypeFollow) {
        [[[SKServiceManager sharedInstance] profileService] comuserFollowsWithCallback:^(BOOL success, NSArray<SKUserInfo *> *topicList) {
            self.dataArray = topicList;
            [self createTitleView];
            [self.tableView reloadData];
        }];
    } else {
        [[[SKServiceManager sharedInstance] profileService] comuserFansWithCallback:^(BOOL success, NSArray<SKUserInfo *> *topicList) {
            self.dataArray = topicList;
            [self createTitleView];
            [self.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTitleView {
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?44:20, 200, ROUND_WIDTH_FLOAT(44))];
    tView.backgroundColor = [UIColor clearColor];
    tView.centerX = self.view.centerX;
    [self.view addSubview:tView];
    
    UILabel *mTitleLabel = [UILabel new];
    switch (self.type) {
        case SKUserListTypeFollow:
            mTitleLabel.text = [NSString stringWithFormat:@"我的关注(%ld)", self.dataArray.count];
            break;
        case SKUserListTypeFans:
            mTitleLabel.text = [NSString stringWithFormat:@"我的粉丝(%ld)", self.dataArray.count];
            break;
        default:
            break;
    }
    mTitleLabel.textColor = COMMON_TEXT_COLOR;
    mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [mTitleLabel sizeToFit];
    [tView addSubview:mTitleLabel];
    mTitleLabel.centerX = tView.width/2;
    mTitleLabel.centerY = tView.height/2;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKUserListTableViewCell class])];
    if (cell==nil) {
        cell = [[SKUserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKUserListTableViewCell class])];
    }
    [cell setUserInfo:self.dataArray[indexPath.row] wityType:self.type];
    
    //关注
    [[cell.followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.dataArray[indexPath.row].is_follow) {
            [[[SKServiceManager sharedInstance] profileService] unFollowsUserID:[NSString stringWithFormat:@"%ld", (long)self.dataArray[indexPath.row].id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"取消关注");
                    self.dataArray[indexPath.row].is_follow = NO;
                    [cell.followButton setBackgroundImage:[UIImage imageNamed:@"btn_followpage_followe"] forState:UIControlStateNormal];
                }
            }];
        } else {
            [[[SKServiceManager sharedInstance] profileService] doFollowsUserID:[NSString stringWithFormat:@"%ld", (long)self.dataArray[indexPath.row].id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"成功关注");
                    self.dataArray[indexPath.row].is_follow = YES;
                    [cell.followButton setBackgroundImage:self.dataArray[indexPath.row].is_followed?[UIImage imageNamed:@"btn_followpage_followeeachother"]:[UIImage imageNamed:@"btn_followpage_followed"] forState:UIControlStateNormal];
                }
            }];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKUserListTableViewCell *cell = (SKUserListTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
