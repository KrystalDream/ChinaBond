//
//  CBVersionController.m
//  ChinaBond
//
//  Created by wangran on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBVersionController.h"
#import "CBUerCustomCell.h"
#import "CBAboutController.h"
#import "CBFeedbackController.h"
#import "CBHelpController.h"
#import "CBLoginController.h"

@interface CBVersionController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CBVersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.title = @"版本信息";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    self.tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorWithRGB(0xffffff, 0x1e1c1d);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBUerCustomCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"CBUerCustomCell"];
    if (!userCell) {
        userCell = [CBUerCustomCell userCustomCell];
    }
    
    if (indexPath.row == 0) {
        userCell.userCustomLab.text = @"帮助说明";
        userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_help", @"user_help_night");
        userCell.rightArrow.hidden = YES;
    }
    if (indexPath.row == 1) {
        userCell.userCustomLab.text = @"意见反馈";
        userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_write", @"user_write_night");
    }
    if (indexPath.row == 2) {
        userCell.userCustomLab.text = @"关于App";
        userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_about", @"user_about_night");
    }
    userCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x1e1e1e);
    userCell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    return userCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CBHelpController *help = [[CBHelpController alloc] init];
        [self.navigationController pushViewController:help animated:YES];
    }
    if (indexPath.row == 1) {
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSString *isLogStr = [userDic objectForKey:@"isLog"];
        
        if ([isLogStr isEqualToString:@"1"])
        {
            CBFeedbackController *feed = [[CBFeedbackController alloc] init];
            [self.navigationController pushViewController:feed animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            [alert show];
        }
    }
    if (indexPath.row == 2) {
        CBAboutController *about = [[CBAboutController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - button method

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
