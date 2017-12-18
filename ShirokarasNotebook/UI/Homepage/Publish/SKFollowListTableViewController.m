//
//  SKFollowListTableViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKFollowListTableViewController.h"
#import "SKFollowListTableViewCell.h"

@interface SKFollowListTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKUserInfo*> *dataArray;
@property (nonatomic, strong) NSMutableArray *selectIndexs;
@end

@implementation SKFollowListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    _selectIndexs = [NSMutableArray new];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (kDevice_Is_iPhoneX?44:20)+44, SCREEN_WIDTH, SCREEN_HEIGHT-((kDevice_Is_iPhoneX?44:20)+44)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[SKFollowListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKFollowListTableViewCell class])];
    [self.view addSubview:self.tableView];
    
    UIButton *nextButton = [UIButton new];
    [nextButton setTitle:@"继续" forState:UIControlStateNormal];
    [nextButton setTitleColor:COMMON_TEXT_CONTENT_COLOR forState:UIControlStateNormal];
    nextButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    [self.view addSubview:nextButton];
    nextButton.size = CGSizeMake(44, 44);
    nextButton.right = self.view.right-ROUND_WIDTH_FLOAT(10);
    nextButton.top = kDevice_Is_iPhoneX?44:20;
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:^{
            if ([_delegate respondsToSelector:@selector(didClickBackButtonInFollowListController:selectedArray:)]) {
                [_delegate didClickBackButtonInFollowListController:self selectedArray:self.dataArray];
            }
        }];
    }];
    
    [[[SKServiceManager sharedInstance] profileService] comuserFollowsWithCallback:^(BOOL success, NSArray<SKUserInfo *> *userList) {
        self.dataArray = [NSMutableArray arrayWithArray:userList];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SKFollowListTableViewCell *cell = (SKFollowListTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    self.dataArray[indexPath.row].is_check = !self.dataArray[indexPath.row].is_check;
//    cell.isCheck = self.dataArray[indexPath.row].is_check;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROUND_WIDTH_FLOAT(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKFollowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKFollowListTableViewCell class]) forIndexPath:indexPath];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row].avatar] placeholderImage:COMMON_AVATAR_PLACEHOLDER_IMAGE];
    cell.usernameLabel.text = self.dataArray[indexPath.row].nickname;
    [cell.usernameLabel sizeToFit];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        self.dataArray[indexPath.row].is_check = !self.dataArray[indexPath.row].is_check;
        cell.isCheck = self.dataArray[indexPath.row].is_check;
    }];
    [cell addGestureRecognizer:tapGesture];
    
    return cell;
}



@end
