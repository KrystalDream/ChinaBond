//
//  CBFocusMoreController.m
//  ChinaBond
//
//  Created by wangran on 16/1/5.
//  Copyright © 2016年 chinaBond. All rights reserved.
//

#import "CBFocusMoreController.h"
#import "CBFocusCell.h"
//#import "CBFocusDetailController.h"
#import "CSWebView.h"

@interface CBFocusMoreController ()<UITableViewDataSource,UITableViewDelegate>

{
    int _page;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *infoList;
@property (nonatomic, strong) NSMutableArray *readArr;
@end

@implementation CBFocusMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"重点关注";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerRefresh];
    }];
    
    _page = 0;
    
    [self requestData];
}

- (void)footerRefresh
{
    [self requestData];
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                      Params:@{@"SID":@"10",
                                               @"cId":@"14175918",
                                               @"pageSize":@"10",
                                               @"pageNum":@(_page)}
                             completionBlock:^(id responseObject) {
                                 
                                 // 拿到当前的上拉刷新控件，结束刷新状态
                                 [self.tableView.mj_footer endRefreshing];
                                 
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 
                                 NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
                                 if ([state isEqualToString:@"0"]) {
                                     [self.infoList addObjectsFromArray:responseObject[@"infoList"]];
                                     
                                     if (((NSArray *)responseObject[@"infoList"]).count==10) {
                                         _page++;
                                     }
                                     
                                     [self.tableView reloadData];
                                 }
                                 else
                                 {
                                     [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                 }
                                 
                             } failBlock:^(NSError *error) {
                                 [MBProgressHUD bwm_showTitle:error.description toView:self.view hideAfter:2];
                             }];
}

-(NSMutableArray *)infoList
{
    if (!_infoList) {
        _infoList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _infoList;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBFocusCell *focus = [tableView dequeueReusableCellWithIdentifier:@"CBFocusCell"];
    if (!focus) {
        focus = [CBFocusCell focusCell];
    }
    for (NSString *tid in self.readArr) {
        if (tid == self.infoList[indexPath.row][@"tId"]) {
            focus.titleLab.dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x404040);
            focus.timeLab.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x404040);
            focus.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x1e1e1e);
        }
        else
        {
            focus.titleLab.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
            focus.timeLab.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x404040);
            focus.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x1e1e1e);
        }
    }
    
    
    focus.titleLab.text = self.infoList[indexPath.row][@"title"];
    focus.timeLab.text = self.infoList[indexPath.row][@"vTime"];
    [focus.foucsImage sd_setImageWithURL:[NSURL URLWithString:self.infoList[indexPath.row][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    
    focus.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    
    return focus;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSWebView *focusDetail = [[CSWebView alloc] init];
    focusDetail.hidesBottomBarWhenPushed = YES;
    focusDetail.infoDic = self.infoList[indexPath.row];
    focusDetail.infoUrl = self.infoList[indexPath.row][@"infoUrl"];
    focusDetail.tId = self.infoList[indexPath.row][@"tId"];
    [self.navigationController pushViewController:focusDetail animated:YES];
    
    [self.readArr addObject:self.infoList[indexPath.row][@"tId"]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - button method

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
