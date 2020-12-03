//
//  RKChartViewController.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKChartViewController.h"
#import "RKExponentViewController.h"
#import "RKYieldRateViewController.h"
#import "RKValuationViewController.h"
#import "RKStatisticsViewController.h"
#import "RKKLine.h"
#import "RKTimeKLine.h"
#import "RKDataManager.h"
#import "RKCateLevelModel.h"
#import "RKRateInfoModel.h"
#import "RKRateDetailController.h"
#import "RKExponentDetailController.h"
#import <AFNetworkReachabilityManager.h>

@interface RKChartViewController ()<RKYieldChoiceDelegate, RKExponentChoiceDelegate, RKKLineDelegate, UIGestureRecognizerDelegate>
@property (readonly, nonatomic, retain) RKKLineModel *model;//收益率曲线model
@property (readonly, nonatomic, retain) RKKLineModel *timeModel;//指数曲线model
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end

@implementation RKChartViewController
{
    BOOL rateLoadEnd;//收益率加载完成标识
    BOOL exponentLoadEnd;//指数曲线数据加载完成标识
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.navigationItem.title = @"中国债券信息网";
    rateLoadEnd = NO;
    exponentLoadEnd = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UINib *nibOne = [UINib nibWithNibName:@"RKChartCell" bundle:nil];
    [self.tableView registerNib:nibOne forCellReuseIdentifier:@"ChartCellIdentifierOne"];
    UINib *nibTwo = [UINib nibWithNibName:@"RKChartSecondCell" bundle:nil];
    [self.tableView registerNib:nibTwo forCellReuseIdentifier:@"ChartCellIdentifierTwo"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self showHud];

    
    //wr add
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorWithRGB(0xffffff, 0x1e1c1d);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    //self.navigationController.navigationBar.dk_tintColorPicker = DKColorWithRGB(0xe53d3d, 0xffffff);
    self.tabBarController.tabBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    
    //监听夜间模式变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:@"nightModelChange" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick event:@"1001"];
    [MobClick beginLogPageView:@"Chart"];
    
//    // 1.获得网络监控的管理者
//    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//    // 2.设置网络状态改变后的处理
//    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        // 当网络状态改变了, 就会调用这个block
//        switch (status)
//        {
//            case AFNetworkReachabilityStatusUnknown: // 未知网络
//            {
//                BOOL downLoad = [[NSUserDefaults standardUserDefaults] boolForKey:KDownLoad];
//                if (downLoad) {
//                    [self requestData];
//                }
//                else
//                {
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                    [MBProgressHUD bwm_showTitle:@"请连接网络" toView:self.view hideAfter:2];
//                }
//            }
//                break;
//            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//            {
//                BOOL downLoad = [[NSUserDefaults standardUserDefaults] boolForKey:KDownLoad];
//                if (downLoad) {
//                    [self requestData];
//                }
//                else
//                {
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                    [MBProgressHUD bwm_showTitle:@"请连接网络" toView:self.view hideAfter:2];
//                }
//
//            }
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//            {
//                [self requestData];
//            }
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//            {
//                [self requestData];
//            }
//                break;
//        }
//    }];
//    [mgr startMonitoring];
    [self requestData];
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

- (void) requestData
{
     NSString *dateNow = [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:[NSDate date]];
    
    NSDictionary *dic = [CBCacheManager shareCache].phoneDic;
    
    //wr add end
    if (dic) {
        
        //-----------------------1

        
        RKRateInfoModel *fixRateModel = [[RKRateInfoModel alloc] init];
        fixRateModel.rateTitle = dic[@"curveName"];
        fixRateModel.rateID = dic[@"curveId"];
        fixRateModel.ratePID = @"8a8b2ca048459f7b014845b78c680006";
        fixRateModel.subInfos = nil;
        [self requestForRate:dateNow rateModel:fixRateModel];
        
        //-----------------------2
        
        NSDate *bDate = [[RKDataManager sharedInstance] twoMonthAgo:[NSDate date]];
        NSString *bDateStr = [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:bDate];

        RKCateLevelModel *fixExpoModel = [[RKCateLevelModel alloc] init];
        fixExpoModel.levelTitle = dic[@"indicsName"];
        fixExpoModel.levelID = dic[@"indicsId"];
        fixExpoModel.subLevels = nil;
        [self requestForExponentWithBeginDate:bDateStr endDate:dateNow exponentModel:fixExpoModel];
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"Chart"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable
{
    [self.tableView reloadData];
}

- (void)requestForRate:(NSString *)dateString rateModel:(RKRateInfoModel *)model
{
    [[CBHttpRequest shareRequest] postWithUrl:kApiRateData
                                       Params:@{@"id"  : model.rateID,
                                                @"sDay":@""
                                       }
                              completionBlock:^(id responseObject) {
        CBLog(@"页面2--------%@",[RKChartViewController DataTOjsonString:responseObject]);
                                  if ([[(NSDictionary *)responseObject objectForKey:@"state"] isEqualToString:@"0"]) {
                                      NSArray *xArr = [(NSDictionary *)responseObject objectForKey:@"xValues"];
                                      NSArray *yArr = [(NSDictionary *)responseObject objectForKey:@"yValues"];
                                      _model = [[RKKLineModel alloc] init];
                                      _model.xArr = xArr;
                                      _model.yArr = yArr;
                                      _model.time = responseObject[@"queryDate"];
                                      model.rateTitle = responseObject[@"ycName"];
                                      _model.rateInfoModel = model;
                                      _model.name = responseObject[@"ycName"];
                                      rateLoadEnd = YES;
                                      [self dataLoadEnd:nil];
                                  }else{
                                      NSString *errorInfo = [(NSDictionary *)responseObject objectForKey:@"errorMsg"];
                                      rateLoadEnd = YES;
                                      _model = [[RKKLineModel alloc] init];
                                      _model.time = dateString;
                                      _model.rateInfoModel = model;
                                      [self dataLoadEnd:errorInfo];
                                  }
                              } failBlock:^(NSError *error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                  [alert show];
                              }];
}

- (void)requestForExponentWithBeginDate:(NSString *)beginDateString endDate:(NSString *)endDateString exponentModel:(RKCateLevelModel *)model
{
    [[CBHttpRequest shareRequest] postWithUrl:kApiExponentData
                                       Params:@{@"ksr":beginDateString, @"jsr":endDateString, @"id":model.levelID}
                              completionBlock:^(id responseObject) {
                                  CBLog(@"页面2.2--------%@",[RKChartViewController DataTOjsonString:responseObject]);
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
                                      _timeModel.name = responseObject[@"indexName"];
                                      exponentLoadEnd = YES;
                                      [self dataLoadEnd:nil];
                                  }else{
                                      NSString *errorInfo = [(NSDictionary *)responseObject objectForKey:@"errorMsg"];
                                      rateLoadEnd = YES;
                                      _timeModel = [[RKKLineModel alloc] init];
                                      _timeModel.exponentModel = model;
                                      _timeModel.time = responseObject[@"queryDate"];
                                      _timeModel.name = responseObject[@"indexName"];
                                      [self dataLoadEnd:errorInfo];
                                  }
                              } failBlock:^(NSError *error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                  [alert  show];
                                  [self hideHud];
                              }];
}
- (void)dataLoadEnd:(NSString *)erroInfo
{
    if (rateLoadEnd && exponentLoadEnd) {
        if (!erroInfo) {
            [_tableView reloadData];
            [self hideHud];
        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:erroInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert  show];
//            [_tableView reloadData];
//            [self hideHud];
        }
    }
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
    return 440.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 94+9.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOne = @"ChartCellIdentifierOne";
    static NSString *CellIdentifierTwo = @"ChartCellIdentifierTwo";
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOne];
        
        //wr add
        
        cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        ((UILabel *)[cell viewWithTag:12402]).dk_textColorPicker = DKColorWithRGB(0x3B3B3B, 0x8c8c8c);
        ((UILabel *)[cell viewWithTag:12403]).dk_textColorPicker = DKColorWithRGB(0xfc343e, 0x4c4c4c);
        ((UILabel *)[cell viewWithTag:12404]).dk_textColorPicker = DKColorWithRGB(0xf31c67, 0x963232);
        ((UILabel *)[cell viewWithTag:12405]).dk_textColorPicker = DKColorWithRGB(0xf31c67, 0x963232);
        
        
        ((UIView *)[cell viewWithTag:12501]).dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
        ((UILabel *)[cell viewWithTag:12502]).dk_textColorPicker = DKColorWithRGB(0x5B5B5B, 0x737373);
        ((UILabel *)[cell viewWithTag:12503]).dk_textColorPicker = DKColorWithRGB(0x838383, 0x737373);
        ((UIView *)[cell viewWithTag:12504]).dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        ((UIView *)[cell viewWithTag:12505]).dk_backgroundColorPicker = DKColorWithRGB(0xF5F5F5, 0x171616);
        ((UILabel *)[cell viewWithTag:12506]).dk_textColorPicker = DKColorWithRGB(0xf31c67, 0x963232);
        ((UILabel *)[cell viewWithTag:12507]).dk_textColorPicker = DKColorWithRGB(0xf31c67, 0x963232);
        ((UIView *)[cell viewWithTag:12508]).dk_backgroundColorPicker = DKColorWithRGB(0xECEBF1, 0x0f0f0f);
        ((UIView *)[cell viewWithTag:12509]).dk_backgroundColorPicker = DKColorWithRGB(0xE4E4E4, 0x171616);
        ((UIView *)[cell viewWithTag:12510]).dk_backgroundColorPicker = DKColorWithRGB(0xE4E4E4, 0x171616);
        ((UIView *)[cell viewWithTag:12511]).dk_backgroundColorPicker = DKColorWithRGB(0xD0D0D0, 0x171616);
        ((UIView *)[cell viewWithTag:12512]).dk_backgroundColorPicker = DKColorWithRGB(0xD0D0D0, 0x171616);
        //
        //wr add end
        
        //按钮添加监听方法12401
        [((UIButton *)[cell viewWithTag:12401]) addTarget:self action:@selector(changeKLineOfYiekldRate:) forControlEvents:UIControlEventTouchUpInside];
        //信息第一行12402
        ((UILabel *)[cell viewWithTag:12402]).text = _model.name;//_model.rateInfoModel.rateTitle;
        
        //信息第二行12403
        if (_model.time.length==0) {
            ((UILabel *)[cell viewWithTag:12403]).text = @"更新时间:";
        }
        else
        {
            NSDate *timeDate = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:_model.time];
            ((UILabel *)[cell viewWithTag:12403]).text = [NSString stringWithFormat:@"更新时间:%@",[[RKDataManager sharedInstance].dateFormatter stringFromDate:timeDate]];
        }
        //待偿期12404
        NSString *timeLastStr = nil;
        id timeLast = [_model.xArr lastObject];
        if ([timeLast isKindOfClass:[NSNumber class]]) {
            timeLastStr = [timeLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            timeLastStr = timeLast;
        }
        ((UILabel *)[cell viewWithTag:12404]).text = timeLastStr;
        //收益率12405
        NSString *vLastStr = nil;
        id vLast = [_model.yArr lastObject];
        if ([vLast isKindOfClass:[NSNumber class]]) {
            vLastStr = [vLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            vLastStr = vLast;
        }
        if ([[RKDataManager sharedInstance] subRateString:vLastStr].length == 0) {
            ((UILabel *)[cell viewWithTag:12405]).text = @"";
        }
        else
        {
            ((UILabel *)[cell viewWithTag:12405]).text = [NSString stringWithFormat:@"%@%%",[[RKDataManager sharedInstance] subRateString:vLastStr]];
        }
        
        //图表12406
        UIView *kLineBgView = (UIView *)[cell viewWithTag:12406];
        UIView *v = [kLineBgView viewWithTag:16051];
        if (v) {
            [v removeFromSuperview];
        }
        RKKLine *kLine = [[RKKLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 260) xArr:_model.xArr yArr:_model.yArr];
        kLine.canScale = NO;
        kLine.tag = 16051;
        kLine.kLineDelegate = self;
        [kLineBgView addSubview:kLine];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTwo];
        
        //wr add
        
        cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        ((UILabel *)[cell viewWithTag:12402]).dk_textColorPicker = DKColorWithRGB(0x3B3B3B, 0x8c8c8c);
        ((UILabel *)[cell viewWithTag:12403]).dk_textColorPicker = DKColorWithRGB(0xfc343e, 0x4c4c4c);
        ((UILabel *)[cell viewWithTag:12404]).dk_textColorPicker = DKColorWithRGB(0xf31c67, 0x963232);
        ((UILabel *)[cell viewWithTag:12405]).dk_textColorPicker = DKColorWithRGB(0xf31c67, 0x963232);
        ((UILabel *)[cell viewWithTag:12402]).dk_textColorPicker = DKColorWithRGB(0x3B3B3B, 0x8c8c8c);
        
        ((UILabel *)[cell viewWithTag:12444]).dk_textColorPicker = DKColorWithRGB(0x5B5B5B, 0x737373);


        
        
        ((UIView *)[cell viewWithTag:12501]).dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
        ((UILabel *)[cell viewWithTag:12502]).dk_textColorPicker = DKColorWithRGB(0x5B5B5B, 0x737373);
        ((UILabel *)[cell viewWithTag:12503]).dk_textColorPicker = DKColorWithRGB(0xFA792C, 0x737373);
        ((UIView *)[cell viewWithTag:12504]).dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        ((UIView *)[cell viewWithTag:12505]).dk_backgroundColorPicker = DKColorWithRGB(0xF5F5F5, 0x171616);
        ((UILabel *)[cell viewWithTag:12506]).dk_textColorPicker = DKColorWithRGB(0xf31c67, 0x963232);
        ((UILabel *)[cell viewWithTag:12507]).dk_textColorPicker = DKColorWithRGB(0xf31c67, 0x963232);
        ((UIView *)[cell viewWithTag:12508]).dk_backgroundColorPicker = DKColorWithRGB(0xECEBF1, 0x0f0f0f);
        ((UIView *)[cell viewWithTag:12509]).dk_backgroundColorPicker = DKColorWithRGB(0xE4E4E4, 0x171616);
        ((UIView *)[cell viewWithTag:12510]).dk_backgroundColorPicker = DKColorWithRGB(0xE4E4E4, 0x171616);
        ((UIView *)[cell viewWithTag:12511]).dk_backgroundColorPicker = DKColorWithRGB(0xD0D0D0, 0x171616);
        ((UIView *)[cell viewWithTag:12512]).dk_backgroundColorPicker = DKColorWithRGB(0xD0D0D0, 0x171616);
        //
        //wr add end
        
        //按钮添加监听方法 12401
        [((UIButton *)[cell viewWithTag:12401]) addTarget:self action:@selector(changeKLineOfExponent:) forControlEvents:UIControlEventTouchUpInside];
        //信息第一行12402
        if (_timeModel.name.length == 0) {
            ((UILabel *)[cell viewWithTag:12444]).text = @"－总值－财富";
        }
        else
        {
            ((UILabel *)[cell viewWithTag:12444]).text = [NSString stringWithFormat:@"%@－总值－财富",_timeModel.name];
        }
        ((UILabel *)[cell viewWithTag:12402]).text = @"信用债总指数走势图";
        
        
        

        //信息第二行12403
        if (_timeModel.time.length == 0) {
            ((UILabel *)[cell viewWithTag:12403]).text = @"更新时间:         ";
        }
        else
        {
            NSDate *timeDate = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:_timeModel.time];
            ((UILabel *)[cell viewWithTag:12403]).text = [NSString stringWithFormat:@"更新时间:%@",[[RKDataManager sharedInstance].dateFormatter stringFromDate:timeDate]];
        }
        //信息第三行12404
        ((UILabel *)[cell viewWithTag:12404]).text = @"";
        //时间12405
        NSString *timeLastStr = nil;
        id timeLast = [_timeModel.xArr lastObject];
        if ([timeLast isKindOfClass:[NSNumber class]]) {
            timeLastStr = [timeLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            timeLastStr = timeLast;
        }
        if (timeLastStr.length == 0) {
            ((UILabel *)[cell viewWithTag:12405]).text = @"日期:";
        }
        else
        {
            NSDate *dateLast = [[RKDataManager sharedInstance].dateFormatter2 dateFromString:timeLastStr];
            NSString *timeLastStirng2 = [[RKDataManager sharedInstance].dateFormatter stringFromDate:dateLast];
            ((UILabel *)[cell viewWithTag:12405]).text = [NSString stringWithFormat:@"日期:%@",timeLastStirng2];
        }
        NSString *vLastStr = nil;
        id vLast = [_timeModel.yArr lastObject];
        if ([vLast isKindOfClass:[NSNumber class]]) {
            vLastStr = [vLast stringValue];
        }else if ([timeLast isKindOfClass:[NSString class]]){
            vLastStr = vLast;
        }
        //指数值12406
        ((UILabel *)[cell viewWithTag:12406]).text = [[RKDataManager sharedInstance] subRateString:vLastStr];
        //图表12407
        UIView *kLineBgView = (UIView *)[cell viewWithTag:12407];
        UIView *v = [kLineBgView viewWithTag:16052];
        if (v) {
            [v removeFromSuperview];
        }
        RKTimeKLine *kLine = [[RKTimeKLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 260)  xArr:_timeModel.xArr yArr:_timeModel.yArr];
        kLine.canScale = NO;
        kLine.tag = 16052;
        kLine.kLineDelegate = self;
        [kLineBgView addSubview:kLine];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titles = @[@"中债收益率", @"中债指数", @"中债估值", @"统计数据"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 94)];
    headerView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x1e1c1d);
    CGFloat dip = (SCREEN_WIDTH-20-20-46*4)/3;
    CGFloat buttonWidth = 46;
    for (int i=0;i<4;i++) {
        CGRect frame = CGRectMake(20+i*(buttonWidth+dip), 15, buttonWidth, buttonWidth);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.tag = 12100+i+1;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"data_%d",i]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(headerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 12)];
        label.backgroundColor = [UIColor clearColor];
        label.dk_textColorPicker = DKColorWithRGB(0x6d6d6d, 0x999999);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.center = CGPointMake(button.center.x, button.center.y+buttonWidth/2+label.frame.size.height/2+5);
        label.text = titles[i];
        [headerView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 93.5, SCREEN_WIDTH, 1)];
        line.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
        [headerView addSubview:line];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, 9)];
        view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
        [headerView addSubview:view];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark - ButtonClicked
- (void)headerButtonClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    switch (tag-12100) {
        case 1:
        {
            RKYieldRateViewController *yieldRate = [[RKYieldRateViewController alloc] init];
            yieldRate.pageType = RKYieldRatePageTypeInfoPage;
            yieldRate.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:yieldRate animated:YES];
        }
            break;
        case 2:
        {
            RKExponentViewController *exponent = [[RKExponentViewController alloc] init];
            exponent.pageType = RKExponentPageTypeInfoPage;
            exponent.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:exponent animated:YES];
        }
            break;
        case 3:
        {
            RKValuationViewController *valuation = [[RKValuationViewController alloc] init];
            valuation.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:valuation animated:YES];
        }
            break;
        case 4:
        {
            RKStatisticsViewController *statistics = [[RKStatisticsViewController alloc] init];
            statistics.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:statistics animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)changeKLineOfYiekldRate:(UIButton *)sender
{
    RKYieldRateViewController *yieldRate = [[RKYieldRateViewController alloc] init];
    yieldRate.pageType = RKYieldRatePageTypeChoice;
    yieldRate.delegate = self;
    yieldRate.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yieldRate animated:YES];
}
- (void)changeKLineOfExponent:(UIButton *)sender
{
    RKExponentViewController *exponent = [[RKExponentViewController alloc] init];
    exponent.pageType = RKExponentPageTypeChoice;
    exponent.delegate = self;
    exponent.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:exponent animated:YES];
}
- (void)yieldRatePage:(RKYieldRateViewController *)page didChoiceData:(RKRateInfoModel *)choice
{
    [self showHud];
    NSString *dateNow = [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:[NSDate date]];
    [self requestForRate:dateNow rateModel:choice];
}
- (void)exponentPage:(RKExponentViewController *)page didChoiceData:(RKCateLevelModel *)choice
{
    [self showHud];
    NSString *dateNow = [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:[NSDate date]];
    NSDate *bDate = [[RKDataManager sharedInstance] twoMonthAgo:[NSDate date]];
    NSString *bDateStr = [[RKDataManager sharedInstance].dateFormatter2 stringFromDate:bDate];
    [self requestForExponentWithBeginDate:bDateStr endDate:dateNow exponentModel:choice];
}

- (void)kLine:(id)kLine refreshDataWithX:(CGFloat)x andY:(CGFloat)y
{
    UIView *view = kLine;
    if (view.tag == 16051) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //待偿期12404
        ((UILabel *)[cell viewWithTag:12404]).text = [NSString stringWithFormat:@"%.1f",x];
        //收益率12405
        ((UILabel *)[cell viewWithTag:12405]).text = [NSString stringWithFormat:@"%.4f%%",y];
    }else if (view.tag == 16052){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        //时间12405
        CGFloat dateFloat = x * (60*60*24);
        NSDate *dateX = [NSDate dateWithTimeIntervalSinceReferenceDate:dateFloat];
        NSString *dateXString = [[RKDataManager sharedInstance].dateFormatter stringFromDate:dateX];
        ((UILabel *)[cell viewWithTag:12405]).text = [NSString stringWithFormat:@"日期:%@",dateXString];
        
        //指数值12406
        ((UILabel *)[cell viewWithTag:12406]).text = [NSString stringWithFormat:@"%.4f",y];
    }
}
- (void)kLineDidTapClicked:(id)kLine;
{}

-(void)kLineDidDoubleTapClicked:(id)kLine
{
    UIView *view = kLine;
    if (view.tag == 16051) {
        
        RKRateDetailController *detail = [[RKRateDetailController alloc] init];
        detail.rateModel = _model.rateInfoModel;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];

    }
    else if (view.tag == 16052)
    {
        RKExponentDetailController *detail = [[RKExponentDetailController alloc] init];
        detail.exponentModel = _timeModel.exponentModel;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - 横竖屏－仅竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

//右滑返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    else
    {
        return YES;
    }
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
