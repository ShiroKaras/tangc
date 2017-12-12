//
//  SKTopicListTableViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/12/11.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTopicListTableViewController.h"
#import "SKTopicListTableViewCell.h"

@interface SKTopicListTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKTag*> *dataArray;
@property (nonatomic, strong) NSMutableArray *selectIndexs;
@end

@implementation SKTopicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    _selectIndexs = [NSMutableArray new];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[SKTopicListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKTopicListTableViewCell class])];
    [self.view addSubview:self.tableView];
    
    UIButton *nextButton = [UIButton new];
    [nextButton setTitle:@"继续" forState:UIControlStateNormal];
    [nextButton setTitleColor:COMMON_TEXT_CONTENT_COLOR forState:UIControlStateNormal];
    nextButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    [self.view addSubview:nextButton];
    nextButton.size = CGSizeMake(44, 44);
    nextButton.right = self.view.right-ROUND_WIDTH_FLOAT(10);
    nextButton.centerY = 42;
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:^{
            if ([_delegate respondsToSelector:@selector(didClickBackButtonInTopicListController:selectedArray:)]) {
                [_delegate didClickBackButtonInTopicListController:self selectedArray:self.dataArray];
            }
        }];
    }];
    
    [[[SKServiceManager sharedInstance] topicService] getTopicNameListWithCallback:^(BOOL success, NSArray<SKTag *> *tagList) {
        self.dataArray = [NSMutableArray arrayWithArray:tagList];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROUND_WIDTH_FLOAT(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKTopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKTopicListTableViewCell class]) forIndexPath:indexPath];
    cell.topicLabel.text = [NSString stringWithFormat:@"#%@#", self.dataArray[indexPath.row].name];
    [cell.topicLabel sizeToFit];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        self.dataArray[indexPath.row].is_check = !self.dataArray[indexPath.row].is_check;
        cell.isCheck = self.dataArray[indexPath.row].is_check;
    }];
    [cell addGestureRecognizer:tapGesture];
    return cell;
    
    
}

@end
