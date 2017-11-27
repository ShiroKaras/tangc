//
//  SKUserListViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKUserListViewController.h"
#import "SKUserListTableViewCell.h"

@interface SKUserListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation SKUserListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    [self createTitleView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+ROUND_WIDTH_FLOAT(44), self.view.width, self.view.height-20-ROUND_WIDTH_FLOAT(44)) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[SKUserListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKUserListTableViewCell class])];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTitleView {
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, ROUND_WIDTH_FLOAT(44))];
    [self.view addSubview:titleBackView];
    
    UILabel *mTitleLabel = [UILabel new];
    mTitleLabel.text = [NSString stringWithFormat:@"我的关注(%ld)", self.dataArray.count];
    mTitleLabel.textColor = COMMON_TEXT_COLOR;
    mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [mTitleLabel sizeToFit];
    [titleBackView addSubview:mTitleLabel];
    mTitleLabel.centerX = titleBackView.width/2;
    mTitleLabel.centerY = titleBackView.height/2;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKUserListTableViewCell class])];
    if (cell==nil) {
        cell = [[SKUserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKUserListTableViewCell class])];
    }
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
    //    return _dataArray.count;
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
