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
#import "UILabel+YBAttributeTextTapAction.h"
#import "YJLAttributesLabel.h"

@interface CBPrivacyPolicyPopViewController ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YJLAttributesLabel *subTitleLabel;
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
    
    
    //欢迎使用中国债券
    NSString *temp = subTitle;
    NSMutableArray * arr_text  = [[NSMutableArray alloc]initWithObjects:@"用户协议",@"隐私政策", nil];//点击的文字设置
    NSMutableArray * arr_range = [[NSMutableArray alloc]initWithObjects:@"41",@"48", nil];//点击的文字开始位置设置
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:temp];
    attrStr =  [self textArr:arr_text AttributedString:attrStr Connet:temp];//点击的文字简单设置属性
    [attrStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:15]
                       range:NSMakeRange(0, attrStr.length)];
    
    __weak __typeof(self)weakSelf = self;

    self.subTitleLabel.YJLAttributesBlock = ^(NSString * _Nonnull clicktext) {//点击事件的d返回
//        if([clicktext isEqualToString:@"用户协议"]){
//
//            NSLog(@"欢迎使用");
//
//        }else{
//            NSLog(@"中国债券");
//
//        }
        if(weakSelf.PrivacyClickBlock){
            weakSelf.PrivacyClickBlock(clicktext);
        }
        
       };
    [self.subTitleLabel setAttributesText:attrStr actionText:arr_text actionRange:arr_range];//d添加到UILabel上面
    
    [_operationBtn setTitle : btnTitle
                   forState : UIControlStateNormal];
    
    [_cancleBtn setTitle : leftBtnTitle
                forState : UIControlStateNormal];
}
#pragma mark  多个点击位置进行简单设置
-(NSMutableAttributedString *)textArr:(NSMutableArray *)textarr  AttributedString:(NSMutableAttributedString *)String Connet:(NSString *)connet{
    
    for (int i=0; i<textarr.count; i++) {
        NSRange range = [connet rangeOfString:textarr[i]];
        [String addAttribute:NSLinkAttributeName
                        value:textarr[i]
                        range: range];
    }
    return String;
}
- (NSAttributedString *)getAttributeWith:(id)sender
                                  string:(NSString *)string
                               orginFont:(CGFloat)orginFont
                              orginColor:(UIColor *)orginColor
                           attributeFont:(CGFloat)attributeFont
                          attributeColor:(UIColor *)attributeColor
{
    __block  NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:string];
    [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:orginFont] range:NSMakeRange(0, string.length)];
    [totalStr addAttribute:NSForegroundColorAttributeName value:orginColor range:NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f]; //设置行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [totalStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalStr length])];
    
    if ([sender isKindOfClass:[NSArray class]]) {
        
        __block NSString *oringinStr = string;
        __weak typeof(self) weakSelf = self;
        
        [sender enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSRange range = [oringinStr rangeOfString:str];
            [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
            [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
            oringinStr = [oringinStr stringByReplacingCharactersInRange:range withString:[weakSelf getStringWithRange:range]];
        }];
        
    }else if ([sender isKindOfClass:[NSString class]]) {
        
        NSRange range = [string rangeOfString:sender];
        
        [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
        [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
    }
    return totalStr;
}
- (NSString *)getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
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
    
    self.subTitleLabel.st_size = CGSizeMake(self.backView.st_size.width - 52, 90);
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
- (YJLAttributesLabel *)subTitleLabel{
    if(!_subTitleLabel){
        _subTitleLabel = [[YJLAttributesLabel alloc] init];
        _subTitleLabel.textColor = CBRGBColor(102, 102, 102);
        _subTitleLabel.font = Font(15);
        _subTitleLabel.backgroundColor = [UIColor whiteColor];
        _subTitleLabel.userInteractionEnabled = YES;
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
