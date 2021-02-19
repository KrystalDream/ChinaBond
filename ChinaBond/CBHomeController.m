//
//  CBHomeController.m
//  ChinaBond
//
//  Created by wangran on 15/11/30.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBHomeController.h"
#import "CBValueView.h"
#import "LCBannerView.h"
#import "CBHomeItemCell.h"
#import "CBValueTitleCell.h"
#import "CBFocusCell.h"
#import "CBChannelController.h"
#import "CBSearchController.h"
//#import "CBFocusDetailController.h"
//#import "CBLaunchController.h"
#import "RKValuationViewController.h"
#import "CBMyCollectController.h"
#import "CBLoginController.h"
#import "RKYieldRateViewController.h"
#import "RKExponentViewController.h"
#import "CBFocusMoreController.h"
#import <AFNetworkReachabilityManager.h>
#import "UIScrollView+Associated.h"
//#import "CBadController.h"
#import "CSWebView.h"
#import "CBHomeBannerWebViewController.h"

@interface CBHomeController ()<UITableViewDataSource,UITableViewDelegate,LCBannerViewDelegate,UIGestureRecognizerDelegate,CBHomeChannelChoseDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) CBValueView *valueView;

@property (strong, nonatomic) NSArray *advList;
@property (strong, nonatomic) NSArray *menuList;
@property (strong, nonatomic) NSArray *infoList;
@property (strong, nonatomic) NSArray *guzhiList;
@property (strong, nonatomic) NSMutableArray *readArr;
@property (strong, nonatomic) NSMutableArray *webCacheArr;
@end

@implementation CBHomeController

#pragma mark --- 状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configueNav];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    //self.navigationController.navigationBar.dk_tintColorPicker = DKColorWithRGB(0xe53d3d, 0xffffff);
    self.tabBarController.tabBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    [self requestData];
    
    __weak typeof(self)weafSelf=self;
    
    self.tableView.refreshView=[[TiRefreshView alloc]initWithHandler:^{

        [weafSelf requestData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weafSelf.tableView.refreshView stopRefresh];
        });
    }];

    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            {
                BOOL downLoad = [[NSUserDefaults standardUserDefaults] boolForKey:KDownLoad];
                if (downLoad) {
                    NSArray *arrar = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeGuzhi"];
                    NSDictionary *response = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeJsonResponse"];
                    
                    [self.valueView reloadData:arrar];
                    
                    self.advList = response[@"advList"];
                    
                    [[CBCacheManager shareCache] saveCacheWithArray:response[@"menuList"]];
                    
                    self.infoList = response[@"infoList"];
                    
                    [self setArr:self.advList];
                    
                    [self.tableView reloadData];
                }
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                BOOL downLoad = [[NSUserDefaults standardUserDefaults] boolForKey:KDownLoad];
                if (downLoad) {
                    NSArray *arrar = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeGuzhi"];
                    NSDictionary *response = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeJsonResponse"];
                    
                    [self.valueView reloadData:arrar];
                    
                    self.advList = response[@"advList"];
                    
                    [[CBCacheManager shareCache] saveCacheWithArray:response[@"menuList"]];
                    
                    self.infoList = response[@"infoList"];
                    
                    [self setArr:self.advList];
                    
                    [self.tableView reloadData];
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                [self requestData];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                [self requestData];
            }
                break;
        }
    }];
    [mgr startMonitoring];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.tableView reloadData];

//    [MobClick event:@"1000"];
//    [MobClick beginLogPageView:@"Home"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"Home"];
}
- (void)requestData
{
    //估值接口
    
    [[CBHttpRequest shareRequest] postWithUrl:@"https://yield.chinabond.com.cn/cbweb-mn/GetIndexServlet/d2s"
                                       Params:nil
                                    completionBlock:^(id responseObject) {
       
        CBLog(@"首页请求--------------------%@", responseObject);

                                        //清空已读
                                        [self.readArr removeAllObjects];
                                        
                                        NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
                                        if ([state isEqualToString:@"0"]) {
                                            self.guzhiList = responseObject[@"lists"];
                                            /*
                                            self.guzhiList = @[@{@"dcq":@"1.9863",
                                                                 @"gzjz":@"100.0000",
                                                                 @"gzsyl":@"6.2600",
                                                                 @"zqdm":@"122112",
                                                                 @"zqjc":@"11沪大众"},
                                                               @{@"dcq":@"1.9863",
                                                                 @"gzjz":@"100.0000",
                                                                 @"gzsyl":@"6.2600",
                                                                 @"zqdm":@"122112",
                                                                 @"zqjc":@"12沪大众"},
                                                               @{@"dcq":@"1.9863",
                                                                 @"gzjz":@"100.0000",
                                                                 @"gzsyl":@"6.2600",
                                                                 @"zqdm":@"122112",
                                                                 @"zqjc":@"13沪大众"},
                                                               @{@"dcq":@"1.9863",
                                                                 @"gzjz":@"100.0000",
                                                                 @"gzsyl":@"6.2600",
                                                                 @"zqdm":@"122112",
                                                                 @"zqjc":@"14沪大众"}];
                                            */
                                            [self.valueView reloadData:self.guzhiList];
                                            [[NSUserDefaults standardUserDefaults] setObject:self.guzhiList forKey:@"homeGuzhi"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            [self.tableView reloadData];
                                        }
                                        else
                                        {
                                            [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                        }
                                        
                                    }   failBlock:^(NSError *error) {
                                        CBLog(@"%@",error);
                                    }];
    
    //重点关注接口

    [[CBHttpRequest shareRequest] getWithUrl:@"https://www.chinabond.com.cn/d2s/homepage.json"
                                        Params:nil
                                        completionBlock:^(id responseObject) {

                                            NSString *state = [responseObject objectForKey:@"state"];
                                            if ([state isEqualToString:@"0"]) {
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"homeJsonResponse"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                self.advList = responseObject[@"advList"];
                                                
                                                [[CBCacheManager shareCache] saveCacheWithArray:responseObject[@"menuList"]];
                                                
                                                self.infoList = responseObject[@"infoList"];
                                                
                                                [self setArr:self.advList];
                                                
                                                [self.tableView reloadData];
                                                
                                                /*
                                                //重点关注详情页缓存
                                                for (int i=0; i<self.infoList.count; i++) {
                                                    
                                                    NSURL *url=[NSURL URLWithString:self.infoList[i][@"infoUrl"]];
                                                    //    2.创建请求对象
                                                    NSURLRequest *request=[NSURLRequest requestWithURL:url];
                                                    //    3.发送请求
                                                    //发送同步请求，在主线程执行
                                                    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                                                        
                                                    }];
                                                }
                                                 */
                                            }
                                        } failBlock:^(NSError *error) {
                                                CBLog(@"%@",error);
                                        }];
    
}

- (void)setArr:(NSArray *)arr
{
    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115*(SCREEN_WIDTH/320))
                                                        delegate:self
                                                       imageURLs:arr
                                                placeholderImage:@""
                                                   timerInterval:2.0f
                                   currentPageIndicatorTintColor:UIColorFromRGB(0xffffff)
                                          pageIndicatorTintColor:UIColorFromRGB(0xcababa)];
    
    self.tableView.tableHeaderView = bannerView;
}

//配置nav样式
- (void)configueNav
{
    self.navigationItem.title = @"中国债券信息网";
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - tableView dataSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return self.infoList.count+1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 168;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 55;
        }
        if (indexPath.row == 1) {
            return 125;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 55;
        }
        return 75;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        CBHomeItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"CBHomeItemCell"];
        
        if (!itemCell) {
            itemCell = [CBHomeItemCell homeItemCell];
            itemCell.delegate = self;
        }
        
        [itemCell reloaData];
        
        itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell = itemCell;
    }
    else if (indexPath.section == 1)
    {
        
        if (indexPath.row == 0) {
            CBValueTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"CBValueTitleCell"];
            if (!titleCell) {
                titleCell = [CBValueTitleCell valueTitleCell];
            }
            titleCell.titleLab.text = @"中债估值";
            titleCell.titleLab.dk_textColorPicker = DKColorWithRGB(0x6D6D6D, 0x737373);
            titleCell.rightLab.dk_textColorPicker = DKColorWithRGB(0xBEBEBE, 0x737373);
            titleCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
            [titleCell.moreButton addTarget:self action:@selector(moreButtonClick1) forControlEvents:UIControlEventTouchUpInside];
            cell = titleCell;
        }
        
        
        if (indexPath.row == 1) {
            static NSString *cellIndentifier = @"ValueCell";
            UITableViewCell *valueCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!valueCell) {
                valueCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
                self.valueView = [[CBValueView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
                
                [valueCell.contentView addSubview:self.valueView];
            }
            
            cell = valueCell;
        }
    }
    else if (indexPath.section == 2)
    {
        
        if (indexPath.row == 0) {
            CBValueTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"CBValueTitleCell"];
            if (!titleCell) {
                titleCell = [CBValueTitleCell valueTitleCell];
            }
            titleCell.titleLab.text = @"重点关注";
            titleCell.titleLab.dk_textColorPicker = DKColorWithRGB(0x6D6D6D, 0x737373);
            titleCell.rightLab.dk_textColorPicker = DKColorWithRGB(0xBEBEBE, 0x737373);
            titleCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
            [titleCell.moreButton addTarget:self action:@selector(moreButtonClick2) forControlEvents:UIControlEventTouchUpInside];
            cell = titleCell;
        }
        else
        {
            CBFocusCell *focus = [tableView dequeueReusableCellWithIdentifier:@"CBFocusCell"];
            if (!focus) {
                focus = [CBFocusCell focusCell];
            }
            
            if (self.readArr.count>0) {
                for (NSString *tid in self.readArr) {
                    if (tid == self.infoList[indexPath.row-1][@"tId"]) {
                        focus.titleLab.dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x404040);
                    }
                }
            }
            else
            {
                focus.titleLab.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
            }
            
            
            focus.timeLab.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x404040);
            focus.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
            focus.titleLab.text = self.infoList[indexPath.row-1][@"title"];
            focus.timeLab.text = self.infoList[indexPath.row-1][@"vTime"];
            [focus.foucsImage sd_setImageWithURL:[NSURL URLWithString:self.infoList[indexPath.row-1][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
            
            cell = focus;
 
        }
            
    }
    
    cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            RKValuationViewController *valuation = [[RKValuationViewController alloc] init];
            valuation.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:valuation animated:YES];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row != 0) {
            
//            CBFocusDetailController *focusDetail = [[CBFocusDetailController alloc] init];
            CSWebView *focusDetail = [[CSWebView alloc] init];
            focusDetail.titleS = @"重点关注";
            focusDetail.hidesBottomBarWhenPushed = YES;
            focusDetail.infoDic = self.infoList[indexPath.row-1];
            focusDetail.infoUrl = self.infoList[indexPath.row-1][@"infoUrl"];
            focusDetail.tId = self.infoList[indexPath.row-1][@"tId"];
            [self.navigationController pushViewController:focusDetail animated:YES];
            
            [self.readArr addObject:self.infoList[indexPath.row-1][@"tId"]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }
    
}

#pragma mark - button click method
- (void)rightButtonClick
{
    CBSearchController *search = [[CBSearchController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    search.isZNSearch = YES;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)moreButtonClick1
{
    RKValuationViewController *valuation = [[RKValuationViewController alloc] init];
    valuation.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:valuation animated:YES];
}
- (void)moreButtonClick2
{
    CBFocusMoreController *focusMore = [[CBFocusMoreController alloc] init];
    focusMore.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:focusMore animated:YES];
}

#pragma mark - LCBannerViewDelegate

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
//    CBadController *adVC = [[CBadController alloc] init];
    CBHomeBannerWebViewController *adVC = [[CBHomeBannerWebViewController alloc] init];
    adVC.infoUrl = self.advList[index][@"infoUrl"];
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];

}
//首页快捷菜单按钮方法
-(void)choseChannel:(NSDictionary *)dic
{
    if ([dic[@"name"] isEqualToString:@"添加自定义"]) {
        CBChannelController *channel = [[CBChannelController alloc] init];
        channel.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:channel animated:YES];
    }
    else if ([dic[@"name"] isEqualToString:@"我的收藏"])
    {
        
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSString *isLogStr = [userDic objectForKey:@"isLog"];
        
        if ([isLogStr isEqualToString:@"1"])
        {
            CBMyCollectController *myCollect = [[CBMyCollectController alloc] init];
            myCollect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myCollect animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            [alert show];
        }
    }
    else if ([dic[@"name"] isEqualToString:@"中债收益率"]) {
        RKYieldRateViewController *yieldRate = [[RKYieldRateViewController alloc] init];
        yieldRate.pageType = RKYieldRatePageTypeInfoPage;
        yieldRate.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:yieldRate animated:YES];
    }
    else if ([dic[@"name"] isEqualToString:@"信息披露"]) {
        
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [mDic setObject:@"4" forKey:@"level1"];
        [mDic setObject:@"0" forKey:@"level2"];
        [mDic setObject:@"0" forKey:@"level3"];
        
        [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:@"channelFast"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.tabBarController.selectedIndex = 2;
    }
    else if ([dic[@"name"] isEqualToString:@"中债指数"]) {
        RKExponentViewController *exponent = [[RKExponentViewController alloc] init];
        exponent.pageType = RKExponentPageTypeInfoPage;
        exponent.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:exponent animated:YES];
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"channelFast"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.tabBarController.selectedIndex = 2;
    }
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        CBLoginController *login = [[CBLoginController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (NSMutableArray *)readArr
{
    if (!_readArr) {
        _readArr = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _readArr;
}

- (NSMutableArray *)webCacheArr
{
    if (!_webCacheArr) {
        _webCacheArr = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _webCacheArr;
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
