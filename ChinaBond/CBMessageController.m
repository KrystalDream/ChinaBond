//
//  CBMessageController.m
//  ChinaBond
//
//  Created by wangran on 15/11/30.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBMessageController.h"
#import "CBFocusCell.h"
#import "CBFirstLevelButton.h"
#import "CBSecondLevelButton.h"
#import "CBThreeLevelButton.h"
#import "CBSellNewsDetailController.h"
#import "UITabBar+badge.h"
#import "UIScrollView+Associated.h"
#import "CBTaskTipsCell.h"
#import "NSDictionary+ModelParse.h"
#import "CBSellNewsCell.h"
#import "CBFocusDetailController.h"
#import "CBTaskTipHeadCell.h"
//#import "CustomDatePickerView.h"
//#import "JCAlertView.h"
#import "MJRefresh/MJZhongZhaiHeader.h"
#import "CBZNSearchResultCell.h"
#import <AFNetworkReachabilityManager.h>
#import "STPickerDate.h"
#import "CSWebView.h"

@interface CBMessageController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,STPickerDateDelegate>

{
    int _typeid;//资讯类型
    NSString *_cId;
//    JCAlertView *_alert;
    int _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSMutableArray *infoList;//信息list
@property (nonatomic, strong) NSArray *dataList;//频道list
@property (nonatomic, strong) NSArray *yewuInfoList;

@property (nonatomic, strong) NSArray *menu2List;
@property (nonatomic, strong) NSArray *menu3List;

@property (nonatomic) NSInteger firstLevelSelect;
@property (nonatomic) NSInteger secondLevelSelect;
@property (nonatomic) NSInteger threeLevelSelect;

@property (nonatomic, retain) NSDate *dateTime;//重要业务提示时间
//@property (strong, nonatomic) CustomDatePickerView *picker;

@property (nonatomic, strong) NSMutableArray *readArr;

@property (nonatomic, strong) UIView *guideView;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) STPickerDate *pickerDate;


@end

@implementation CBMessageController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
    //配置navgationbar title字体颜色、字号
    self.navigationItem.title = @"中国债券信息网";
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //如果不是从首页快捷如果跳转过来
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelFast"];
    if (!dic) {
        _cId = @"14175918";
        
        self.firstLevelSelect = 2+[dic[@"level1"] intValue];
        self.secondLevelSelect = 100+[dic[@"level2"] intValue];
        self.threeLevelSelect = 1000+[dic[@"level3"] intValue];
    }
    
    //重要业务提示时间参数初始化
    self.dateTime = [NSDate date];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-46) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.clipsToBounds = YES;
    [self.view addSubview:self.tableView];
    
    [self reachabilityCheck];
    
    __weak typeof(self)weakSelf=self;
    
    //下拉刷新按钮
    self.tableView.refreshView=[[TiRefreshView alloc]initWithHandler:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView.refreshView stopRefresh];
            
            [weakSelf requestChannel];
        });
    }];
    
    //上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.mj_footer beginRefreshing];
        [weakSelf footerRefresh];
    }];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    self.headerView.clipsToBounds = YES;
    self.tableView.tableHeaderView = self.headerView;
    
    
    //日期控件
//    self.picker = [[CustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
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
//
//                [strongSelf.infoList removeAllObjects];
//                strongSelf.yewuInfoList = @[];
//                [strongSelf.tableView reloadData];
//
//                NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                [format setDateFormat:@"yyyy-MM-dd"];
//
//                strongSelf.dateTime = [format dateFromString:date];
//                [strongSelf reachabilityCheck];
//            }];
//        }
//    };

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"messageFirst"]) {
        self.guideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.guideView.backgroundColor = UIColorFromRGB(0x000000);
        self.guideView.alpha = .7;
        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
        
        UIImageView *guideImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 53, 200, 160)];
        guideImage.image = [UIImage imageNamed:@"guide_xiala"];
        [self.guideView addSubview:guideImage];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGes:)];
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        [self.guideView addGestureRecognizer:swipe];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"messageFirst"];
    }
    
    
    
    //夜间模式颜色配置
    self.tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorWithRGB(0xffffff, 0x1e1c1d);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    //self.navigationController.navigationBar.dk_tintColorPicker = DKColorWithRGB(0xe53d3d, 0xffffff);
    self.tabBarController.tabBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x000000);

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick event:@"1004"];
    [MobClick beginLogPageView:@"Message"];
    
    //首页快捷菜单入口跳转传入资讯类型
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelFast"];
    
    //配置资讯类型
    if (dic) {
        _cId = @"14175918";
        
        self.firstLevelSelect = 2+[dic[@"level1"] intValue];
        self.secondLevelSelect = 100+[dic[@"level2"] intValue];
        self.threeLevelSelect = 1000+[dic[@"level3"] intValue];
        
        [self requestChannel];
    }
   
    //[self.tableView.refreshView pullRefresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除快捷菜单缓存
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"channelFast"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MobClick endLogPageView:@"Message"];
}

#pragma mark - http request

- (void)footerRefresh
{
    [self reqeuestData];
}

- (void)reachabilityCheck
{
//
//    // 1.获得网络监控的管理者
//    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//    // 2.设置网络状态改变后的处理
//    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        // 当网络状态改变了, 就会调用这个block
//        switch (status)
//        {
//            case AFNetworkReachabilityStatusUnknown: // 未知网络
//            {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                [MBProgressHUD bwm_showTitle:@"请连接网络" toView:self.view hideAfter:2];
//            }
//                break;
//            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//            {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                [MBProgressHUD bwm_showTitle:@"请连接网络" toView:self.view hideAfter:2];
//            }
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//            {
//                CBLog(@"手机自带网络");
//                [self requestChannel];
//            }
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//            {
//                CBLog(@"WIFI");
//                [self requestChannel];
//            }
//                break;
//        }
//    }];
//    [mgr startMonitoring];
    
    [self requestChannel];

}

- (void)reqeuestData
{
    switch (_typeid) {
        case 1://发行快报
        {
            [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                              Params:@{@"SID":@"02"}
                                                      /* @"pageSize":@"10",
                                                       @"pageNum":@(_page)}*/
                                     completionBlock:^(id responseObject) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         [self.tableView.mj_footer endRefreshing];
                                         NSString *state = [responseObject objectForKey:@"state"];
                                         if ([state isEqualToString:@"0"]) {
                                             if (self.infoList.count==0) {
                                                 
                                                 [self.infoList addObjectsFromArray:responseObject[@"dataList"]];
                                                 [self.tableView reloadData];
                                                 
                                                 if (((NSArray *)responseObject[@"dataList"]).count == 10) {
                                                     _page++;
                                                 }
                                             }
                                         }
                                         else
                                         {
                                             [self.infoList removeAllObjects];
                                             [self.tableView reloadData];
                                             [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                         }
                                         
                                         [self.tableView.refreshView stopRefresh];
                                         
                                     } failBlock:^(NSError *error) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         [self.tableView.refreshView stopRefresh];
                                     }];
        }
            break;
            
        case 2://数据统计
        {
            
        }
            break;
            
        case 3://资讯信息
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                              Params:@{@"SID":@"10",
                                                       @"cId":_cId,
                                                       @"pageSize":@"10",
                                                       @"pageNum":@(_page)}
                                     completionBlock:^(id responseObject) {
                                         [self.tableView.mj_footer endRefreshing];
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         NSString *state = [responseObject objectForKey:@"state"];
                                         if ([state isEqualToString:@"0"]) {
                                             
                                             [self.infoList addObjectsFromArray:responseObject[@"infoList"]];
                                             [self.tableView reloadData];
                                             
                                             if (((NSArray *)responseObject[@"infoList"]).count == 10) {
                                                 _page++;
                                             }
                                             
                                         }
                                         else
                                         {
                                             [self.infoList removeAllObjects];
                                             [self.tableView reloadData];
                                             [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                         }
                                         
                                         [self.tableView.refreshView stopRefresh];
                                         
                                     } failBlock:^(NSError *error) {
                                         [self.tableView.refreshView stopRefresh];
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         
                                     }];
        }
            break;
            
        case 4://重要业务提示
        {
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [format stringFromDate:self.dateTime];
            
            [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                              Params:@{@"SID":@"05",
                                                       @"sTime":dateStr}
                                     completionBlock:^(id responseObject) {
                                         
                                         [self.tableView.mj_footer endRefreshing];
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         
                                         NSString *state = [responseObject objectForKey:@"state"];
                                         if ([state isEqualToString:@"0"]) {
                                             
                                             if (self.infoList.count==0) {
                                                 [self.infoList addObjectsFromArray:responseObject[@"dataList"]];
                                                 
                                             }
                                             
                                             self.yewuInfoList = responseObject[@"infoList"];
                                             
                                             [self.tableView reloadData];
                                             
                                         }
                                         else
                                         {
                                             [self.infoList removeAllObjects];
                                             [self.tableView reloadData];
                                             [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                         }
                                         
                                         [self.tableView.refreshView stopRefresh];
                                         
                                     } failBlock:^(NSError *error) {
                                         [self.tableView.refreshView stopRefresh];
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     }];
            
            
        }
            break;
            
    }
}

- (void)requestChannel
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CBHttpRequest shareRequest] getWithUrl:@"http://www.chinabond.com.cn/d2s/menu.json"
                                          Params:nil
                                 completionBlock:^(id responseObject) {
        
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     self.dataList = responseObject[@"menu1List"];
                                     
                                     [self setHeaderView];
                                     
                                    }
                                    failBlock:^(NSError *error) {
  
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                }];
}

#pragma mark head channel set 一级菜单  二级菜单  三级菜单

//设置频道等级列表

//一级菜单
- (void)setHeaderView
{
    CGFloat totalWidth = 0;
    
    for (UIView *view in self.headerView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIScrollView *firstScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    firstScr.showsHorizontalScrollIndicator = NO;
    firstScr.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x282727);
    firstScr.bounces = NO;
    firstScr.tag = 10000;
    
    [self.headerView addSubview:firstScr];
    
    for (int i=0 ;i<self.dataList.count ;i++) {
        
        NSDictionary *firstLevel = self.dataList[i];
        //第一次进入获取分类id
        if (i==0) {
            //分类id
            _typeid = [firstLevel[@"typeid"] intValue];
            //获取分类数据
            _page = 0;
            //[self reqeuestData];
        }
        
        NSString *channelStr = [firstLevel objectForKey:@"label"];
        
        CGSize firstLevelButtonSize = [channelStr sizeWithFont:Font(15) constrainedToSize:CGSizeMake(1000, 35)];
        
        CBFirstLevelButton *firstLevelButton = [[CBFirstLevelButton alloc] initWithFrame:CGRectMake(totalWidth, 2, firstLevelButtonSize.width+20, 40)];
        firstLevelButton.layer.cornerRadius = 3;
        firstLevelButton.layer.masksToBounds = YES;
        [firstLevelButton dk_setTitleColorPicker:DKColorWithRGB(0x4c4c4c, 0x888888) forState:UIControlStateNormal];
        [firstLevelButton dk_setTitleColorPicker:DKColorWithRGB(0xd74848, 0xad4343) forState:UIControlStateSelected];
        
        totalWidth += (firstLevelButtonSize.width+20);
        
        firstLevelButton.tag = i+2;

        if (firstLevelButton.tag == self.firstLevelSelect) {
            firstLevelButton.selected = YES;
        }
        
        [firstLevelButton setTitle:channelStr forState:UIControlStateNormal];
        
        [firstLevelButton addTarget:self action:@selector(firstLevlebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (firstLevelButton.tag == self.firstLevelSelect) {

            [self firstLevlebuttonClick:firstLevelButton];
        }
        
        [firstScr addSubview:firstLevelButton];
        
    }
    
    firstScr.contentSize = totalWidth > SCREEN_WIDTH ? CGSizeMake(totalWidth, 40) : CGSizeMake(SCREEN_WIDTH, 40);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, firstScr.contentSize.width, 1)];
    lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd5d5d5, 0x484848);
    lineView.tag = 9999;
    [firstScr addSubview:lineView];
    [firstScr bringSubviewToFront:lineView];
    
    [self.tableView reloadData];
}
//二级菜单
- (void)setHeaderSecondLevel:(NSArray *)arr
{
    CGFloat totalWidth = 0;
    
    UIScrollView *secondScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
    secondScr.showsHorizontalScrollIndicator = NO;
    secondScr.dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x333333);
    secondScr.tag = 20000;
    
    CGRect newFrame = self.headerView.frame;
    newFrame.size.height = 40+40;
    self.headerView.frame = newFrame;
    
//    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.headerView];
//    [self.tableView endUpdates];
    
    [self.headerView addSubview:secondScr];
    
    for (int i=0 ;i<arr.count ;i++) {
        
        NSDictionary *secondLevel = arr[i];
        
        NSString *channelStr = [secondLevel objectForKey:@"label"];
        
        CGSize secondLevelButtonSize = [channelStr sizeWithFont:Font(15) constrainedToSize:CGSizeMake(1000, 35)];
        
        CBSecondLevelButton *secondLevelButton = [[CBSecondLevelButton alloc] initWithFrame:CGRectMake(totalWidth, 5, secondLevelButtonSize.width+20, 30)];
        
        secondLevelButton.layer.borderColor = UIColorFromRGB(0xf95e5c).CGColor;
        secondLevelButton.layer.borderWidth = 0;
        secondLevelButton.layer.cornerRadius = 3;
        
        [secondLevelButton dk_setTitleColorPicker:DKColorWithRGB(0x6d6d6d, 0x7f7f7f) forState:UIControlStateNormal];
        [secondLevelButton dk_setTitleColorPicker:DKColorWithRGB(0xf95e5c, 0xad4343) forState:UIControlStateSelected];
        
        totalWidth += (secondLevelButtonSize.width+20);
        
        secondLevelButton.tag = i+100;
        
        if (secondLevelButton.tag == self.secondLevelSelect) {
            secondLevelButton.selected = YES;
        }
        
        [secondLevelButton setTitle:channelStr forState:UIControlStateNormal];
        
        [secondLevelButton addTarget:self action:@selector(secondLevlebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (secondLevelButton.tag == self.secondLevelSelect) {
            [self secondLevlebuttonClick:secondLevelButton];
        }
        
        [secondScr addSubview:secondLevelButton];
        
    }
    
    secondScr.contentSize = totalWidth > SCREEN_WIDTH ? CGSizeMake(totalWidth, 40) : CGSizeMake(SCREEN_WIDTH, 40);
}
//三级菜单
- (void)setHeaderThreeLevel:(NSArray *)arr
{
    CGFloat totalWidth = 0;
    
    UIScrollView *threeScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40+40, SCREEN_WIDTH, 40)];
    threeScr.showsHorizontalScrollIndicator = NO;
    threeScr.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x404040);
    threeScr.tag = 30000;
    
    CGRect newFrame = self.headerView.frame;
    newFrame.size.height = 40+40+40;
    self.headerView.frame = newFrame;
    
//    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.headerView];
//    [self.tableView endUpdates];
    
    [self.headerView addSubview:threeScr];
    
    for (int i=0 ;i<arr.count ;i++) {
        
        NSDictionary *threeLevel = arr[i];
        
        NSString *channelStr = [threeLevel objectForKey:@"label"];
        
        CGSize secondLevelButtonSize = [channelStr sizeWithFont:Font(15) constrainedToSize:CGSizeMake(1000, 35)];
        
        CBThreeLevelButton *threeLevelButton = [[CBThreeLevelButton alloc] initWithFrame:CGRectMake(totalWidth, 3, secondLevelButtonSize.width+20, 35)];
        
        [threeLevelButton dk_setTitleColorPicker:DKColorWithRGB(0x868686, 0x7f7f7f) forState:UIControlStateNormal];
        [threeLevelButton dk_setTitleColorPicker:DKColorWithRGB(0xfd8d38, 0xd47b37) forState:UIControlStateSelected];
        
        totalWidth += (secondLevelButtonSize.width+20);
        
        threeLevelButton.tag = i+1000;
        
        if (threeLevelButton.tag == self.threeLevelSelect) {
            threeLevelButton.selected = YES;
        }
        
        [threeLevelButton setTitle:channelStr forState:UIControlStateNormal];
        
        [threeLevelButton addTarget:self action:@selector(threeLevlebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (threeLevelButton.tag == self.threeLevelSelect) {
            [self threeLevlebuttonClick:threeLevelButton];
        }
        
        [threeScr addSubview:threeLevelButton];
        
    }
    
    threeScr.contentSize = totalWidth > SCREEN_WIDTH ? CGSizeMake(totalWidth, 40) : CGSizeMake(SCREEN_WIDTH, 40
                                                                                               );
}


#pragma mark - head channel method

- (void)firstLevlebuttonClick:(CBFirstLevelButton *)sender
{
    sender.selected = YES;
    sender.dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x333333);
    UIScrollView *firstScr = (UIScrollView *)[self.headerView viewWithTag:10000];
    
    if (sender.tag != self.firstLevelSelect) {
        
        ((CBFirstLevelButton *)[firstScr viewWithTag:self.firstLevelSelect]).selected = NO;
        ((CBFirstLevelButton *)[firstScr viewWithTag:self.firstLevelSelect]).dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x282727);
        self.firstLevelSelect = sender.tag;
    }
    
        
    NSDictionary *firstDic = self.dataList[self.firstLevelSelect-2];
    
    self.menu2List = firstDic[@"menu2List"];
    
    UIScrollView *secondScr = (UIScrollView *)[self.headerView viewWithTag:20000];
    [secondScr removeFromSuperview];
    
    //判断所选频道类型
    int tmpType = 0;
    
    if ([[firstDic objectForKey:@"typeid"] isEqualToString:@"001"]) {
        tmpType = 1;//发行快报
    }
    else if ([[firstDic objectForKey:@"typeid"] isEqualToString:@"002"])
    {
        tmpType = 2;//数据统计
    }
    else if ([[firstDic objectForKey:@"typeid"] isEqualToString:@"003"])
    {
        tmpType = 3;//资讯信息
    }
    else if ([[firstDic objectForKey:@"typeid"] isEqualToString:@"004"])
    {
        tmpType = 4;//重要业务提示
    }
    
    if (tmpType != _typeid) {
        _typeid = tmpType;
    }
    
    //判断是否有二级菜单，如果有，则创建或者刷新二级菜单，如果没有，则去掉二级菜单
    UIView *lineView = [(UIView *)firstScr viewWithTag:9999];
    if (self.menu2List.count>0) {
        [self setHeaderSecondLevel:self.menu2List];
        
        //lineView.frame = CGRectMake(0, 39, firstScr.contentSize.width, 1);
        lineView.hidden = YES;
    }
    else
    {
        //lineView.frame = CGRectMake(0, 37, firstScr.contentSize.width, 1);
        lineView.hidden = NO;
        CGRect newFrame = self.headerView.frame;
        newFrame.size.height = 38;
        self.headerView.frame = newFrame;
        
        [self.tableView setTableHeaderView:self.headerView];
        
        
        _cId = [NSString stringWithFormat:@"%@",firstDic[@"channelD"]];
        _page = 0;
        [self.infoList removeAllObjects];
        
        [self.tableView reloadData];
        
        self.titleStr = sender.titleLabel.text;
        
        [self reqeuestData];
    }

}

- (void)secondLevlebuttonClick:(CBSecondLevelButton *)sender
{
    sender.selected = YES;
    sender.layer.borderWidth = 1.0;
    if (sender.tag != self.secondLevelSelect) {
        UIScrollView *secondScr = (UIScrollView *)[self.headerView viewWithTag:20000];
        ((CBSecondLevelButton *)[secondScr viewWithTag:self.secondLevelSelect]).selected = NO;
        ((CBSecondLevelButton *)[secondScr viewWithTag:self.secondLevelSelect]).layer.borderWidth = 0;
        self.secondLevelSelect = sender.tag;
    }
        
    NSDictionary *secondDic = self.menu2List[self.secondLevelSelect-100];
        
    self.menu3List = secondDic[@"menu3List"];
        
    UIScrollView *threeScr = (UIScrollView *)[self.headerView viewWithTag:30000];
    [threeScr removeFromSuperview];

        
    if (self.menu3List.count>0) {
        [self setHeaderThreeLevel:self.menu3List];
    }
    else
    {
        CGRect newFrame = self.headerView.frame;
        newFrame.size.height = 38+40;
        self.headerView.frame = newFrame;
        
        [self.tableView setTableHeaderView:self.headerView];
        
        
        _cId = [NSString stringWithFormat:@"%@",secondDic[@"channelD"]];
        _page = 0;
        [self.infoList removeAllObjects];
        
        self.titleStr = sender.titleLabel.text;
        
        [self.tableView reloadData];
        [self reqeuestData];
    }
}

- (void)threeLevlebuttonClick:(CBThreeLevelButton *)sender
{
    sender.selected = YES;
    
    if (sender.tag != self.threeLevelSelect) {
        
        UIScrollView *threeScr = (UIScrollView *)[self.headerView viewWithTag:30000];
        ((CBThreeLevelButton *)[threeScr viewWithTag:self.threeLevelSelect]).selected = NO;
        self.threeLevelSelect = sender.tag;
    }
        
    NSDictionary *threeDic = self.menu3List[self.threeLevelSelect-1000];
        
    _cId = [NSString stringWithFormat:@"%@",threeDic[@"channelD"]];
    _page = 0;
    [self.infoList removeAllObjects];
    
    self.titleStr = sender.titleLabel.text;
    
    [self.tableView reloadData];
    [self reqeuestData];
}

#pragma mark tableview datesource and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_typeid == 4) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_typeid == 4) {
        
        if (section == 0) {
            return self.infoList.count+1;
        }
        return self.yewuInfoList.count+1;
        
    }
    return self.infoList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    switch (_typeid) {
        case 1:
        {
            height = 59;
        }
            break;
            
        case 2:
        {
            
        }
            break;
            
        case 3:
        {
            height = 75;
        }
            break;
            
        case 4:
        {
            if (indexPath.section == 0) {

                height = 50;
            }
            else
            {
                if (indexPath.row == 0) {
                    height = 10;
                }
                else
                {
                    height = 75;
                }
            }
        }
            break;
            
    }
    return height;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    switch (_typeid) {
        case 1:
        {
            CBSellNewsCell *sellnews = [tableView dequeueReusableCellWithIdentifier:@"CBSellNewsCell"];
            if (!sellnews) {
                sellnews = [CBSellNewsCell sellNewsCell];
            }
            sellnews.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
            sellnews.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
            if (self.infoList.count>0) {
                sellnews.newsName.text = self.infoList[indexPath.row][@"zqjc"];
            }
            
            if (indexPath.row%1==0) {
                sellnews.newsTypeImage.image = [UIImage imageNamed:@"task_0"];
            }
            if (indexPath.row%2==0) {
                sellnews.newsTypeImage.image = [UIImage imageNamed:@"task_1"];
            }
            if (indexPath.row%3==0) {
                sellnews.newsTypeImage.image = [UIImage imageNamed:@"task_2"];
            }
            if (indexPath.row%4==0) {
                sellnews.newsTypeImage.image = [UIImage imageNamed:@"task_4"];
            }
            
            cell = sellnews;

        }
            break;
        
        case 2:
        {
            
        }
            break;
            
        case 3:
        {
            CBFocusCell *focus = [tableView dequeueReusableCellWithIdentifier:@"CBFocusCell"];
            if (!focus) {
                focus = [CBFocusCell focusCell];
            }
            if (self.readArr.count>0) {
                for (NSString *tid in self.readArr) {
                    if (tid == self.infoList[indexPath.row][@"tId"]) {
                        focus.titleLab.dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x404040);
                        
                    }
                    else
                    {
                        focus.titleLab.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
                    }
                }
            }
            else
            {
                focus.titleLab.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
            }
            focus.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
            focus.timeLab.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x404040);
            focus.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
            
            if (self.infoList.count>0) {
                focus.titleLab.text = self.infoList[indexPath.row][@"title"];
                focus.timeLab.text = self.infoList[indexPath.row][@"vTime"];
                [focus.foucsImage sd_setImageWithURL:[NSURL URLWithString:self.infoList[indexPath.row][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
            }
            
            cell = focus;
        }
            break;
            
        case 4:
        {
            if (indexPath.section == 0) {
                
                if (indexPath.row == 0) {
                    
                    CBTaskTipHeadCell *taskTipsHead = [tableView dequeueReusableCellWithIdentifier:@"CBTaskTipHeadCell"];
                    if (!taskTipsHead) {
                        taskTipsHead = [CBTaskTipHeadCell taskTipsHeadCell];
                    }
                    taskTipsHead.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
                    taskTipsHead.timeLabel.text = [self formatTime:self.dateTime];
                    [taskTipsHead.timeButton addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
                    cell = taskTipsHead;
                    
                }
                else
                {
                    CBTaskTipsCell *taskTips = [tableView dequeueReusableCellWithIdentifier:@"CBTaskTipsCell"];
                    if (!taskTips) {
                        taskTips = [CBTaskTipsCell taskTipsCell];
                    }
                    taskTips.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
                    if (self.infoList.count>0) {
                        NSDictionary *infoDic = self.infoList[indexPath.row-1];
                        
                        [self configueCell:taskTips andInfoDic:infoDic];
                    }
                    
                    cell = taskTips;
                }
            }
            else
            {
                
                if (indexPath.row == 0) {
                    
                    static NSString *cellIndentifier = @"sectionCell";
                    
                    UITableViewCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                    if (!sectionCell) {
                        sectionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                        sectionCell.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
                    }
                    
                    cell = sectionCell;
                    
                }
                else
                {
                    CBZNSearchResultCell *resultCell = [tableView dequeueReusableCellWithIdentifier:@"CBZNSearchResultCell"];
                    if (!resultCell) {
                        resultCell = [CBZNSearchResultCell searchResultCell];
                    }
                    
                    resultCell.resultTitle.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
                    
                    resultCell.resultTime.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x404040);
                    resultCell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
                    //resultCell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
                    resultCell.resultTitle.text = self.yewuInfoList[indexPath.row-1][@"title"];
                    resultCell.resultTime.text = self.yewuInfoList[indexPath.row-1][@"vTime"];
                    resultCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = resultCell;
                }
            }
           
        }
            break;
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_typeid) {
        case 1:
        {
            //
            CBSellNewsDetailController *newsDetail = [[CBSellNewsDetailController alloc] init];
            newsDetail.hidesBottomBarWhenPushed = YES;
            newsDetail.infoDic = self.infoList[indexPath.row];
            [self.navigationController pushViewController:newsDetail animated:YES];
        }
            break;
        case 2:
        {
            
        }
        break;
            case 3:
        {
//            CBFocusDetailController *focusDetail = [[CBFocusDetailController alloc] init];
            CSWebView *focusDetail = [[CSWebView alloc] init];

            focusDetail.hidesBottomBarWhenPushed = YES;
            focusDetail.titleS = self.titleStr;
            focusDetail.tId = self.infoList[indexPath.row][@"tId"];
            focusDetail.infoUrl = self.infoList[indexPath.row][@"infoUrl"];
            focusDetail.infoDic = self.infoList[indexPath.row];
            [self.navigationController pushViewController:focusDetail animated:YES];
            
            [self.readArr addObject:self.infoList[indexPath.row][@"tId"]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        case 4:
        {
            if (indexPath.section == 1) {
                
//                CBFocusDetailController *focusDetail = [[CBFocusDetailController alloc] init];
//                focusDetail.hidesBottomBarWhenPushed = YES;
//                focusDetail.infoDic = self.yewuInfoList[indexPath.row];
//                focusDetail.infoUrl = self.yewuInfoList[indexPath.row][@"infoUrl"];
//                focusDetail.tId = self.yewuInfoList[indexPath.row][@"tId"];
//                [self.navigationController pushViewController:focusDetail animated:YES];
            }
        }
            break;

    }
    
    
}


- (void)configueCell:(CBTaskTipsCell *)cell andInfoDic:(NSDictionary *)dic
{
    NSString *lxStr = dic[@"lx"];
    
    switch (lxStr.intValue) {
        case 1:
        {
            cell.taskName.text = @"到期兑付";
            cell.taskImage.dk_imagePicker = DKImageWithNames(@"taskTip_1", @"taskTip_1_night");
        }
            break;
        case 2:
        {
            cell.taskName.text = @"付息";
            cell.taskImage.dk_imagePicker = DKImageWithNames(@"taskTip_2", @"taskTip_2_night");
        }
            break;
        case 3:
        {
            cell.taskName.text = @"缴款";
            cell.taskImage.dk_imagePicker = DKImageWithNames(@"taskTip_3", @"taskTip_3_night");
        }
            break;
        case 4:
        {
            cell.taskName.text = @"上市流通";
            cell.taskImage.dk_imagePicker = DKImageWithNames(@"taskTip_4", @"taskTip_4_night");
        }
            break;
        case 6:
        {
            cell.taskName.text = @"追加注册";
            cell.taskImage.dk_imagePicker = DKImageWithNames(@"taskTip_6", @"taskTip_6_night");
        }
            break;
        case 7:
        {
            cell.taskName.text = @"投资人回售";
            cell.taskImage.dk_imagePicker = DKImageWithNames(@"taskTip_7", @"taskTip_7_night");
        }
            break;
        case 8:
        {
            cell.taskName.text = @"投资人调换";
            cell.taskImage.dk_imagePicker = DKImageWithNames(@"taskTip_8", @"taskTip_8_night");
        }
            break;
        case 9:
        {
            cell.taskName.text = @"投资人定向转让";
            cell.taskImage.dk_imagePicker = DKImageWithNames(@"taskTip_9", @"taskTip_9_night");
        }
            break;
        
    }
    
    cell.taskCode.text = dic[@"jxfs"];
    cell.taskCodeName.text = [dic[@"zqdm"] componentsSeparatedByString:@"("][0];
}

#pragma mark- time format

- (NSString *)formatTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日_EEEE"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

- (void)changeTime:(UIButton *)sender
{
//    _alert = [[JCAlertView alloc] initWithCustomView:self.picker dismissWhenTouchedBackground:YES];
//    [_alert show];
    
//    STPickerDate *pickerDate = [[STPickerDate alloc]init];
//               pickerDate.tag = 2019;
//               [pickerDate setDelegate:self];
//               pickerDate.pickerTitle = @"入学时间";
//               [pickerDate show];
    
    [self.pickerDate show];
}

-(NSMutableArray *)readArr
{
    if (!_readArr) {
        _readArr = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _readArr;
}

-(NSMutableArray *)infoList
{
    if (!_infoList) {
        _infoList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _infoList;
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

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)swipeGes:(UISwipeGestureRecognizer *)gesture
{
    [self.guideView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark DatePickerDelegate
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSString *m = ((month<10)? [NSString stringWithFormat:@"0%zd",month] : [NSString stringWithFormat:@"%zd",month]);
    NSString *d = ((day<10)? [NSString stringWithFormat:@"0%zd",day] : [NSString stringWithFormat:@"%zd",day]);
    NSString *text = [NSString stringWithFormat:@"%zd-%@-%@", year, m, d];
    
    [self.infoList removeAllObjects];
    self.yewuInfoList = @[];
    [self.tableView reloadData];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    self.dateTime = [format dateFromString:text];
    [self reachabilityCheck];
 
    
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
