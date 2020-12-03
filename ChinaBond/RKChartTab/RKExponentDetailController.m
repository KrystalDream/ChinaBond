//
//  RKExponentDetailController.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/8.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKExponentDetailController.h"
#import "RKKLine.h"
#import "RKDataManager.h"
#import "CustomDatePickerView.h"
#import "JCAlertView.h"
#import "RKTimeKLine.h"
#import "RKCateLevelModel.h"
#import <AFNetworkReachabilityManager.h>

typedef enum : NSUInteger {
    RKExponentDetailStateCaifu = 0,
    RKExponentDetailStateJingjia,
} RKExponentDetailState;

@interface RKExponentDetailController ()<RKKLineDelegate>
{
    UIButton *_caifuButtonRef;
    UIButton *_jingxuanButtonRef;
    UIButton *timeButton;
    JCAlertView *_alert;
    
    BOOL    _isFullScreen;
    RKTimeKLine *_horKLine;
    
    CALayer *_navLinelayer;
    
    RKExponentDetailState _detailState;
}
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UILabel *souyilvLab;
@property (strong, nonatomic) IBOutlet UILabel *daichangqiLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneNum;
@property (strong, nonatomic) IBOutlet UILabel *phoneNum1;
@property (retain, nonatomic) CustomDatePickerView *picker;
@property (readonly, nonatomic, retain) RKKLineModel *timeModel;
@property (nonatomic, retain) NSDate *currentDate;

@end

@implementation RKExponentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"中债指数";

    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.horView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.rightView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.souyilvLab.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x963232);
    self.precentLabel.dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
    self.daichangqiLab.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x963232);
    self.yearLabel.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x963232);
    self.dateLabel.dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0x424141);
    self.phoneLab.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x424141);
    self.phoneNum.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x424141);
    
    self.headTitleLabel.text = self.exponentModel.levelTitle;

    
    _detailState = RKExponentDetailStateCaifu;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UINib *oneNib = [UINib nibWithNibName:@"RKExponentDetailCell" bundle:nil];
    UINib *twoNib = [UINib nibWithNibName:@"RKExponentDetailFooter" bundle:nil];
    [_tableView registerNib:oneNib forCellReuseIdentifier:@"RKExponentDetailCell"];
    [_tableView registerNib:twoNib forCellReuseIdentifier:@"RKExponentDetailFooter"];
    
    self.picker = [[CustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    __weak __typeof__(self) weakSelf = self;
    self.picker.cancelBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf->_alert dismissWithCompletion:^{
                
            }];
        }
    };
    self.picker.sureBlock = ^(NSString *date){
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf->_alert dismissWithCompletion:^{
                [strongSelf->timeButton setTitle:date forState:UIControlStateNormal];
                strongSelf.currentDate = [[RKDataManager sharedInstance].dateFormatter dateFromString:date];
                
                
                // 1.获得网络监控的管理者
                AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
                // 2.设置网络状态改变后的处理
                [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    // 当网络状态改变了, 就会调用这个block
                    switch (status)
                    {
                        case AFNetworkReachabilityStatusUnknown: // 未知网络
                        {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                            [MBProgressHUD bwm_showTitle:@"请连接网络" toView:self.view hideAfter:2];
                        }
                            break;
                        case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                        {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                            [MBProgressHUD bwm_showTitle:@"请连接网络" toView:self.view hideAfter:2];
                        }
                            break;
                        case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                        {
                            CBLog(@"手机自带网络");
                            [strongSelf requestForExponent:[[RKDataManager sharedInstance].dateFormatter2 stringFromDate:strongSelf.currentDate] exponentModel:strongSelf.exponentModel];
                        }
                            break;
                        case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                        {
                            CBLog(@"WIFI");
                            [strongSelf requestForExponent:[[RKDataManager sharedInstance].dateFormatter2 stringFromDate:strongSelf.currentDate] exponentModel:strongSelf.exponentModel];
                        }
                            break;
                    }
                }];
                [mgr startMonitoring];
                
            }];
        }
    };
    self.horView.hidden = YES;
    
    [self showHud];
    self.currentDate = [[RKDataManager sharedInstance] twoMonthAgo:[NSDate date]];
    NSString *bDateStr = [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:self.currentDate];
    if (self.exponentModel) {
        [self requestForExponent:bDateStr exponentModel:self.exponentModel];
    }
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        ;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //请求今日数据
    [MobClick event:@"1002"];
}

- (void)backButtonClick:(id)sender
{
    if (_navLinelayer) {
        [_navLinelayer removeFromSuperlayer];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestForExponent:(NSString *)dateString exponentModel:(RKCateLevelModel *)model
{
    NSString *todayString = [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:[NSDate date]];
    [[CBHttpRequest shareRequest] postWithUrl:kApiExponentData
                                       Params:@{@"ksr":dateString, @"jsr":todayString, @"id":model.levelID}
                              completionBlock:^(id responseObject) {
                                 // NSLog(@"%@",responseObject);
                                  if ([[(NSDictionary *)responseObject objectForKey:@"state"] isEqualToString:@"0"]) {
                                      NSArray *xArr = [(NSDictionary *)responseObject objectForKey:@"xValues"];
                                      NSArray *yArr = [(NSDictionary *)responseObject objectForKey:@"y_mValues"];
                                      NSArray *zArr = [(NSDictionary *)responseObject objectForKey:@"y_nValues"];
                                      _timeModel = [[RKKLineModel alloc] init];
                                      _timeModel.xArr = xArr;
                                      _timeModel.yArr = yArr;
                                      _timeModel.zArr = zArr;
                                      
                                      _timeModel.exponentModel = model;
                                      _timeModel.time = responseObject[@"queryDate"];

                                      [self hideHud];
                                      
                                      if (xArr.count == 0) {
                                          [MBProgressHUD bwm_showTitle:@"没有查到指数信息" toView:self.view hideAfter:2];
                                      }
                                      
                                      [_tableView reloadData];
                                  }else{
                                      NSString *errorInfo = [(NSDictionary *)responseObject objectForKey:@"errorMsg"];
                                      _timeModel = [[RKKLineModel alloc] init];
                                      _timeModel.exponentModel = model;
                                      _timeModel.time = responseObject[@"queryDate"];
                                      [self hideHud];
                                      [_tableView reloadData];
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errorInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                      [alert  show];
                                  }
                              } failBlock:^(NSError *error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                  [alert  show];
                              }];
}


#pragma mark - TableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row==0?329.0f:208.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 93.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOne = @"RKExponentDetailCell";
    static NSString *CellIdentifierTwo = @"RKExponentDetailFooter";
    UITableViewCell *cell = nil;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOne];
        cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        ((UILabel *)[cell viewWithTag:23000]).dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
        ((UILabel *)[cell viewWithTag:23001]).dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
        ((UILabel *)[cell viewWithTag:23002]).dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
        
        
        //时间12405
        NSString *timeLastStr = nil;
        id timeLast = [_timeModel.xArr firstObject];
        if ([timeLast isKindOfClass:[NSNumber class]]) {
            timeLastStr = [timeLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            timeLastStr = timeLast;
        }
        NSDate *dateLast = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:timeLastStr];
        NSString *timeLastStirng2 = [[RKDataManager sharedInstance].dateFormatter stringFromDate:dateLast];
        NSString *vLastStr = nil;
        id vLast = nil;//[_timeModel.yArr firstObject];
        if (_detailState == RKExponentDetailStateCaifu) {
            vLast = [_timeModel.yArr firstObject];
        } else {
            vLast = [_timeModel.zArr firstObject];
        }
        if ([vLast isKindOfClass:[NSNumber class]]) {
            vLastStr = [vLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            vLastStr = vLast;
        }
        //截取收益率位数
        NSString *newData = nil;
        NSRange range = [vLastStr rangeOfString:@"."];
        if (range.location>0 && [vLastStr length]>range.location+5) {
            newData = [vLastStr substringToIndex:range.location+5];
        }else{
            newData = vLastStr;
        }
        
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:23001];
        timeLabel.text = timeLastStirng2;
        UILabel *rateLabel = (UILabel *)[cell viewWithTag:23002];
        rateLabel.text = newData;
        UIView  *kLineBgView = (UIView *)[cell viewWithTag:23003];
        UIView *v = [kLineBgView viewWithTag:16053];
        if (v) {
            [v removeFromSuperview];
        }
        NSArray *yArrConfirm = nil;
        if (_detailState == RKExponentDetailStateCaifu) {
            yArrConfirm = _timeModel.yArr;
        } else {
            yArrConfirm = _timeModel.zArr;
        }
        RKTimeKLine *kLine = [[RKTimeKLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 261) xArr:_timeModel.xArr yArr:yArrConfirm];
        kLine.kLineDelegate = self;
        kLine.tag = 16053;
        [kLineBgView addSubview:kLine];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTwo];
        
        cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        ((UIView *)[cell viewWithTag:25000]).dk_backgroundColorPicker = DKColorWithRGB(0xeff0f4, 0x0f0f0f);
        ((UIView *)[cell viewWithTag:25001]).dk_backgroundColorPicker = DKColorWithRGB(0xd8d9da, 0x1e1e1e);
        ((UIView *)[cell viewWithTag:25002]).dk_backgroundColorPicker = DKColorWithRGB(0xd8d9da, 0x1e1e1e);
        ((UILabel *)[cell viewWithTag:25003]).dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x8c8c8c);
        ((UILabel *)[cell viewWithTag:25004]).dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x8c8c8c);
        ((UILabel *)[cell viewWithTag:25005]).dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x8c8c8c);
        ((UILabel *)[cell viewWithTag:25006]).dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x8c8c8c);
        ((UILabel *)[cell viewWithTag:25007]).dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x8c8c8c);
        
        NSDictionary *dic = [CBCacheManager shareCache].phoneDic;
        ((UILabel *)[cell viewWithTag:25005]).text = dic[@"indPhone"];
        
        timeButton = (UIButton *)[cell viewWithTag:22001];
        timeButton.dk_backgroundColorPicker = DKColorWithRGB(0xECEBF1, 0xa8a8a8);
        [timeButton dk_setTitleColorPicker:DKColorWithRGB(0x6d6d6d, 0x404040) forState:UIControlStateNormal];
        [timeButton setTitle:[[RKDataManager sharedInstance].dateFormatter stringFromDate:self.currentDate] forState:UIControlStateNormal];
        [timeButton addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
        [timeButton.layer setMasksToBounds:YES];
        [timeButton.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
        
        UIButton *caifuButton = (UIButton *)[cell viewWithTag:22002];
        UIButton *jingjiaButton = (UIButton *)[cell viewWithTag:22003];
        [caifuButton addTarget:self action:@selector(caifuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [jingjiaButton addTarget:self action:@selector(jingjiaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [caifuButton.layer setBorderWidth:.5]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){255/255.0, 78/255.0, 78/255.0, 1.00 });
        [caifuButton.layer setBorderColor:colorref];//边框颜色
        
        [jingjiaButton.layer setBorderWidth:.5]; //边框宽度
        [jingjiaButton.layer setBorderColor:colorref];//边框颜色
        
        caifuButton.dk_backgroundColorPicker = DKColorWithRGB(0xff4e4e, 0x963231);
        
        if (_detailState == RKExponentDetailStateCaifu) {
            jingjiaButton.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0xa8a8a8);
            [jingjiaButton dk_setTitleColorPicker:DKColorWithRGB(0xff4e4e, 0x963231) forState:UIControlStateNormal];
        }else{
            caifuButton.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0xa8a8a8);
            [caifuButton dk_setTitleColorPicker:DKColorWithRGB(0xff4e4e, 0x963231) forState:UIControlStateNormal];
        }
        
        _caifuButtonRef = caifuButton;
        _jingxuanButtonRef = jingjiaButton;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 93)];
    header.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, 17)];
    titleLabel.text = [NSString stringWithFormat:@"%@-总值-财富",_timeModel.exponentModel.levelTitle];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
    titleLabel.font = [UIFont systemFontOfSize:15];
    [header addSubview:titleLabel];
    
    
    if (_detailState == RKExponentDetailStateCaifu) {
        titleLabel.text = [NSString stringWithFormat:@"%@-总值-财富",_timeModel.exponentModel.levelTitle];
    }else{
        titleLabel.text = [NSString stringWithFormat:@"%@-总值-净价",_timeModel.exponentModel.levelTitle];
    }
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16+17+6, SCREEN_WIDTH, 12)];
    if (_timeModel.time.length == 0) {
        timeLabel.text = @"更新时间:       ";
    }
    else
    {
        NSDate *timeDate = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:_timeModel.time];
        timeLabel.text = [NSString stringWithFormat:@"更新时间:%@",[[RKDataManager sharedInstance].dateFormatter stringFromDate:timeDate]];
    }
    
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0x4c4c4c);
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.backgroundColor = [UIColor clearColor];
    [header addSubview:timeLabel];
    
//    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16+17+6+12+8, SCREEN_WIDTH, 12)];
//    desLabel.text = @"中债-新综合指数-总值-财富";
//    desLabel.textAlignment = NSTextAlignmentCenter;
//    desLabel.dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0x4c4c4c);
//    desLabel.font = [UIFont systemFontOfSize:13];
//    desLabel.backgroundColor = [UIColor clearColor];
//    [header addSubview:desLabel];
//    
//    if (_detailState == RKExponentDetailStateCaifu) {
//        desLabel.text = @"中债-新综合指数-总值-财富";
//    }else{
//        desLabel.text = @"中债-新综合指数-总值-净价";
//    }
    
    UIView *sepretorLine = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height-10, SCREEN_WIDTH, 10)];
    sepretorLine.dk_backgroundColorPicker = DKColorWithRGB(0xeff0f4, 0x0f0f0f);
    [header addSubview:sepretorLine];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)changeTime:(UIButton *)sender
{
    _alert = [[JCAlertView alloc] initWithCustomView:self.picker dismissWhenTouchedBackground:YES];
    [_alert show];
}

- (void)caifuButtonClicked:(UIButton *)sender
{
    _caifuButtonRef.dk_backgroundColorPicker = DKColorWithRGB(0xff4e4e, 0x963231);
    [_caifuButtonRef dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xa8a8a8) forState:UIControlStateNormal];
    _jingxuanButtonRef.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0xa8a8a8);
    [_jingxuanButtonRef dk_setTitleColorPicker:DKColorWithRGB(0xff4e4e, 0x963231) forState:UIControlStateNormal];
    
    _detailState = RKExponentDetailStateCaifu;
    [_tableView reloadData];
}
- (void)jingjiaButtonClicked:(UIButton *)sender
{
    _jingxuanButtonRef.dk_backgroundColorPicker = DKColorWithRGB(0xff4e4e, 0x963231);
    [_jingxuanButtonRef dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xa8a8a8) forState:UIControlStateNormal];
    _caifuButtonRef.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0xa8a8a8);
    [_caifuButtonRef dk_setTitleColorPicker:DKColorWithRGB(0xff4e4e, 0x963231) forState:UIControlStateNormal];
    
    _detailState = RKExponentDetailStateJingjia;
    [_tableView reloadData];
}
- (void)kLine:(id)kLine refreshDataWithX:(CGFloat)x andY:(CGFloat)y
{
    CGFloat dateFloat = x * (60*60*24);
    NSDate *dateX = [NSDate dateWithTimeIntervalSinceReferenceDate:dateFloat];
    NSString *dateXString = [[RKDataManager sharedInstance].dateFormatter stringFromDate:dateX];
    if (!self.tableView.hidden) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:23001];
        timeLabel.text = dateXString;
        UILabel *rateLabel = (UILabel *)[cell viewWithTag:23002];
        rateLabel.text = [NSString stringWithFormat:@"%.4f",y];
    }else{
        self.precentLabel.text = [NSString stringWithFormat:@"%.4f",y];
        self.yearLabel.text = dateXString;
    }
    
}
- (void)kLineDidTapClicked:(id)kLine
{
    if (self.horView.hidden == NO && _isFullScreen == YES) {
        _headView.hidden = !_headView.hidden;
    }
}

#pragma mark - 横竖屏
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        if (_isFullScreen == YES) {
            _isFullScreen = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            self.navigationController.navigationBar.hidden = NO;
            self.navigationController.navigationBar.translucent = NO;
            _headView.hidden = YES;
            
            [_horKLine removeFromSuperview];
        }
        [_horKLine removeFromSuperview];
        self.horView.hidden = YES;
        self.tableView.hidden = NO;
        
        if (_navLinelayer) {
            [_navLinelayer removeFromSuperlayer];
        }
        
        self.navigationController.navigationBar.hidden = NO;
        self.navigationItem.titleView=nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        if (self.horView.hidden == NO) {
            return;
        }
        self.tableView.hidden = YES;
        self.horView.hidden = NO;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        
        self.navigationController.navigationBar.translucent = NO;
        
        UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 44)];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 350, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont systemFontOfSize:18.0]];
        titleText.textColor = [UIColor colorWithRed:228/255.0 green:58/255.0 blue:58/255.0 alpha:1.0];
        titleText.textAlignment = NSTextAlignmentCenter;
        //[titleText setText:_timeModel.exponentModel.levelTitle];
        [titleView addSubview:titleText];
        
        if (_detailState == RKExponentDetailStateCaifu) {
            _headTitleLabel.text = [NSString stringWithFormat:@"%@-总值-财富",_timeModel.exponentModel.levelTitle];
            titleText.text = [NSString stringWithFormat:@"%@-总值-财富",_timeModel.exponentModel.levelTitle];
        }else{
            _headTitleLabel.text = [NSString stringWithFormat:@"%@-总值-净价",_timeModel.exponentModel.levelTitle];
            titleText.text = [NSString stringWithFormat:@"%@-总值-净价",_timeModel.exponentModel.levelTitle];
        }
        
        UILabel *dateText = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 350, 16)];
        dateText.backgroundColor = [UIColor clearColor];
        [dateText setFont:[UIFont systemFontOfSize:11.0]];
        NSDate *timeDate = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:_timeModel.time];
        dateText.text = [NSString stringWithFormat:@"更新时间:%@",[[RKDataManager sharedInstance].dateFormatter stringFromDate:timeDate]];
        dateText.textColor = [UIColor colorWithRed:230/255.0 green:74/255.0 blue:74/255.0 alpha:1.0];
        dateText.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:dateText];
        
        self.navigationItem.titleView=titleView;
        
//        _navLinelayer = [CALayer layer];
//        _navLinelayer.backgroundColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0].CGColor;
//        _navLinelayer.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height-0, SCREEN_WIDTH, 1);
//        [self.navigationController.navigationBar.layer addSublayer:_navLinelayer];
        
        UIButton *fullButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fullButton setBackgroundImage:[UIImage imageNamed:@"fangfa"] forState:UIControlStateNormal];
        [fullButton addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
        fullButton.frame = CGRectMake(0, 0, 22, 22);
        UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:fullButton];
        self.navigationItem.rightBarButtonItem = releaseButtonItem;
        
        NSString *timeLastStr = nil;
        id timeLast = [_timeModel.xArr firstObject];
        if ([timeLast isKindOfClass:[NSNumber class]]) {
            timeLastStr = [timeLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            timeLastStr = timeLast;
        }
        NSDate *dateLast = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:timeLastStr];
        NSString *timeLastStirng2 = [[RKDataManager sharedInstance].dateFormatter stringFromDate:dateLast];
        NSString *vLastStr = nil;
        id vLast = [_timeModel.yArr firstObject];
        if ([vLast isKindOfClass:[NSNumber class]]) {
            vLastStr = [vLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            vLastStr = vLast;
        }
        //截取收益率位数
        NSString *newData = nil;
        NSRange range = [vLastStr rangeOfString:@"."];
        if (range.location>0 && [vLastStr length]>range.location+5) {
            newData = [vLastStr substringToIndex:range.location+5];
        }else{
            newData = vLastStr;
        }
        self.precentLabel.text = newData;
        self.yearLabel.text = timeLastStirng2;
        NSString *destDateString = [[RKDataManager sharedInstance].dateFormatter stringFromDate:self.currentDate];
        self.dateLabel.text = [NSString stringWithFormat:@"开始日期:%@",destDateString];
        
        NSDictionary *dic = [CBCacheManager shareCache].phoneDic;
        self.phoneNum.text = dic[@"indPhone"];
        
        NSArray *yArrConfirm = nil;
        if (_detailState == RKExponentDetailStateCaifu) {
            yArrConfirm = _timeModel.yArr;
        } else {
            yArrConfirm = _timeModel.zArr;
        }
        _horKLine = [[RKTimeKLine alloc] initWithFrame:CGRectMake(10, 25, self.horView.bounds.size.width-170-10, self.horView.bounds.size.height-25-10) xArr:_timeModel.xArr yArr:yArrConfirm];
        _horKLine.kLineDelegate = self;
        [self.horView addSubview:_horKLine];
        
    }
}

- (IBAction)returnToOldScreen:(id)sender {
    _isFullScreen = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;

    _headView.hidden = YES;
    
    [_horKLine removeFromSuperview];
    CGRect frame = CGRectMake(10, 25, self.horView.bounds.size.width-170-10, self.horView.bounds.size.height-25-10);

    NSArray *yArrConfirm = nil;
    if (_detailState == RKExponentDetailStateCaifu) {
        yArrConfirm = _timeModel.yArr;
    } else {
        yArrConfirm = _timeModel.zArr;
    }
    _horKLine = [[RKTimeKLine alloc] initWithFrame:frame xArr:_timeModel.xArr yArr:yArrConfirm];
    
    _horKLine.kLineDelegate = self;
    [self.horView addSubview:_horKLine];
}

-(void)fullScreen:(UIButton*)button
{
    _isFullScreen = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    _headView.hidden = NO;
    
    [_horKLine removeFromSuperview];
    
    NSArray *yArrConfirm = nil;
    if (_detailState == RKExponentDetailStateCaifu) {
        yArrConfirm = _timeModel.yArr;
    } else {
        yArrConfirm = _timeModel.zArr;
    }
    _horKLine = [[RKTimeKLine alloc] initWithFrame:self.horView.bounds xArr:_timeModel.xArr yArr:yArrConfirm];
    
    _horKLine.kLineDelegate = self;
    [self.horView addSubview:_horKLine];
    
    [self.horView bringSubviewToFront:self.headView];
}

#pragma mark - hud
- (void)showHud
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _tableView.hidden = YES;
}
- (void)hideHud
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _tableView.hidden = NO;
}
@end
