//
//  SKPersonalMyPageViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPersonalMyPageViewController.h"
#import "SKUserInfoViewController.h"

#import "SKMypagePicTableViewCell.h"
#import "SKMypageArticleTableViewCell.h"
#import "SKSegmentView.h"
#import "SKMyPageHeader.h"

#define HEADERVIEW_HEIGHT ROUND_WIDTH_FLOAT(180)
#define TITLEVIEW_WIDTH ROUND_WIDTH_FLOAT(240)
#define TITLEVIEW_HEIGHT ROUND_HEIGHT_FLOAT(44)

#define ITEM_WIDTH (SCREEN_WIDTH-32)/3

#define CELL_PIC_IDENTIFIER @"cell_pic"
#define CELL_ARTICLE_IDENTIFIER @"cell_article"
#define HEADER_IDENTIFIER @"headerView"
#define FOOTER_IDENTIFIER @"footerView"

typedef NS_ENUM(NSInteger, SKMyPageSelectedType) {
    SKMyPageSelectedTypePic,
    SKMyPageSelectedTypeArticle
};

@interface SKPersonalMyPageViewController () <UITableViewDelegate, UITableViewDataSource, SKSegmentViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) SKMyPageSelectedType selectedType;
@property (nonatomic, strong) UILabel *label_follow;
@property (nonatomic, strong) UILabel *label_fans;
@end

@implementation SKPersonalMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    [self createUI];
    [self addObserver:self forKeyPath:@"selectedType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selectedType"];
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)  style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[SKMypagePicTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SKMypagePicTableViewCell class])];
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(212))];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
    headerImageView.image = COMMON_PLACEHOLDER_IMAGE;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.layer.masksToBounds = YES;
    [headerView addSubview:headerImageView];
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADERVIEW_HEIGHT, SCREEN_WIDTH, ROUND_WIDTH_FLOAT(22))];
    [headerView addSubview:blankView];
    _tableView.tableHeaderView = headerView;
    
    UIImageView *_avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(66), ROUND_WIDTH_FLOAT(66))];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[SKStorageManager sharedInstance].userInfo.avatar] placeholderImage:COMMON_AVATAR_PLACEHOLDER_IMAGE];
    _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(33);
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.top = ROUND_WIDTH_FLOAT(38);
    _avatarImageView.centerX = headerView.centerX;
    [headerView addSubview:_avatarImageView];
    
    UILabel *_mTitleLabel = [UILabel new];
    _mTitleLabel.text = [SKStorageManager sharedInstance].userInfo.nickname;
    _mTitleLabel.textColor = [UIColor whiteColor];
    _mTitleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
    [_mTitleLabel sizeToFit];
    _mTitleLabel.top = _avatarImageView.bottom +ROUND_WIDTH_FLOAT(10);
    _mTitleLabel.centerX = self.view.centerX;
    [headerView addSubview:_mTitleLabel];
    
    _label_follow = [UILabel new];
    _label_follow.text = [NSString stringWithFormat:@"关注 %ld", [SKStorageManager sharedInstance].userInfo.follows];
    _label_follow.textColor = [UIColor whiteColor];
    _label_follow.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [_label_follow sizeToFit];
    _label_follow.right = headerView.width/2-5;
    _label_follow.top = _mTitleLabel.bottom+ROUND_WIDTH_FLOAT(6);
    [headerView addSubview:_label_follow];
    
    _label_fans = [UILabel new];
    _label_fans.text = [NSString stringWithFormat:@"粉丝 %ld", [SKStorageManager sharedInstance].userInfo.follows];
    _label_fans.textColor = [UIColor whiteColor];
    _label_fans.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
    [_label_fans sizeToFit];
    _label_fans.left = headerView.width/2+5;
    _label_fans.top = _mTitleLabel.bottom +ROUND_WIDTH_FLOAT(6);
    [headerView addSubview:_label_fans];
    
#ifdef __IPHONE_11_0
    if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
#endif
    
    
    //TitleView
    _titleView = [[SKSegmentView alloc] initWithFrame:CGRectMake(0, 0, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT)  titleNameArray:@[@"图片", @"文章"]];
    _titleView.delegate = self;
    _titleView.layer.cornerRadius = 3;
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.top = HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2;
    _titleView.centerX = self.view.centerX;
    _titleView.userInteractionEnabled = YES;
    [_tableView addSubview:_titleView];
    self.selectedType = SKMyPageSelectedTypePic;
    
    //编辑资料
    UIButton *editInfoButton = [UIButton new];
    [editInfoButton addTarget:self action:@selector(didClickEditInfoButton) forControlEvents:UIControlEventTouchUpInside];
    [editInfoButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    [editInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editInfoButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    editInfoButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(60), ROUND_WIDTH_FLOAT(21));
    editInfoButton.top = ROUND_WIDTH_FLOAT(31.5);
    editInfoButton.right = self.view.right -ROUND_WIDTH_FLOAT(15);
    [self.view addSubview:editInfoButton];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = [SKStorageManager sharedInstance].loginUser.nickname;
    _nameLabel.textColor =COMMON_TEXT_COLOR;
    _nameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [_nameLabel sizeToFit];
    
    [[[SKServiceManager sharedInstance] profileService] getUserInfoWithCallback:^(BOOL success, SKUserInfo *userInfo) {
        self.label_follow.text = [NSString stringWithFormat:@"关注 %ld", userInfo.follows];
        self.label_fans.text = [NSString stringWithFormat:@"粉丝 %ld", userInfo.fans];
        [self.label_follow sizeToFit];
        [self.label_fans sizeToFit];
        _label_follow.right = headerView.width/2-5;
        _label_fans.left = headerView.width/2+5;
    }];
}

#pragma mark - Actions

- (void)didClickEditInfoButton {
    SKUserInfoViewController *controller = [[SKUserInfoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - SKSegment Delegate

- (void)segmentView:(SKSegmentView *)view didClickIndex:(NSInteger)index {
    self.selectedType = index;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedType) {
            case SKMyPageSelectedTypePic:{
                SKMypagePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKMypagePicTableViewCell class])];
                if (cell==nil) {
                    cell = [[SKMypagePicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKMypagePicTableViewCell class])];
                }
                return cell;
            }
            case SKMyPageSelectedTypeArticle :{
                SKMypageArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKMypageArticleTableViewCell class])];
                if (cell==nil) {
                    cell = [[SKMypageArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SKMypageArticleTableViewCell class])];
                }
                return cell;
            }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROUND_WIDTH_FLOAT(102);
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (int)ceil(self.dataArray.count/3.0);
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
            _titleView.layer.cornerRadius = 3;
        } completion:^(BOOL finished) {
            [_titleView removeFromSuperview];
            _titleView.frame = CGRectMake((self.view.width-_titleView.width)/2, HEADERVIEW_HEIGHT-TITLEVIEW_HEIGHT/2, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT);
            [_tableView addSubview:_titleView];
            
            [self.nameLabel removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            _titleView.left = 0;
            _titleView.width = SCREEN_WIDTH;
            _titleView.layer.cornerRadius = 0;
        } completion:^(BOOL finished) {
            [_titleView removeFromSuperview];
            _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20+TITLEVIEW_HEIGHT*2);
            [self.view addSubview:_titleView];
            
            [_titleView addSubview:self.nameLabel];
            self.nameLabel.centerX = self.view.centerX;
            self.nameLabel.top = 20+ROUND_WIDTH_FLOAT(9.5);
        }];
    }
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedType"]) {
        [_tableView reloadData];
        switch (_selectedType) {
            case SKMyPageSelectedTypePic:{
                break;
            }
            case SKMyPageSelectedTypeArticle:{
                
                break;
            }
            default:
                break;
        }
    }
}

@end
