//
//  CBProductDetailController.m
//  ChinaBond
//
//  Created by wangran on 15/12/21.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBProductDetailController.h"
#import "CBProductDetailCell.h"
#import "CBSellNewsDetailCell.h"
#import "CBLoginController.h"

@interface CBProductDetailController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation CBProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"产品详情";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40-25) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(20, SCREEN_HEIGHT-40-25, SCREEN_WIDTH-40, 40);
    self.button.layer.cornerRadius = 5;
    self.button.backgroundColor = UIColorFromRGB(0xff4e4e);
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.tableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkCode];
}

- (void)checkCode
{
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    if (userDic) {
     
        [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                        Params:@{@"SID":@"18",
                                                 @"userName":[userDic objectForKey:@"userName"],
                                                 @"sZqdm":self.zqdm}
                                        completionBlock:^(id responseObject) {
                                            
                                            if (![responseObject[@"infoCount"] isEqualToString:@"0"]) {
                                                self.isAdd = NO;
                                            }
                                            else
                                            {
                                                self.isAdd = YES;
                                            }
                                            
                                            [self.button setTitle:self.isAdd ? @"收藏":@"删除" forState:UIControlStateNormal];
                                            
                                        } failBlock:^(NSError *error) {
                                            CBLog(@"%@",error);
                                        }];
                                        
    }
    else
    {
        self.isAdd = YES;
        [self.button setTitle:@"收藏" forState:UIControlStateNormal];
    }
}

#pragma mark - tableView datasource delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 118;
    }
    return 42;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        
        CBProductDetailCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"CBProductDetailCell"];
        if (!titleCell) {
            titleCell = [CBProductDetailCell productDetailCell];
        }
        titleCell.contentView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        titleCell.productName.textAlignment = NSTextAlignmentCenter;
        titleCell.productName.text = self.infoDic[@"zqmc"];
        cell = titleCell;
    }
    else
    {
        CBSellNewsDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"CBSellNewsDetailCell"];
        if (!detailCell) {
            detailCell = [CBSellNewsDetailCell sellNewsDetailCell];
        }
        detailCell.contentView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        switch (indexPath.row) {
            case 1:
            {
                detailCell.detailName.text = @"债券简称";
                detailCell.detailContent.text = self.infoDic[@"zqjc"];
                detailCell.backgroudView.dk_backgroundColorPicker = DKColorWithRGB(0xf3f4f8, 0x191919);
            }
                break;
            case 2:
            {
                detailCell.detailName.text = @"债券期限";
                detailCell.detailContent.text = self.infoDic[@"zqqx"];
                detailCell.backgroudView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
            }
                break;
            case 3:
            {
                detailCell.detailName.text = @"发行日期";
                detailCell.detailContent.text = self.infoDic[@"ksr"];
                detailCell.backgroudView.dk_backgroundColorPicker = DKColorWithRGB(0xf3f4f8, 0x191919);
            }
                break;
            case 4:
            {
                detailCell.detailName.text = @"债券评级";
                detailCell.detailContent.text = self.infoDic[@"zqpj"];
                detailCell.backgroudView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
            }
                break;
            case 5:
            {
                detailCell.detailName.text = @"发行人简称";
                detailCell.detailContent.text = self.infoDic[@"fxjc"];
               detailCell.backgroudView.dk_backgroundColorPicker = DKColorWithRGB(0xf3f4f8, 0x191919);
            }
                break;
            case 6:
            {
                detailCell.detailName.text = @"主体评级";
                detailCell.detailContent.text = self.infoDic[@"ztpj"];
                detailCell.backgroudView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
            }
                break;
            case 7:
            {
                detailCell.detailName.text = @"票面利率";
                detailCell.detailContent.text = self.infoDic[@"pmll"];
                detailCell.backgroudView.dk_backgroundColorPicker = DKColorWithRGB(0xf3f4f8, 0x191919);
            }
                break;
        }
        
        
        cell = detailCell;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button method

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonClick
{
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    if (self.isAdd) {
        
        //添加
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        
        if (userDic) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                              Params:@{@"SID":@"09",
                                                       @"userName":[userDic objectForKey:@"userName"],
                                                       @"zqdm":self.infoDic[@"zqdm"],
                                                       @"zqjc":[self.infoDic[@"zqjc"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                       @"rate":self.infoDic[@"zqpj"]}
                                     completionBlock:^(id responseObject) {
                                         
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                         NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
                                         if ([state isEqualToString:@"0"]) {
                                             self.isAdd = NO;
                                             [self.button setTitle:@"删除" forState:UIControlStateNormal];
                                         }
                                         
                                     } failBlock:^(NSError *error) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     }];
 
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            [alert show];
        }
    }
    else
    {
        //删除
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[CBHttpRequest shareRequest] postWithUrl:CBBaseUrl
                                           Params:@{@"SID":@"12",
                                                    @"userName":[userDic objectForKey:@"userName"],
                                                    @"zqdm":self.infoDic[@"zqdm"],
                                                    }
                                  completionBlock:^(id responseObject) {
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      CBLog(@"%@",responseObject);
                                      
                                      [self.navigationController popViewControllerAnimated:YES];
                                      
                                  } failBlock:^(NSError *error) {
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  }];
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

@end
