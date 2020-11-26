//
//  JSBChannelPopViewController.m
//  jieshuibao
//
//  Created by 邵梦 on 2019/6/22.
//  Copyright © 2019年 com.jieshuibao1. All rights reserved.
//

#import "CBPrivacyPolicyPopViewController.h"
#import "UIView+STFrame.h"
#import "UILabel+Extension.h"
//#import "UILabel+YBAttributeTextTapAction.h"
//#import "YJLAttributesLabel.h"

@interface CBPrivacyPolicyPopViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *subTitleLabel;
@property (nonatomic, strong) UIButton *operationBtn;

//@property (nonatomic, strong) UIView *horizontalLine;
//@property (nonatomic, strong) UIView *VerticalLine;

@property (nonatomic, copy) BtnClickBlock btnClickBlock;
@property (nonatomic, copy) leftBtnClickBlock leftbtnClickBlock;

@end

@implementation CBPrivacyPolicyPopViewController
+ (instancetype)shareInstance
{
    static CBPrivacyPolicyPopViewController *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CBPrivacyPolicyPopViewController alloc] init];
    });
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
    [self makeView];

}
- (void)makeView{
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.subTitleLabel];
//    [self.backView addSubview:self.horizontalLine];
//    [self.backView addSubview:self.VerticalLine];

    [self.backView addSubview:self.cancleBtn];
    [self.backView addSubview:self.operationBtn];
    
}
- (void)initViewWithTitle:(NSString *)title subTilte:(NSString *)subTitle rightBtnTitle:(NSString *)btnTitle BtnBlock:(BtnClickBlock)btnClickBlock{
    self.view.alpha = 1.f;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    _btnClickBlock = btnClickBlock;
    
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;

    [_operationBtn setTitle : btnTitle
                   forState : UIControlStateNormal];
    
    [_cancleBtn setTitle : @"关闭"
                forState : UIControlStateNormal];
}
- (void)initViewWithTitle:(NSString *)title subTilte:(NSString *)subTitle leftBtnTitle:(NSString *)leftBtnTitle leftBtnBlock:(leftBtnClickBlock)leftBtnBlock rightBtnTitle:(NSString *)btnTitle BtnBlock:(BtnClickBlock)btnClickBlock{
    self.view.alpha = 1.f;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];

    _btnClickBlock = btnClickBlock;
    _leftbtnClickBlock = leftBtnBlock;
    
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    [_operationBtn setTitle : btnTitle
                   forState : UIControlStateNormal];
    
    [_cancleBtn setTitle : leftBtnTitle
                forState : UIControlStateNormal];
}
- (void)initPrivacyViewWithTitle:(NSString *)title subTilte:(NSString *)subTitle leftBtnTitle:(NSString *)leftBtnTitle leftBtnBlock:(leftBtnClickBlock)leftBtnBlock rightBtnTitle:(NSString *)btnTitle BtnBlock:(BtnClickBlock)btnClickBlock{
    self.view.alpha = 1.f;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    window.windowLevel = UIWindowLevelAlert - 1;

    _btnClickBlock = btnClickBlock;
    _leftbtnClickBlock = leftBtnBlock;
    
    self.titleLabel.text = title;
    
    NSString *str1 = @"欢迎使用中国债券信息网app！为了保护您的隐私和使用安全，请您务必仔细阅读我们的";
    NSString *str2 = @"《用户协议》";
    NSString *str3 = @"和";
    NSString *str4 = @"《隐私政策》";
    NSString *str5 = @"。在确认充分理解并同意后再开始使用此应用。感谢！";

    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",str1,str2,str3,str4,str5];
    
    NSRange range1 = [str rangeOfString:str1];
    NSRange range2 = [str rangeOfString:str2];
    NSRange range3 = [str rangeOfString:str3];
    NSRange range4 = [str rangeOfString:str4];
    NSRange range5 = [str rangeOfString:str5];

    
//    UITextView *textView = [[UITextView alloc] init];
//    textView.frame = CGRectMake(40, 100, 300, 350);
//    textView.editable = NO;
//    textView.delegate = self;
//    [self.view addSubview:textView];
    
    
    NSMutableAttributedString *mastring = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range3];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range4];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range5];

    
    // 1.必须要用前缀（firstPerson，secondPerson），随便写但是要有
    // 2.要有后面的方法，如果含有中文，url会无效，所以转码
    
    NSString *valueString2 = [[NSString stringWithFormat:@"firstPerson://%@",str2] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSString *valueString4 = [[NSString stringWithFormat:@"secondPerson://%@",str4] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [mastring addAttribute:NSLinkAttributeName value:valueString2 range:range2];
    [mastring addAttribute:NSLinkAttributeName value:valueString4 range:range4];
    
    self.subTitleLabel.attributedText = mastring;
    
    [_operationBtn setTitle : btnTitle
                   forState : UIControlStateNormal];
    
    [_cancleBtn setTitle : leftBtnTitle
                forState : UIControlStateNormal];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    __weak __typeof(self)weakSelf = self;

    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        
        NSString *tempStr = @"《用户协议》";
        if(weakSelf.PrivacyClickBlock){
            weakSelf.PrivacyClickBlock(tempStr);
        }
        
        return NO;
        
    } else if ([[URL scheme] isEqualToString:@"secondPerson"]) {
        
        NSString *tempStr = @"《隐私政策》";

        if(weakSelf.PrivacyClickBlock){
            weakSelf.PrivacyClickBlock(tempStr);
        }
        return NO;
        
    }
    
    return YES;
    
}

- (void)makeClickText{
    
   
}

- (void)initViewWithTitle:(NSString *)title subAttributedTilte:(NSAttributedString *)subAttributedTitle rightBtnTitle:(NSString *)btnTitle BtnBlock:(BtnClickBlock)btnClickBlock{
    self.view.alpha = 1.f;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    _btnClickBlock = btnClickBlock;

    self.titleLabel.text = title;
    self.subTitleLabel.attributedText = subAttributedTitle;
    [_operationBtn setTitle : btnTitle
                   forState : UIControlStateNormal];
}

-(void)initViewWithBtnBlock:(BtnClickBlock)btnClickBlock{
    self.view.alpha = 1.f;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    _btnClickBlock = btnClickBlock;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.backView.st_size = CGSizeMake(SCREEN_WIDTH - 52, 230);
    self.backView.center = self.view.center;
    
//    [self.backView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(31);
//        make.right.equalTo(self.view).offset(-31);
//        make.center.equalTo(self.view);
//    }];
    
    self.titleLabel.st_size = CGSizeMake(self.backView.st_size.width, 20);
    self.titleLabel.st_top = 20;
    
//    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(20);
//        make.top.equalTo(self.backView).offset(20);
//        make.centerX.equalTo(self.backView);
//    }];
    
    self.subTitleLabel.st_size = CGSizeMake(self.backView.st_size.width - 52, 98);
    self.subTitleLabel.st_top = 16 + self.titleLabel.st_bottom;
    self.subTitleLabel.st_left = 26;

    
//    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.bottom).offset(25);
//        make.left.equalTo(self.backView).mas_offset(26);
//        make.right.equalTo(self.backView).mas_offset(-26);
//        make.centerX.equalTo(self.backView);
//        make.bottom.equalTo(self.backView).offset(-88);
//    }];
    
//    self.horizontalLine.st_size = CGSizeMake(self.backView.st_size.width, 2);
//    self.horizontalLine.st_bottom = self.backView.st_size.height - 36;
//
//    self.VerticalLine.st_size = CGSizeMake(2, 36);
//    self.VerticalLine.st_bottom = self.backView.st_size.height;

    
    self.cancleBtn.st_size = CGSizeMake(100, 36);
    self.cancleBtn.st_left = 26;
    self.cancleBtn.st_top = self.subTitleLabel.st_bottom + 20;
//    [self.cancleBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backView).mas_offset(26);
//        make.height.equalTo(38);
//        make.right.equalTo(self.operationBtn.mas_left).mas_offset(-14);
//        make.top.equalTo(self.subTitleLabel.bottom).mas_offset(25);
//    }];
//
    self.operationBtn.st_size = self.cancleBtn.st_size;
    self.operationBtn.st_right = self.backView.st_size.width - 26;
    self.operationBtn.st_top = self.cancleBtn.st_top;
//    [self.operationBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(self.cancleBtn);
//        make.top.equalTo(self.cancleBtn);
//        make.right.equalTo(self.backView).mas_offset(-26);
//    }];
    
}
- (void)operationBtnClick{
    
    NSLog(@"operationBtnClick");
    [self.view removeFromSuperview];

    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}
- (void)cancleBtnClick{
    NSLog(@"cancleBtnClick");

    [self.view removeFromSuperview];

    if (self.leftbtnClickBlock) {
        self.leftbtnClickBlock();
    }
    
}
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 4.0;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CBRGBColor(51, 51, 51);
        _titleLabel.font = Font(17);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UITextView *)subTitleLabel{
    if(!_subTitleLabel){
        _subTitleLabel = [[UITextView alloc] init];
        _subTitleLabel.textColor = CBRGBColor(102, 102, 102);
        _subTitleLabel.font = Font(15);
        _subTitleLabel.backgroundColor = [UIColor whiteColor];
        _subTitleLabel.userInteractionEnabled = YES;
        _subTitleLabel.editable = NO;
        _subTitleLabel.delegate = self;

//        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _subTitleLabel.numberOfLines = 0;
        
    }
    return _subTitleLabel;
}
//- (UIView *)horizontalLine{
//    if(!_horizontalLine){
//        _horizontalLine = [UIView new];
//        _horizontalLine.backgroundColor = CBRGBColor(230, 227, 224);
//    }
//    return  _horizontalLine;
//}
//- (UIView *)VerticalLine{
//    if(!_VerticalLine){
//        _VerticalLine = [UIView new];
//        _VerticalLine.backgroundColor = CBRGBColor(230, 227, 224);
//    }
//    return  _horizontalLine;
//}

- (UIButton *)cancleBtn{
    if(!_cancleBtn){
        _cancleBtn = [UIButton new];
        _cancleBtn.backgroundColor = CBRGBColor(170, 170, 170);
        [_cancleBtn setTitle : @"关闭"
                    forState : UIControlStateNormal];
        _cancleBtn.titleLabel.font = Font(15);
        [_cancleBtn addTarget : self
                       action : @selector(cancleBtnClick)
             forControlEvents : UIControlEventTouchUpInside];
        _cancleBtn.layer.cornerRadius = 4.0;
        _cancleBtn.layer.masksToBounds = YES;
    }
    return _cancleBtn;
}
- (UIButton *)operationBtn{
    if(!_operationBtn){
        _operationBtn = [UIButton new];
        _operationBtn.backgroundColor = [UIColor orangeColor];//JSBRGBColor(40, 183, 163);
        _operationBtn.titleLabel.font = Font(15);
        [_operationBtn addTarget : self
                          action : @selector(operationBtnClick)
                forControlEvents : UIControlEventTouchUpInside];
        _operationBtn.layer.cornerRadius = 4.0;
        _operationBtn.layer.masksToBounds = YES;
    }
    return _operationBtn;
}

@end
