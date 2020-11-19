//
//  CBLoginController.m
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBLoginController.h"
#import "NSString+CBMD5.h"

@interface CBLoginController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *userName;
@property (strong, nonatomic) UITextField *secret;
@end

@implementation CBLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"登录";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 25+64, SCREEN_WIDTH, 100)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.dk_backgroundColorPicker = DKColorWithRGB(0xe53d3d, 0x963231);
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorWithRGB(0xdcdcdc, 0x1e1c1d);

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        
        static NSString *cellIndentifier = @"nameCell";
        
        UITableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!nameCell) {
            nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(21, 15, 20, 20)];
            imageView1.image = [UIImage imageNamed:@"log_name"];
            [nameCell.contentView addSubview:imageView1];
            
            self.userName = [[UITextField alloc] initWithFrame:CGRectMake(58, 15, SCREEN_WIDTH-58, 20)];
            self.userName.dk_textColorPicker = DKColorWithRGB(0x0f0f0f, 0x333333);
            self.userName.placeholder = @"用户名/手机号/电子邮箱";
            [nameCell.contentView addSubview:self.userName];
        }
        
        nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell = nameCell;
        
    }
    
    if (indexPath.row == 1) {
        
        static NSString *cellIndentifier = @"secretCell";
        
        UITableViewCell *secretCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!secretCell) {
            secretCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(21, 15, 20, 20)];
            imageView1.image = [UIImage imageNamed:@"log_secret"];
            [secretCell.contentView addSubview:imageView1];
            
            self.secret = [[UITextField alloc] initWithFrame:CGRectMake(58, 15, SCREEN_WIDTH-58-60, 20)];
            self.secret.dk_textColorPicker = DKColorWithRGB(0x0f0f0f, 0x333333);
            self.secret.placeholder = @"密码";
            self.secret.secureTextEntry = YES;
            [secretCell.contentView addSubview:self.secret];
            
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 10, 35, 19)];
            [switchButton addTarget:self action:@selector(secretOffButtonClick:) forControlEvents:UIControlEventValueChanged];
            [secretCell.contentView addSubview:switchButton];
        }
        
        secretCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell = secretCell;
        
    }
   
    cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)secretOffButtonClick:(UISwitch *)sender
{
    self.secret.secureTextEntry = sender.on;
}

- (IBAction)login:(id)sender
{
 
    if (self.userName.text.length == 0 || self.secret.text.length == 0 ) {
        [MBProgressHUD bwm_showTitle:@"请输入用户名或密码" toView:self.view hideAfter:2];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                          Params:@{@"SID":@"06",
                                                   @"userName":self.userName.text,
//                                                   @"userPwd":[self.secret.text CBMD5Hash8]
                                                   @"userPwd":self.secret.text
                                                   
                                          }
                                 completionBlock:^(id responseObject) {
                                     
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     
                                     NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
                                     if ([state isEqualToString:@"0"]) {
                                         
                                         NSDictionary *userDic = @{
                                                                   @"userName":responseObject[@"userName"],
                                                                   @"isLog":@"1"
                                                                   };
                                         //4006701855
                                         [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:@"userInfo"];
                                         [[NSUserDefaults standardUserDefaults]synchronize];
                                         
                                         [self.navigationController popViewControllerAnimated:YES];
                                         
                                     }
                                     else
                                     {
                                         [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                     }
                                     
                                     
                                 } failBlock:^(NSError *error) {
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     [MBProgressHUD bwm_showTitle:error.description toView:self.view hideAfter:2];
                                 }];
    }
}
- (IBAction)forgetSecret:(id)sender
{
    
    [CBNetworkManager getRequstWithURL:@"http://app.gongkong.com/api/newsapi/GetAppNewsMain"
                                params:nil
                          successBlock:^(NSDictionary *responseObject) {

                              CBLog(@"%@",responseObject);
                          } failureBlock:^(NSError *error) {
                              
                          } showHUD:NO];
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
