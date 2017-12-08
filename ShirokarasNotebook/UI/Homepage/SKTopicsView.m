//
//  SKTopicsViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/16.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKTopicsView.h"

#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#import "SKTopicCell.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"
#define SPACE 15
#define CELL_WIDTH ((SCREEN_WIDTH-SPACE*3)/2)

@interface SKTopicsView () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<SKTopic*> *dataArray;
@end

@implementation SKTopicsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BG_COLOR;
        [self createUI];
        [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
        [[[SKServiceManager sharedInstance] topicService] getIndexTopicListWithTopicID:0 PageIndex:0 pagesize:10 callback:^(BOOL success, NSArray<SKTopic *> *topicList) {
            self.dataArray = topicList;
            [self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (void)createUI {
     [self addSubview:self.collectionView];
    
#ifdef __IPHONE_11_0
    if ([self.collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    [self updateLayoutForOrientation:toInterfaceOrientation];
//}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(SPACE, SPACE, 0, SPACE);
        layout.headerHeight = ROUND_WIDTH_FLOAT(130);
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = SPACE;
        layout.minimumInteritemSpacing = SPACE;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, SCREEN_HEIGHT-42) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SKTopicCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SKTopicCell *cell = (SKTopicCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell.mCoverImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row].images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
    [cell.mAvatarImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row].userinfo.avatar] placeholderImage:[UIImage imageNamed:@"img_personalpage_headimage_default"]];
    cell.mUsernameLabel.text = self.dataArray[indexPath.row].userinfo.nickname;
    [cell setTopic:self.dataArray[indexPath.row].content];
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
    CGSize maxSize = CGSizeMake(CELL_WIDTH-20, ROUND_WIDTH_FLOAT(45));//labelsize的最大值
    CGSize labelSize = [self.dataArray[indexPath.row].content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(10)} context:nil].size;
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH+ROUND_WIDTH_FLOAT(6)+labelSize.height+ROUND_WIDTH_FLOAT(51));
}

@end
