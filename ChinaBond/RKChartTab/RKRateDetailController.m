//
//  RKRateDetailController.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/7.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKRateDetailController.h"
#import "RKKLine.h"
#import "RKDataManager.h"
#import "RKYieldRateViewController.h"
//#import "CustomDatePickerView.h"
//#import "JCAlertView.h"
#import "RKRateInfoModel.h"
#import <AFNetworkReachabilityManager.h>
#import "STPickerDate.h"

@interface RKRateDetailController ()<RKYieldChoiceDelegate, RKKLineDelegate,STPickerDateDelegate>
{
    UIButton *timeButton;
//    JCAlertView *_alert;
    BOOL    _isFullScreen;
    RKKLine *_horKLine;
    CALayer *_navLinelayer;
}
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UILabel *shouyilvLab;
@property (strong, nonatomic) IBOutlet UILabel *daichangqiLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneNum;
@property (strong, nonatomic) IBOutlet UILabel *phoneNum1;
//@property (retain, nonatomic)  CustomDatePickerView *picker;
@property (nonatomic, strong) RKKLineModel *model;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, strong) STPickerDate *pickerDate;
@end

@implementation RKRateDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isFullScreen = NO;
    self.title = @"中债收益率";
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    
    UIColor *backColor;
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        backColor =  [UIColor blackColor];
    }else{
        backColor =  [UIColor whiteColor];
    }
    self.tableView.backgroundColor = backColor;

    self.horView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.rightView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.shouyilvLab.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x963232);
    self.precentLabel.dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
    self.daichangqiLab.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x963232);
    self.yearLabel.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x963232);
    self.dateLabel.dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0x424141);
    self.phoneLab.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x424141);
    self.phoneNum.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x424141);
    self.phoneNum1.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x424141);
    
    self.headTitleLabel.text = self.rateModel.rateTitle;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UINib *oneNib = [UINib nibWithNibName:@"RKRateDetailCell" bundle:nil];
    UINib *twoNib = [UINib nibWithNibName:@"RKRateDetailFooter" bundle:nil];
    [_tableView registerNib:oneNib forCellReuseIdentifier:@"CellIdentifierOne"];
    [_tableView registerNib:twoNib forCellReuseIdentifier:@"CellIdentifierTwo"];
    
    self.currentDate = [NSDate date];
    
//    self.picker = [[CustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
//
//    NSLog(@" self.view.bounds.size.width == %f", self.view.bounds.size.width);
//
//    __weak __typeof__(self) weakSelf = self;
//    self.picker.cancelBlock = ^{
//        __strong typeof(self) strongSelf = weakSelf;
//        if (strongSelf) {
//            [strongSelf->_alert dismissWithCompletion:^{
//
//            }];
//        }
//    };
//    self.picker.sureBlock = ^(NSString *date){
//        __strong typeof(self) strongSelf = weakSelf;
//        if (strongSelf) {
//            [strongSelf->_alert dismissWithCompletion:^{
//                [strongSelf->timeButton setTitle:date forState:UIControlStateNormal];
//                strongSelf.currentDate = [[RKDataManager sharedInstance].dateFormatter dateFromString:date];
//
//                strongSelf.params = @{@"sDay":[[RKDataManager sharedInstance].dateFormatter2 stringFromDate:strongSelf. currentDate],
//                                      @"id":strongSelf.rateModel.rateID};
//
//
//                // 1.获得网络监控的管理者
//                AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//                // 2.设置网络状态改变后的处理
//                [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//                    // 当网络状态改变了, 就会调用这个block
//                    switch (status)
//                    {
//                        case AFNetworkReachabilityStatusUnknown: // 未知网络
//                        {
//                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                            [MBProgressHUD bwm_showTitle:@"请连接网络" toView:self.view hideAfter:2];
//                        }
//                            break;
//                        case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//                        {
//                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                            [MBProgressHUD bwm_showTitle:@"请连接网络" toView:self.view hideAfter:2];
//                        }
//                            break;
//                        case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                        {
//
//                            CBLog(@"手机自带网络");
//                            [strongSelf requestForRate:[[RKDataManager sharedInstance].dateFormatter2 stringFromDate:strongSelf.currentDate] rateModel:strongSelf.rateModel];
//                        }
//                            break;
//                        case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//                        {
//                            CBLog(@"WIFI");
//                            [strongSelf requestForRate:[[RKDataManager sharedInstance].dateFormatter2 stringFromDate:strongSelf.currentDate] rateModel:strongSelf.rateModel];
//                        }
//                            break;
//                    }
//                }];
//                [mgr startMonitoring];
//
//            }];
//        }
//    };

    self.horView.hidden = YES;
    
    [self showHud];
    
    if (self.rateModel.rateID) {
        self.params = @{@"id"   : self.rateModel.rateID,
                        @"sDay" : @""
        };
    }
    
    [self requestForRate:[[RKDataManager sharedInstance].dateFormatter2 stringFromDate:[NSDate date]] rateModel:self.rateModel];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"rateDetailFirst"]) {
        self.guideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.guideView.backgroundColor = UIColorFromRGB(0x000000);
        self.guideView.alpha = .7;
        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
        
        UIImageView *guideImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 195, 200, 155)];
        guideImage.image = [UIImage imageNamed:@"guide_fangda"];
        [self.guideView addSubview:guideImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
        tap.numberOfTapsRequired = 2;
        [self.guideView addGestureRecognizer:tap];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rateDetailFirst"];
    }
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //请求今日数据
//    [MobClick event:@"1003"];
}
+(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        CBLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)requestForRate:(NSString *)dateString rateModel:(RKRateInfoModel *)model
{
    
    MJWeakSelf;
    [[CBHttpRequest shareRequest] postWithUrl:kApiRateData
                                       Params:self.params
                              completionBlock:^(id responseObject) {
                                  //NSLog(@"%@",responseObject);
                CBLog(@"rate详情--------%@-----",[RKRateDetailController DataTOjsonString:responseObject]);
                                  if ([[(NSDictionary *)responseObject objectForKey:@"state"] isEqualToString:@"0"]) {
                                      NSArray *xArr = [(NSDictionary *)responseObject objectForKey:@"xValues"];
                                      NSArray *yArr = [(NSDictionary *)responseObject objectForKey:@"yValues"];
                                      weakSelf.model = [[RKKLineModel alloc] init];
                                      weakSelf.model.xArr = xArr;
                                      weakSelf.model.yArr = yArr;
                                      weakSelf.model.time = responseObject[@"queryDate"];
                                      weakSelf.model.rateInfoModel = model;
                                      
                                      [self hideHud];
                                      
                                      if (xArr.count == 0) {
                                          [MBProgressHUD bwm_showTitle:@"没有查到相关曲线信息" toView:self.view hideAfter:2];
                                      }
                                      
                                      [ weakSelf.tableView reloadData];
                                  }else{
                                      NSString *errorInfo = [(NSDictionary *)responseObject objectForKey:@"errorMsg"];
                                      weakSelf.model = [[RKKLineModel alloc] init];
                                      weakSelf.model.time = responseObject[@"queryDate"];
                                      weakSelf.model.rateInfoModel = model;
                                      [self hideHud];
                                      [ weakSelf.tableView reloadData];
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
    return 74.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOne = @"CellIdentifierOne";
    static NSString *CellIdentifierTwo = @"CellIdentifierTwo";
    UITableViewCell *cell = nil;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOne];
        
        cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        ((UILabel *)[cell viewWithTag:23000]).dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
        ((UILabel *)[cell viewWithTag:23001]).dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
        ((UILabel *)[cell viewWithTag:23002]).dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
        ((UILabel *)[cell viewWithTag:23004]).dk_textColorPicker = DKColorWithRGB(0xf83a7a, 0x963232);
        
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:23001];
        
        NSString *timeLastStr = nil;
        id timeLast = [_model.xArr lastObject];
        if ([timeLast isKindOfClass:[NSNumber class]]) {
            timeLastStr = [timeLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            timeLastStr = timeLast;
        }
        
        timeLabel.text = timeLastStr;
        UILabel *rateLabel = (UILabel *)[cell viewWithTag:23002];
        
        //收益率12405
        NSString *vLastStr = nil;
        id vLast = [_model.yArr lastObject];
        if ([vLast isKindOfClass:[NSNumber class]]) {
            vLastStr = [vLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            vLastStr = vLast;
        }
        if (vLastStr.length>0) {
            rateLabel.text = [NSString stringWithFormat:@"%@%%",vLastStr];
        }
        else
        {
            rateLabel.text = @"";
        }
        
        UIView  *kLineBgView = (UIView *)[cell viewWithTag:23003];
        UIView *v = [kLineBgView viewWithTag:16054];
        if (v) {
            [v removeFromSuperview];
        }
        RKKLine *kLine = [[RKKLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 261) xArr:_model.xArr yArr:_model.yArr];
        kLine.kLineDelegate = self;
        kLine.tag = 16054;
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
        ((UILabel *)[cell viewWithTag:25005]).text = dic[@"curvePhone"];
        
        timeButton = (UIButton *)[cell viewWithTag:22001];
        timeButton.dk_backgroundColorPicker = DKColorWithRGB(0xECEBF1, 0xa8a8a8);
        [timeButton dk_setTitleColorPicker:DKColorWithRGB(0x6d6d6d, 0x404040) forState:UIControlStateNormal];
        
        UIButton *selectButton = (UIButton *)[cell viewWithTag:22002];
        selectButton.dk_backgroundColorPicker = DKColorWithRGB(0xff4e4e, 0x963231);
        
        [timeButton setTitle:[[RKDataManager sharedInstance].dateFormatter stringFromDate:self.currentDate] forState:UIControlStateNormal];
        [timeButton addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
        [selectButton addTarget:self action:@selector(selectLine:) forControlEvents:UIControlEventTouchUpInside];
        
        [timeButton.layer setMasksToBounds:YES];
        [timeButton.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
        
        [selectButton.layer setMasksToBounds:YES];
        [selectButton.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
    header.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, 17)];
    titleLabel.text = _model.rateInfoModel.rateTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
    titleLabel.font = [UIFont systemFontOfSize:15];
    [header addSubview:titleLabel];
 
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16+17+6, SCREEN_WIDTH, 12)];
    //    if (_model.time.length == 0) {
    //        timeLabel.text = @"更新时间:       ";
    //    }else{
    //        NSDate *timeDate = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:_model.time];
    //        timeLabel.text = [NSString stringWithFormat:@"更新时间:%@",[[RKDataManager sharedInstance].dateFormatter stringFromDate:timeDate]];
    //    }
    if ([_model.time isKindOfClass:[NSNull class]]) {
        timeLabel.text = @"更新时间:       ";
    }else{
        NSDate *timeDate = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:_model.time];
        timeLabel.text = [NSString stringWithFormat:@"更新时间:%@",[[RKDataManager sharedInstance].dateFormatter stringFromDate:timeDate]];
    }

    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0x4c4c4c);
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.backgroundColor = [UIColor clearColor];
    [header addSubview:timeLabel];
    
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
    
    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)changeTime:(UIButton *)sender
{
//    _alert = [[JCAlertView alloc] initWithCustomView:self.picker dismissWhenTouchedBackground:YES];
//    [_alert show];
    
    [self.pickerDate show];
}
- (void)selectLine:(UIButton *)sender
{
    RKYieldRateViewController *yieldRate = [[RKYieldRateViewController alloc] init];
    yieldRate.pageType = RKYieldRatePageTypeChoice;
    yieldRate.delegate = self;
    [self.navigationController pushViewController:yieldRate animated:YES];
}
#pragma mark - RKYieldChoiceDelegate
- (void)yieldRatePage:(RKYieldRateViewController *)page didChoiceData:(RKRateInfoModel *)choice
{
    [self showHud];
    self.params = @{@"id"   : choice.rateID,
                    @"sDay" : @""};

    [self requestForRate:[[RKDataManager sharedInstance].dateFormatter2 stringFromDate:[NSDate date]] rateModel:choice];
    
    self.rateModel = choice;
        
//    NSString *dateNow = [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:self.currentDate];
//    [self requestForRate:dateNow rateModel:choice];

}
- (void)kLine:(id)kLine refreshDataWithX:(CGFloat)x andY:(CGFloat)y
{
    if (!self.tableView.hidden) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:23001];
        timeLabel.text = [NSString stringWithFormat:@"%.1f",x];
        UILabel *rateLabel = (UILabel *)[cell viewWithTag:23002];
        rateLabel.text = [NSString stringWithFormat:@"%.4f%%",y];
    }else{
        self.precentLabel.text = [NSString stringWithFormat:@"%.4f%%",y];
        self.yearLabel.text = [NSString stringWithFormat:@"%.1f",x];
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
        [titleText setText:_model.rateInfoModel.rateTitle];
        [titleView addSubview:titleText];
        
        [_headTitleLabel setText:_model.rateInfoModel.rateTitle];

        UILabel *dateText = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 350, 16)];
        dateText.backgroundColor = [UIColor clearColor];
        [dateText setFont:[UIFont systemFontOfSize:11.0]];
        NSDate *timeDate = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:_model.time];
        dateText.text = [NSString stringWithFormat:@"更新时间:%@",[[RKDataManager sharedInstance].dateFormatter stringFromDate:timeDate]];
        dateText.textColor = [UIColor colorWithRed:230/255.0 green:74/255.0 blue:74/255.0 alpha:1.0];
        dateText.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:dateText];
        
        self.navigationItem.titleView=titleView;
        
//        _navLinelayer = [CALayer layer];
//        _navLinelayer.backgroundColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0].CGColor;
//        _navLinelayer.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height-0, SCREEN_WIDTH, 1);
        //[self.navigationController.navigationBar.layer addSublayer:_navLinelayer];
        
        UIButton *fullButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fullButton setBackgroundImage:[UIImage imageNamed:@"fangfa"] forState:UIControlStateNormal];
        [fullButton addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
        fullButton.frame = CGRectMake(0, 0, 22, 22);
        UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:fullButton];
        self.navigationItem.rightBarButtonItem = releaseButtonItem;
        
        NSString *timeLastStr = nil;
        id timeLast = [_model.xArr lastObject];
        if ([timeLast isKindOfClass:[NSNumber class]]) {
            timeLastStr = [timeLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            timeLastStr = timeLast;
        }
        
        self.yearLabel.text = timeLastStr;
        
        //收益率12405
        NSString *vLastStr = nil;
        id vLast = [_model.yArr lastObject];
        if ([vLast isKindOfClass:[NSNumber class]]) {
            vLastStr = [vLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            vLastStr = vLast;
        }
        
        self.precentLabel.text = [NSString stringWithFormat:@"%@%%",vLastStr];
        NSString *destDateString = [[RKDataManager sharedInstance].dateFormatter stringFromDate:self.currentDate];
        self.dateLabel.text = [NSString stringWithFormat:@"日期:%@",destDateString];
       
        NSDictionary *dic = [CBCacheManager shareCache].phoneDic;
        self.phoneNum.text = dic[@"curvePhone"];
        
        [_horKLine  removeFromSuperview];
        _horKLine = [[RKKLine alloc] initWithFrame:CGRectMake(10, 25, self.horView.bounds.size.width-170-10, self.horView.bounds.size.height-25-10) xArr:_model.xArr yArr:_model.yArr];
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
    _horKLine = [[RKKLine alloc] initWithFrame:frame xArr:_model.xArr yArr:_model.yArr];
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
    _horKLine = [[RKKLine alloc] initWithFrame:self.horView.bounds xArr:_model.xArr yArr:_model.yArr];
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

- (void)tapGes:(UITapGestureRecognizer *)gesture
{
    [self.guideView removeFromSuperview];
}
#pragma mark -DatePickerDelegate
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSString *m = ((month<10)? [NSString stringWithFormat:@"0%zd",month] : [NSString stringWithFormat:@"%zd",month]);
    NSString *d = ((day<10)? [NSString stringWithFormat:@"0%zd",day] : [NSString stringWithFormat:@"%zd",day]);
    NSString *text = [NSString stringWithFormat:@"%zd-%@-%@", year, m, d];
    
    [self->timeButton setTitle:text forState:UIControlStateNormal];
    self.currentDate = [[RKDataManager sharedInstance].dateFormatter dateFromString:text];
    
    self.params = @{@"sDay" :  [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:self. currentDate],
                    @"id"   :  self.rateModel.rateID};
    
    [self requestForRate  : [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:self.currentDate]
                rateModel : self.rateModel];
 
    
}
#pragma mark - LazyLoad

- (STPickerDate *)pickerDate{
    if(!_pickerDate){
        _pickerDate= [[STPickerDate alloc]init];
        _pickerDate.delegate = self;
        _pickerDate.pickerTitle = @"选择日期";
    }
    return _pickerDate;
    
    
}

@end
