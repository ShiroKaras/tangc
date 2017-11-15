//
//  SKHomepageMorePicDetailViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/14.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKHomepageMorePicDetailViewController.h"
#import "SKHomepageDetaillTableViewCell.h"
#import "SKTitleBaseView.h"

@interface SKHomepageMorePicDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation SKHomepageMorePicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.tableView registerClass:[SKHomepageDetaillTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(220))];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, headerView.width-10, headerView.height-20)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    [headerView addSubview:backView];
    
    SKTitleBaseView *baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, backView.width, 60)];
    [backView addSubview:baseInfoView];
    
    
    
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    if (cell==nil) {
        cell = [[SKHomepageDetaillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageDetaillTableViewCell *cell = (SKHomepageDetaillTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 30)];
    view.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:view];
    //指定圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"评论 (6)";
    titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    [titleLabel sizeToFit];
    titleLabel.left = 10;
    titleLabel.centerY = 15;
    [view addSubview:titleLabel];
    return headerView;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    footerView.backgroundColor = [UIColor clearColor];
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 10)];
//    view.backgroundColor = [UIColor whiteColor];
//    [footerView addSubview:view];
//    //指定圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = view.bounds;
//    maskLayer.path = maskPath.CGPath;
//    view.layer.mask = maskLayer;
//
//    return footerView;
//}
#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 10;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return _dataArray.count;
    return 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
