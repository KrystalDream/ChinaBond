//
//  CBAddController.m
//  ChinaBond
//
//  Created by wangran on 15/12/17.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBAddController.h"
#import "CBAddCell.h"
#import "CBProductDetailController.h"

@interface CBAddController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation CBAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-61) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    //搜索
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53)];
    headerView.backgroundColor = UIColorFromRGB(0xf0eff4);
    self.tableView.tableHeaderView = headerView;
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, SCREEN_WIDTH-10-60, 35)];
    self.searchTF.placeholder = @"请输入代码、简称或名称";
    self.searchTF.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [headerView addSubview:self.searchTF];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 9, 50, 35)];
    searchButton.backgroundColor = UIColorFromRGB(0xf36c6c);
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchButton];
    
}

#pragma maek- button click method

- (void)searchbuttonClick
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                      Params:@{@"SID":@"01",
                                               @"zqdm":@"140017"}
                             completionBlock:^(id responseObject) {
                                 
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 
                                 NSString *state = responseObject[@"state"];
                                 if ([state isEqualToString:@"0"]) {
                                     
                                     self.dataList = responseObject[@"dataList"];
                                     [self.tableView reloadData];
                                     
                                 }
                                 else
                                 {
                                     [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                 }
                                 
                             } failBlock:^(NSError *error) {
                                 
                             }];
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - tableview datasource delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBAddCell *add = [tableView dequeueReusableCellWithIdentifier:@"CBAddCell"];
    if (!add) {
        add = [CBAddCell addCell];
    }
    
    add.resultName.text = [NSString stringWithFormat:@"%@  %@",self.dataList[indexPath.row][@"zqjc"],self.dataList[indexPath.row][@"zqdm"]];
    add.resultAdd.tag = indexPath.row;
    [add.resultAdd addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return add;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                      Params:@{@"SID":@"01",
                                               @"zqdm":self.dataList[indexPath.row][@"zqdm"]}
                             completionBlock:^(id responseObject) {
                                 
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 
                                 NSString *state = responseObject[@"state"];
                                 if ([state isEqualToString:@"0"]) {
                                     CBProductDetailController *productDetail = [[CBProductDetailController alloc] init];
                                     productDetail.infoDic = responseObject[@"dataList"][0];
                                     productDetail.isAdd = YES;
                                     [self.navigationController pushViewController:productDetail animated:YES];
                                 }
                                 else
                                 {
                                     [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                 }
                                 
                             } failBlock:^(NSError *error) {
                                 
                             }];
}

- (void)addButtonClick:(UIButton *)sender
{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    [[CBHttpRequest shareRequest] postWithUrl:CBBaseUrl
                                       Params:@{@"SID":@"09",
                                                @"userName":infoDic[@"userName"],
                                                @"zqdm":self.dataList[sender.tag][@"zqdm"],
                                                @"zqjc":self.dataList[sender.tag][@"zqjc"],
                                                @"rate":@"AAA"}//self.infoDic[@"zqpj"]
                              completionBlock:^(id responseObject) {
                                  
                                  [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                  
                              } failBlock:^(NSError *error) {
                                  
                              }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
