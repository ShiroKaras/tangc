//
//  SKPublishNewContentViewController.m
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPublishNewContentViewController.h"
#import "UIViewController+ImagePicker.h"

@interface SKPublishNewContentViewController ()
@property (nonatomic, assign) SKPublishType type;
@property (nonatomic, strong) SKTopic *topic;
@property (nonatomic, strong) NSMutableArray *postImageArray;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textCountLabel;
@property (nonatomic, strong) UIView *buttonsBackView;
@property (nonatomic, strong) UIView *imagesArrayBackView;
@property (nonatomic, strong) UIButton *addImageButton;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.postImageArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postImageArray" object:self.postImageArray];
    [self createTitleView];
    
    //=========================文本部分=========================
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 20+ROUND_WIDTH_FLOAT(44+15), self.view.width-30, ROUND_WIDTH_FLOAT(105))];
    _textView.font = PINGFANG_FONT_OF_SIZE(14);
    _textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    
    _textCountLabel = [UILabel new];
    _textCountLabel.text = @"200/200";
    _textCountLabel.textColor = COMMON_TEXT_PLACEHOLDER_COLOR;
    _textCountLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(9);
    [_textCountLabel sizeToFit];
    _textCountLabel.top = _textView.bottom+ROUND_WIDTH_FLOAT(15);
    _textCountLabel.right = _textView.right;
    [self.view addSubview:_textCountLabel];
    
    _imagesArrayBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _textCountLabel.bottom+ROUND_WIDTH_FLOAT(15), self.view.width, 1000)];
    [self.view addSubview:_imagesArrayBackView];
    
    [[_textView.rac_textSignal filter:^BOOL(NSString *value) {
        return value;
    }]
     subscribeNext:^(NSString *x) {
         if (x.length>=140) {
             _textView.text = [x substringWithRange:NSMakeRange(0, 140)];
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
             NSLog(@"%@  %@",NSStringFromRange(result.range),[x substringWithRange:result.range]);
             //set font
             [attrStr addAttribute:NSFontAttributeName value:PINGFANG_FONT_OF_SIZE(14) range:NSMakeRange(0, x.length)];
             // 设置颜色
             [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
         }
         self.textView.attributedText = attrStr;
     }];
    
    [self.view endEditing:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap)];
    [self.view addGestureRecognizer:tapGesture];
    
    //=========================图片组=========================
    
    if (_type == SKPublishTypeNew) {
        float width = (SCREEN_WIDTH-ROUND_WIDTH_FLOAT(30+11))/3;
        _addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [_addImageButton setBackgroundImage:[UIImage imageNamed:@"btn_releasepage_addphoto"] forState:UIControlStateNormal];
        [_addImageButton setBackgroundImage:[UIImage imageNamed:@"btn_releasepage_addphoto_highlight"] forState:UIControlStateHighlighted];
        [_addImageButton addTarget:self action:@selector(presentSystemPhotoLibraryController) forControlEvents:UIControlEventTouchUpInside];
        [_imagesArrayBackView addSubview:_addImageButton];
        _addImageButton.left = ROUND_WIDTH_FLOAT(15);
        _addImageButton.top = 0;
    } else if (_type == SKPublishTypeRepost) {
        UIView *repostBackView = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(15), _textCountLabel.bottom+ROUND_WIDTH_FLOAT(10), ROUND_WIDTH_FLOAT(290), ROUND_WIDTH_FLOAT(74))];
        repostBackView.layer.cornerRadius = 3;
        repostBackView.backgroundColor = COMMON_HIGHLIGHT_BG_COLOR;
        [self.view addSubview:repostBackView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(54), ROUND_WIDTH_FLOAT(54))];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.from?self.topic.from.images[0]:self.topic.images[0]] placeholderImage:[UIImage imageNamed:@"MaskCopy"]];
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [repostBackView addSubview:imageView];
        imageView.left = 10;
        imageView.centerY = repostBackView.height/2;
        
        UILabel *usernameLabel = [UILabel new];
        usernameLabel.text = self.topic.from?self.topic.from.userinfo.nickname:self.topic.userinfo.nickname;
        usernameLabel.textColor = COMMON_TEXT_COLOR;
        usernameLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [usernameLabel sizeToFit];
        usernameLabel.top = imageView.top;
        usernameLabel.left = imageView.right+ROUND_WIDTH_FLOAT(12);
        [repostBackView addSubview:usernameLabel];
        
        UILabel *contentLabel = [UILabel new];
        contentLabel.text = self.topic.from?self.topic.from.content:self.topic.content;
        contentLabel.textColor = COMMON_TEXT_COLOR;
        contentLabel.font = PINGFANG_FONT_OF_SIZE(12);
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
    
    UIButton *repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [repeatButton setImage:[UIImage imageNamed:@"btn_forwardpage_remind"] forState:UIControlStateNormal];
    [repeatButton setImage:[UIImage imageNamed:@"btn_forwardpage_remind_highlight"] forState:UIControlStateHighlighted];
    repeatButton.left = topicButton.right+ ROUND_WIDTH_FLOAT(4);
    repeatButton.centerY = _buttonsBackView.height/2;
    [_buttonsBackView addSubview:repeatButton];
    
    UIButton *hideKeyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [hideKeyboardButton addTarget:self action:@selector(viewDidTap) forControlEvents:UIControlEventTouchUpInside];
    [hideKeyboardButton setImage:[UIImage imageNamed:@"btn_forwardpage_retract"] forState:UIControlStateNormal];
    [hideKeyboardButton setImage:[UIImage imageNamed:@"btn_forwardpage_retract_highlight"] forState:UIControlStateHighlighted];
    hideKeyboardButton.right = _buttonsBackView.width-8;
    hideKeyboardButton.centerY = _buttonsBackView.height/2;
    [_buttonsBackView addSubview:hideKeyboardButton];
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
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, ROUND_WIDTH_FLOAT(44))];
    [self.view addSubview:titleBackView];
    
    UIButton *saveButton = [UIButton new];
    [saveButton setTitle:@"发布" forState:UIControlStateNormal];
    [saveButton setTitleColor:COMMON_TEXT_CONTENT_COLOR forState:UIControlStateNormal];
    saveButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(15);
    [titleBackView addSubview:saveButton];
    saveButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(30), ROUND_WIDTH_FLOAT(21));
    saveButton.right = titleBackView.width -ROUND_WIDTH_FLOAT(15);
    saveButton.centerY = titleBackView.height/2;
    
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (_type == SKPublishTypeNew) {
            SKUserPost *userpost = [SKUserPost new];
            if ([self.textView.text isEqualToString:@""]||self.textView.text==nil)  userpost.content = @"转发";
            else   userpost.content = self.textView.text;
            
            if (self.postImageArray.count == 0) {
                NSLog(@"添加图片");
                return;
            } else if (self.postImageArray.count==1)
                userpost.type = 1;
            else if (self.postImageArray.count>1)
                userpost.type = 2;
            userpost.images = self.postImageArray;
            
            [[[SKServiceManager sharedInstance] topicService] postArticleWith:userpost callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"response errorcode: %ld", response.errcode);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else if (_type == SKPublishTypeRepost) {
            SKUserPost *userpost = [SKUserPost new];
            userpost.content = self.textView.text;
            userpost.parent_id = self.topic.id;
            if (self.postImageArray.count == 0) {
                NSLog(@"添加图片");
                return;
            } else if (self.postImageArray.count==1)
                userpost.type = 1;
            else if (self.postImageArray.count>1)
                userpost.type = 2;
            userpost.images = self.postImageArray;
            
            [[[SKServiceManager sharedInstance] topicService] postArticleWith:userpost callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"response errorcode: %ld", response.errcode);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else if (_type == SKPublishTypeComment) {
            SKComment *comment = [SKComment new];
            comment.article_id = self.topic.id;
            [[[SKServiceManager sharedInstance] topicService] postCommentWithComment:comment callback:^(BOOL success, SKResponsePackage *response) {
                DLog(@"response errorcode: %ld", response.errcode);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
    }];
}

- (void)viewDidTap {
    [self.view endEditing:NO];
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
