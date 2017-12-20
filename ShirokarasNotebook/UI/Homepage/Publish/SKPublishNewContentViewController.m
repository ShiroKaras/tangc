//
//  SKPublishNewContentViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPublishNewContentViewController.h"
#import "SKTopicListTableViewController.h"
#import "SKFollowListTableViewController.h"

#import "HXPhotoPicker.h"

static const CGFloat kPhotoViewMargin = 12.0;

@interface SKPublishNewContentViewController () <SKTopicListTableViewControllerDelegate, SKFollowListTableViewControllerDelegate, HXPhotoViewDelegate>
@property (nonatomic, assign) SKPublishType type;
@property (nonatomic, strong) SKTopic *topic;
@property (nonatomic, strong) NSMutableArray *postImageArray;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textCountLabel;
@property (nonatomic, strong) UIView *buttonsBackView;
@property (nonatomic, strong) UIView *imagesArrayBackView;
@property (nonatomic, strong) UIButton *addImageButton;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;

@property (nonatomic, strong) NSMutableArray *to_users;
@end

@implementation SKPublishNewContentViewController

- (instancetype)initWithType:(SKPublishType)type withUserPost:(SKTopic*)topic
{
    self = [super init];
    if (self) {
        _type = type;
        _topic = topic;
    }
    return self;
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = NO;
        _manager.configuration.lookLivePhoto = NO;
        _manager.configuration.photoMaxNum = 9;
        //_manager.configuration.videoMaxNum = 0;
        _manager.configuration.maxNum = 9;
        //_manager.configuration.videoMaxDuration = 500.f;
        _manager.configuration.saveSystemAblum = NO;
        //        _manager.configuration.reverseDate = YES;
        _manager.configuration.showDateSectionHeader = NO;
        //        _manager.configuration.selectTogether = NO;
        //        _manager.configuration.rowCount = 3;
        //        _manager.configuration.themeColor = [UIColor orangeColor];
        //        _manager.configuration.navigationTitleSynchColor = YES;
        _manager.configuration.navigationBar = ^(UINavigationBar *navigationBar) {
            //            navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
        };
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.postImageArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postImageArray" object:self.postImageArray];

    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?44:20, 200, ROUND_WIDTH_FLOAT(44))];
    tView.backgroundColor = [UIColor clearColor];
    tView.centerX = self.view.centerX;
    [self.view addSubview:tView];
    UILabel *tLabel = [UILabel new];
    switch (self.type) {
        case SKPublishTypeNew:
            tLabel.text = @"";
            break;
        case SKPublishTypeRepost:
            tLabel.text = @"转发";
            break;
        case SKPublishTypeComment:
            tLabel.text = @"评论";
            break;
        default:
            break;
    }
    tLabel.textColor = COMMON_TEXT_COLOR;
    tLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [tLabel sizeToFit];
    [tView addSubview:tLabel];
    tLabel.centerX = tView.width/2;
    tLabel.centerY = tView.height/2;
    
    [self createTitleView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ((kDevice_Is_iPhoneX?44:20)+ROUND_WIDTH_FLOAT(44)), self.view.width, self.view.height-((kDevice_Is_iPhoneX?44:20)+ROUND_WIDTH_FLOAT(44)))];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    //=========================文本部分=========================

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, ROUND_WIDTH_FLOAT(15), self.view.width-30, ROUND_WIDTH_FLOAT(105))];
    _textView.backgroundColor = [UIColor whiteColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attributes = @{ NSFontAttributeName:PINGFANG_ROUND_FONT_OF_SIZE(14), NSParagraphStyleAttributeName:paragraphStyle};
    _textView.attributedText = [[NSAttributedString alloc]initWithString:_textView.text attributes:attributes];
    [self.scrollView addSubview:_textView];
    
    _textCountLabel = [UILabel new];
    _textCountLabel.text = @"200/200";
    _textCountLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
    _textCountLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
    [_textCountLabel sizeToFit];
    _textCountLabel.top = _textView.bottom+ROUND_WIDTH_FLOAT(15);
    _textCountLabel.right = _textView.right;
    [self.scrollView addSubview:_textCountLabel];
    
    [[_textView.rac_textSignal filter:^BOOL(NSString *value) {
        return value;
    }]
     subscribeNext:^(NSString *x) {
         [self updateTextViewWithString:x];
     }];

    [_textView becomeFirstResponder];
    //=========================图片组=========================
    
    if (_type == SKPublishTypeNew) {

        CGFloat width = scrollView.frame.size.width;
        HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
        
        photoView.frame = CGRectMake(kPhotoViewMargin, _textCountLabel.bottom+ROUND_WIDTH_FLOAT(15), width - kPhotoViewMargin * 2, 0);
        photoView.delegate = self;
        photoView.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:photoView];
        self.photoView = photoView;
        
    } else if (_type == SKPublishTypeRepost) {
        UIView *repostBackView = [UIView new];
        repostBackView.layer.cornerRadius = 3;
        repostBackView.backgroundColor = COMMON_HIGHLIGHT_BG_COLOR;
        [self.scrollView addSubview:repostBackView];
        [repostBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textCountLabel.mas_bottom).offset(ROUND_WIDTH_FLOAT(10));
            make.left.equalTo(_textView);
            make.right.equalTo(_textView);
            make.height.equalTo(ROUND_WIDTH(74));
        }];
        [self.view layoutIfNeeded];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(54), ROUND_WIDTH_FLOAT(54))];
        if (self.topic.images.count >0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.from.id!=0?self.topic.from.images[0]:self.topic.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
        }
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [repostBackView addSubview:imageView];
        imageView.left = 10;
        imageView.centerY = repostBackView.height/2;

        UILabel *usernameLabel = [UILabel new];
        usernameLabel.text = self.topic.from.id!=0?self.topic.from.userinfo.nickname:self.topic.userinfo.nickname;
        usernameLabel.textColor = COMMON_TEXT_COLOR;
        usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [usernameLabel sizeToFit];
        usernameLabel.top = imageView.top;
        usernameLabel.left = imageView.right+ROUND_WIDTH_FLOAT(12);
        [repostBackView addSubview:usernameLabel];

        UILabel *contentLabel = [UILabel new];
        contentLabel.text = self.topic.from.id!=0?self.topic.from.content:self.topic.content;
        contentLabel.textColor = COMMON_TEXT_COLOR;
        contentLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        contentLabel.numberOfLines = 2;
        contentLabel.size = CGSizeMake(ROUND_WIDTH_FLOAT(206), ROUND_WIDTH_FLOAT(36));
        contentLabel.bottom = imageView.bottom;
        contentLabel.left = usernameLabel.left;
        [repostBackView addSubview:contentLabel];
    } else if (_type == SKPublishTypeComment) {

    }

    //=========================按钮组=========================

    _buttonsBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-44, self.view.width, 44)];
    _buttonsBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_buttonsBackView];

    //监听键盘通知
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardWillShowNotification
      object:nil]
     subscribeNext:^(NSNotification *notification) {
         NSDictionary *info = [notification userInfo];
         NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
         CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
         _buttonsBackView.frame = CGRectMake(0, self.view.height - keyboardFrame.size.height - 44, self.view.width, 44);
     }];

    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardWillHideNotification
      object:nil]
     subscribeNext:^(NSNotification *notification) {
         _buttonsBackView.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
     }];

    UIButton *topicButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [topicButton setImage:[UIImage imageNamed:@"btn_forwardpage_addtopic"] forState:UIControlStateNormal];
    [topicButton setImage:[UIImage imageNamed:@"btn_forwardpage_addtopic_highlight"] forState:UIControlStateHighlighted];
    topicButton.left = ROUND_WIDTH_FLOAT(8);
    topicButton.centerY = _buttonsBackView.height/2;
    [_buttonsBackView addSubview:topicButton];
    [[topicButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        SKTopicListTableViewController *controller = [[SKTopicListTableViewController alloc] init];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }];

    UIButton *repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [repeatButton setImage:[UIImage imageNamed:@"btn_forwardpage_remind"] forState:UIControlStateNormal];
    [repeatButton setImage:[UIImage imageNamed:@"btn_forwardpage_remind_highlight"] forState:UIControlStateHighlighted];
    repeatButton.left = topicButton.right+ ROUND_WIDTH_FLOAT(4);
    repeatButton.centerY = _buttonsBackView.height/2;
    [_buttonsBackView addSubview:repeatButton];
    [[repeatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        SKFollowListTableViewController *controller = [[SKFollowListTableViewController alloc] init];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }];

    UIButton *hideKeyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [hideKeyboardButton setImage:[UIImage imageNamed:@"btn_forwardpage_retract"] forState:UIControlStateNormal];
    [hideKeyboardButton setImage:[UIImage imageNamed:@"btn_forwardpage_retract_highlight"] forState:UIControlStateHighlighted];
    hideKeyboardButton.right = _buttonsBackView.width-8;
    hideKeyboardButton.centerY = _buttonsBackView.height/2;
    [_buttonsBackView addSubview:hideKeyboardButton];
    [[hideKeyboardButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_textView resignFirstResponder];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self removeObserver:self forKeyPath:@"postImageArray"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createTitleView {
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?44:20, self.view.width, ROUND_WIDTH_FLOAT(44))];
    [self.view addSubview:titleBackView];
    
    UIButton *saveButton = [UIButton new];
    [saveButton setTitle:@"发布" forState:UIControlStateNormal];
    [saveButton setTitleColor:COMMON_TEXT_CONTENT_COLOR forState:UIControlStateNormal];
    saveButton.titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(15);
    [titleBackView addSubview:saveButton];
    saveButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(44), ROUND_WIDTH_FLOAT(44));
    saveButton.right = titleBackView.width -ROUND_WIDTH_FLOAT(15);
    saveButton.top = 0;

    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([_textView.text isEqualToString:@""]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:@"内容不能为空"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                  }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        if (_type == SKPublishTypeNew) {
            SKUserPost *userpost = [SKUserPost new];
            if ([self.textView.text isEqualToString:@""]||self.textView.text==nil)  userpost.content = @"转发";
            else   userpost.content = self.textView.text;

            if (self.postImageArray.count == 0) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                               message:@"图片不能为空"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          
                                                                      }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            } else if (self.postImageArray.count==1)
                userpost.type = 1;
            else if (self.postImageArray.count>1)
                userpost.type = 2;
            userpost.images = self.postImageArray;
            userpost.to_user_id = self.to_users;
            
            [[[SKServiceManager sharedInstance] topicService] postArticleWith:userpost callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"response errorcode: %ld", response.errcode);
                if (response.errcode==0) {
                    [self success];
                }
            }];
        } else if (_type == SKPublishTypeRepost) {
            SKUserPost *userpost = [SKUserPost new];
            userpost.content = self.textView.text;
            userpost.parent_id = self.topic.id;
            userpost.type = self.topic.type;
            userpost.to_user_id = self.to_users;
            
            [[[SKServiceManager sharedInstance] topicService] postArticleWith:userpost callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"response errorcode: %ld", response.errcode);
                if (response.errcode==0) {
                    [self success];
                }
            }];
        } else if (_type == SKPublishTypeComment) {
            SKComment *comment = [SKComment new];
            comment.article_id = self.topic.id;
            comment.content = self.textView.text;
            
            [[[SKServiceManager sharedInstance] topicService] postCommentWithComment:comment callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"response errorcode: %ld", response.errcode);
                if (response.errcode==0) {
                    [self success];
                }
            }];
        }

    }];
}

- (void)success {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"发布成功"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateTextViewWithString:(NSString*)x {
    if (x.length>=200) {
        _textView.text = [x substringWithRange:NSMakeRange(0, 200)];
    }

    //更新字数
    _textCountLabel.text = [NSString stringWithFormat:@"%ld/200", x.length];
    [_textCountLabel sizeToFit];
    _textCountLabel.right = _textView.right;
    // 话题的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // @的规则
    NSString *atPattern = @"\\@[0-9a-zA-Z\\u4e00-\\u9fa5\\_\\-]+";

    NSString *pattern = [NSString stringWithFormat:@"%@|%@",topicPattern,atPattern];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    //匹配集合
    NSArray *results = [regex matchesInString:x options:0 range:NSMakeRange(0, x.length)];

    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[x dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                  options:@{NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType}
                                                                       documentAttributes:nil error:nil];
    // 3.遍历结果
    for (NSTextCheckingResult *result in results) {
        NSLog(@"%@  %@",NSStringFromRange(result.range),[[x substringWithRange:result.range] stringByReplacingOccurrencesOfString:@"@" withString:@""]);
        [self.to_users addObject:[[x substringWithRange:result.range] stringByReplacingOccurrencesOfString:@"@" withString:@""]];
        //set font
        // 设置颜色
        [attrStr addAttribute:NSForegroundColorAttributeName value:COMMON_GREEN_COLOR range:result.range];
    }
    [attrStr addAttribute:NSFontAttributeName value:PINGFANG_ROUND_FONT_OF_SIZE(14) range:NSMakeRange(0, x.length)];
    self.textView.attributedText = attrStr;
}

#pragma mark - HXPhotoViewDelegate

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    NSSLog(@"所有:%@ - 照片:%@ - 视频:%@",allList,photos,videos);
    
    [HXPhotoTools selectListWriteToTempPath:allList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        NSSLog(@"requestIds - image : %@ \nsessions - video : %@",imageRequestIds,videoSessions);
    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
        NSSLog(@"allUrl - %@\nimageUrls - %@\nvideoUrls - %@",allUrl,imageUrls,videoUrls);
        [self.postImageArray removeAllObjects];
        for (NSString *path in imageUrls) {
            NSData *imageData = [NSData dataWithContentsOfFile:path];
            NSString *postImage = [NSString postImageName];
            
            [[[SKServiceManager sharedInstance] qiniuService] putData:imageData key:postImage token:[[SKStorageManager sharedInstance] qiniuPublicToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                DLog(@"data = %@, key = %@, resp = %@", info, key, resp);
                if (info.statusCode == 200) {
                    [self.postImageArray insertObject:[NSString qiniuDownloadURLWithFileName:key] atIndex:0];
                } else {
                    
                }
            } option:nil];
        }
        
    } error:^{
        NSSLog(@"失败");
    }];
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
}

#pragma mark - Delegate

- (void)didClickBackButtonInTopicListController:(SKTopicListTableViewController *)controller selectedArray:(NSArray *)array {
    for (SKTag *tag in array) {
        if (tag.is_check) {
            _textView.text = [_textView.text stringByAppendingString:[NSString stringWithFormat:@"#%@# ", tag.name]];
        }
    }
    [self updateTextViewWithString:self.textView.text];
    [_textView becomeFirstResponder];
}

- (void)didClickBackButtonInFollowListController:(SKFollowListTableViewController *)controller selectedArray:(NSArray *)array {
    for (SKUserInfo *userinfo in array) {
        if (userinfo.is_check) {
            _textView.text = [_textView.text stringByAppendingString:[NSString stringWithFormat:@"@%@ ", userinfo.nickname]];
        }
    }
    [self updateTextViewWithString:self.textView.text];
    [_textView becomeFirstResponder];
}

#pragma mark - Image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar"];
    [imageData writeToFile:imagePath atomically:YES];

    NSString *postImage = [NSString postImageName];

    [[[SKServiceManager sharedInstance] qiniuService] putData:imageData key:postImage token:[[SKStorageManager sharedInstance] qiniuPublicToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        DLog(@"data = %@, key = %@, resp = %@", info, key, resp);
        if (info.statusCode == 200) {
            [self.postImageArray insertObject:[NSString qiniuDownloadURLWithFileName:key] atIndex:0];
            [self updateImagesArrayView];
        } else {

        }
    } option:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateImagesArrayView {
    for (UIView *view in _imagesArrayBackView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    float width = (SCREEN_WIDTH-ROUND_WIDTH_FLOAT(30+11))/3;
    for (int i=0; i<_postImageArray.count; i++) {
        int j = i%3;
        int k = floor(i/3);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:_postImageArray[i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3;
        [_imagesArrayBackView addSubview:imageView];
        imageView.left = ROUND_WIDTH_FLOAT(15)+j*ROUND_WIDTH_FLOAT(93+5.5);
        imageView.top = k*(ROUND_WIDTH_FLOAT(5.5)+ROUND_WIDTH_FLOAT(93+5.5));

        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(imageView.width-5-ROUND_WIDTH_FLOAT(20), 5, ROUND_WIDTH_FLOAT(20), ROUND_WIDTH_FLOAT(20))];
        deleteButton.tag = 200+i;
        [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"img_releasepage_delete"] forState:UIControlStateNormal];
        [imageView addSubview:deleteButton];
    }

    self.addImageButton.hidden = _postImageArray.count>=9?YES:NO;

    long xx = self.postImageArray.count;
    self.addImageButton.frame = CGRectMake(ROUND_WIDTH_FLOAT(15)+(xx%3)*ROUND_WIDTH_FLOAT(93+5.5), (floor(xx/3))*(ROUND_WIDTH_FLOAT(5.5)+ROUND_WIDTH_FLOAT(93+5.5)), width, width);
}

- (void)deleteImage:(UIButton *)sender {
    [_postImageArray removeObjectAtIndex:sender.tag-200];
    [self updateImagesArrayView];
}

@end
