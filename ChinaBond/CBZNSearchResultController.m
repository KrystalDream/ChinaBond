//
//  CBZNSearchResultController.m
//  ChinaBond
//
//  Created by wangran on 15/12/4.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBZNSearchResultController.h"
#import "CBZNSearchResultCell.h"
//#import "CBFocusDetailController.h"
#import "CSWebView.h"

@interface CBZNSearchResultController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *readArr;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation CBZNSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"站内搜索结果";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-90)/2, 220, 90, 85)];
    imageView.dk_imagePicker = DKImageWithNames(@"noResult", @"noResult_night");
    [self.view addSubview:imageView];
    
    UILabel *resultName = [[UILabel alloc] initWithFrame:CGRectMake(10, 325, SCREEN_WIDTH-20, 15)];
    resultName.dk_textColorPicker = DKColorWithRGB(0x868686, 0x666666);
    resultName.text = @"未搜到相关资讯";
    resultName.textAlignment = NSTextAlignmentCenter;
    resultName.font = Font(15);
    [self.view addSubview:resultName];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.tableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    
    _page = 1;
    [self httpRequest];
}

- (void)footRefresh
{
    [self httpRequest];
}

- (void)httpRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CBHttpRequest shareRequest] getWithUrl:@"https://www.chinabond.com.cn/SearchMobil"
                                      Params:@{@"qt":[self.searchWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                               @"c1":self.channelID,
                                               @"page":@(_page)}
                             completionBlock:^(id responseObject) {
                                 
                                 [self.tableView.mj_footer endRefreshing];
                                 
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 
                                 NSString *state = [responseObject objectForKey:@"state"];
                                 if ([state isEqualToString:@"0"]) {
                                     self.tableView.hidden = NO;
                                     
                                     [self.dataList addObjectsFromArray:responseObject[@"dataList"]];
                                     if (((NSArray *)responseObject[@"dataList"]).count == 10) {
                                         _page++;
                                     }
                                     [self.tableView reloadData];
                                 }
                                 else
                                 {
                                     
                                     self.tableView.hidden = YES;
                                     //[MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                 }
                                 
                             } failBlock:^(NSError *error) {
                                 NSLog(@"%@",error);
                             }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBZNSearchResultCell *resultCell = [tableView dequeueReusableCellWithIdentifier:@"CBZNSearchResultCell"];
    if (!resultCell) {
        resultCell = [CBZNSearchResultCell searchResultCell];
    }
    
    if (self.readArr.count>0) {
        for (NSString *tid in self.readArr) {
            if (tid == self.dataList[indexPath.row][@"tId"]) {
                resultCell.resultTitle.dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x404040);
                
            }
            else
            {
                resultCell.resultTitle.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
            }
        }
    }
    else
    {
        resultCell.resultTitle.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
    }
    
    resultCell.resultTime.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x404040);
    
    resultCell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    resultCell.resultTitle.text = self.dataList[indexPath.row][@"title"];
    resultCell.resultTime.text = self.dataList[indexPath.row][@"docDate"];
    resultCell.resultSource.text = [NSString stringWithFormat:@"【%@】",self.dataList[indexPath.row][@"idpath"]];
    
    return resultCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CBFocusDetailController *focusDetail = [[CBFocusDetailController alloc] init];
    CSWebView *focusDetail = [[CSWebView alloc] init];
    focusDetail.hidesBottomBarWhenPushed = YES;
    focusDetail.infoDic = self.dataList[indexPath.row];
    focusDetail.infoUrl = self.dataList[indexPath.row][@"urlstr"];
    focusDetail.tId = self.dataList[indexPath.row][@"infoId"];
    [self.navigationController pushViewController:focusDetail animated:YES];
    
    [self.readArr addObject:self.dataList[indexPath.row][@"infoId"]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)readArr
{
    if (!_readArr) {
        _readArr = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _readArr;
}

-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _dataList;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
