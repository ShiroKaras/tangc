//
//  SKPersonalMyPageViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPersonalMyPageViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "CHTCollectionViewWaterfallFooter.h"

#import "SKPersonalPicCollectionViewCell.h"
#import "SKPersonalArticleCollectionViewCell.h"
#import "SKMyPageHeader.h"

#import "SKSegmentView.h"

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

@interface SKPersonalMyPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, SKSegmentViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SKSegmentView *titleView;
@property (nonatomic, strong) UIButton *button_follow;
@property (nonatomic, strong) UIButton *button_hot;
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, assign) SKMyPageSelectedType selectedType;
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
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    [self.view addSubview:self.collectionView];
    
#ifdef __IPHONE_11_0
    if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
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
    [_collectionView addSubview:_titleView];
    self.selectedType = SKMyPageSelectedTypePic;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = HEADERVIEW_HEIGHT+TITLEVIEW_HEIGHT/2;
        layout.footerHeight = 0;
        //列间距
        layout.minimumColumnSpacing = 6;
        //行间距
        layout.minimumInteritemSpacing = 6;
        layout.columnCount =3;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SKPersonalPicCollectionViewCell class]
            forCellWithReuseIdentifier:CELL_PIC_IDENTIFIER];
        [_collectionView registerClass:[SKPersonalArticleCollectionViewCell class]
            forCellWithReuseIdentifier:CELL_ARTICLE_IDENTIFIER];
        [_collectionView registerClass:[SKMyPageHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - SKSegment Delegate

- (void)segmentView:(UIView *)view didClickIndex:(NSInteger)index {
    self.selectedType = index;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 25;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SKPersonalPicCollectionViewCell *cell =(SKPersonalPicCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_PIC_IDENTIFIER forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ITEM_WIDTH, ITEM_WIDTH);
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
            [_collectionView addSubview:_titleView];
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
        }];
    }
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedType"]) {
        switch (_selectedType) {
            case SKMyPageSelectedTypePic:{
                [_collectionView reloadData];
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
