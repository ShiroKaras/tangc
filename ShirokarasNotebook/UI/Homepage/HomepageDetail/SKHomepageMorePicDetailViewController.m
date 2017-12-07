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
@property (nonatomic, strong) NSArray<SKComment*> *dataArray;
@property (nonatomic, strong) SKTopic *topic;
@end

@implementation SKHomepageMorePicDetailViewController

- (instancetype)initWithTopic:(SKTopic*)topic
{
    self = [super init];
    if (self) {
        _topic = topic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[SKHomepageDetaillTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(220))];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.width-10, headerView.height-ROUND_WIDTH_FLOAT(20))];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    
    SKTitleBaseView *baseInfoView = [[SKTitleBaseView alloc] initWithFrame:CGRectMake(0, 0, backView.width, ROUND_WIDTH_FLOAT(60))];
    baseInfoView.userInfo = _topic.from?_topic.from.userinfo:_topic.userinfo;
    [backView addSubview:baseInfoView];
    //关注
    [[baseInfoView.followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.topic.is_follow) {
            [[[SKServiceManager sharedInstance] profileService] unFollowsUserID:[NSString stringWithFormat:@"%ld", (long)self.topic.userinfo.id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"取消关注");
                    self.topic.is_follow = 0;
                    [baseInfoView.followButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_follow"] forState:UIControlStateNormal];
                }
            }];
        } else {
            [[[SKServiceManager sharedInstance] profileService] doFollowsUserID:[NSString stringWithFormat:@"%ld", (long)self.topic.userinfo.id] callback:^(BOOL success, SKResponsePackage *response) {
                if (success) {
                    NSLog(@"成功关注");
                    self.topic.is_follow = 1;
                    [baseInfoView.followButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_follow_highlight"] forState:UIControlStateNormal];
                }
            }];
        }
    }];
    
    
    CGSize maxSize = CGSizeMake(ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(40));
    
    NSString *contentText = _topic.from?_topic.from.content:_topic.content;
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = contentText;
    contentLabel.textColor = COMMON_TEXT_COLOR;
    contentLabel.numberOfLines = 2;
    contentLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    CGSize labelSize = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(12)} context:nil].size;
    contentLabel.size = labelSize;
    contentLabel.top = baseInfoView.bottom;
    contentLabel.left = ROUND_WIDTH_FLOAT(15);
    [backView addSubview:contentLabel];
    
    NSArray *imagesArray = _topic.from?_topic.from.images:_topic.images;
    float width = (SCREEN_WIDTH-ROUND_WIDTH_FLOAT(30+11))/3;
    for (int i=0; i<imagesArray.count; i++) {
        int j = i%3;
        int k = floor(i/3);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesArray[i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3;
        [backView addSubview:imageView];
        imageView.left = ROUND_WIDTH_FLOAT(15)+j*ROUND_WIDTH_FLOAT(93+5.5);
        imageView.top = k*(ROUND_WIDTH_FLOAT(5.5)+ROUND_WIDTH_FLOAT(93+5.5)) +contentLabel.bottom+ROUND_WIDTH_FLOAT(15);
        
        headerView.height = imageView.bottom +ROUND_WIDTH_FLOAT(56);
        backView.height = headerView.height-ROUND_WIDTH_FLOAT(20);
    }
    
    self.tableView.tableHeaderView = headerView;
    
    
    [[[SKServiceManager sharedInstance] topicService] getArticleDetailWithArticleID:_topic.from?_topic.from.id:_topic.id callback:^(BOOL success, SKTopic *topic) {
        self.topic = topic;
    }];
    [[[SKServiceManager sharedInstance] topicService] getCommentListWithArticleID:self.topic.id page:1 pagesize:10 callback:^(BOOL success, NSArray<SKComment *> *commentList) {
        self.dataArray = commentList;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageDetaillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    if (cell==nil) {
        cell = [[SKHomepageDetaillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKHomepageDetaillTableViewCell class])];
    }
    cell.comment = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKHomepageDetaillTableViewCell *cell = (SKHomepageDetaillTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(37))];
    headerView.backgroundColor = [UIColor clearColor];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 30)];
//    view.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:view];
//    //指定圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = view.bounds;
//    maskLayer.path = maskPath.CGPath;
//    view.layer.mask = maskLayer;

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [NSString stringWithFormat:@"评论（%ld）", self.dataArray.count];
    titleLabel.textColor = COMMON_TEXT_COLOR;
    titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [titleLabel sizeToFit];
    titleLabel.left = 10;
    titleLabel.centerY = 15;
    [headerView addSubview:titleLabel];
    return headerView;
}

#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
