//
//  CBUserManageController.m
//  ChinaBond
//
//  Created by wangran on 15/11/30.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBUserManageController.h"
#import "CBUserHeadCell.h"
#import "CBUserCustomSCell.h"
#import "CBUerCustomCell.h"
#import "CBFontSetView.h"
#import "CBVersionController.h"
#import "CBMyCollectController.h"
#import "CBLoginController.h"
#import "CBSearchController.h"
#import "APService.h"
#import "CBDataBase.h"

@interface CBUserManageController ()<UITableViewDataSource,UITableViewDelegate,CBFontViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLog;
@property (nonatomic, strong) CBFontSetView *fontView;

@end

@implementation CBUserManageController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.navigationItem.title = @"中国债券信息网";
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.fontView = [[CBFontSetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.fontView.hidden = YES;
    self.fontView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.fontView];
    
    self.tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorWithRGB(0xffffff, 0x1e1c1d);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    //self.navigationController.navigationBar.dk_tintColorPicker = DKColorWithRGB(0xe53d3d, 0xffffff);
    self.tabBarController.tabBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"User"];
    
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    NSString *isLogStr = [userDic objectForKey:@"isLog"];
    
    if ([isLogStr isEqualToString:@"1"]) {
        self.isLog = YES;
    }
    else
    {
        self.isLog = NO;
    }
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"User"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 3;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return 2;
    }
    if (section == 5) {
        return 1;
    }
    if (section == 6) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }
    else if (indexPath.section == 1 || indexPath.section == 6)
    {
        if (self.isLog) {
            return 50;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else if (section == 1 || section == 6)
    {
        if (self.isLog) {
            return 10;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        CBUserHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"CBUserHeadCell"];
        if (!headCell) {
            headCell = [CBUserHeadCell userHeadCell];
        }
        
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        
        NSString *userNameStr = [userDic objectForKey:@"userName"];
        
        headCell.userName.text = self.isLog ? userNameStr : @"请登录";
        headCell.userAvatar.image = self.isLog ? [UIImage imageNamed:@"yidenglu"] : [UIImage imageNamed:@"avatar_default"];
        headCell.backImage.dk_imagePicker = DKImageWithNames(@"backImage", @"backImage_night");
        cell = headCell;
    }
    if (indexPath.section == 1) {
        CBUerCustomCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"CBUerCustomCell"];
        if (!userCell) {
            userCell = [CBUerCustomCell userCustomCell];
        }
        userCell.clipsToBounds = YES;
        userCell.userCustomLab.text = @"我的收藏";
        userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_collect", @"user_collect_night");
        userCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x1e1c1d);
        cell = userCell;
    }
    
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            CBUerCustomCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"CBUerCustomCell"];
            if (!userCell) {
                userCell = [CBUerCustomCell userCustomCell];
            }
            userCell.userCustomLab.text = @"字体设置";
            userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_font", @"user_font_night");
            userCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x1e1c1d);
            cell = userCell;
        }
        
        if (indexPath.row == 1) {
            CBUserCustomSCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"CBUserCustomSCell"];
            if (!userCell) {
                userCell = [CBUserCustomSCell userCustomCell];
            }
            userCell.userCustomLab.text = @"自动离线下载";
            userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_downLoad", @"user_downLoad_night");
            userCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x1e1c1d);
            
            BOOL downLoad = [[NSUserDefaults standardUserDefaults] boolForKey:KDownLoad];
            userCell.userCustomSwitch.on = downLoad;

            [userCell.userCustomSwitch addTarget:self action:@selector(downLoadChange:) forControlEvents:UIControlEventValueChanged];
            
            userCell.userCustomSwitch.on = downLoad;
            
            cell = userCell;
        }
        if (indexPath.row == 2) {
            CBUserCustomSCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"CBUserCustomSCell"];
            if (!userCell) {
                userCell = [CBUserCustomSCell userCustomCell];
            }
            userCell.userCustomLab.text = @"夜间模式";
            userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_nightModel", @"user_nightModel_night");
            
            BOOL nightModel = [[NSUserDefaults standardUserDefaults] boolForKey:KNightModel];
            if (nightModel) {
                userCell.userCustomSwitch.on = YES;
            }
            else
            {
                userCell.userCustomSwitch.on = NO;
            }
            
            [userCell.userCustomSwitch addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventValueChanged];
            userCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x1e1c1d);
            cell = userCell;
        }
    }
    
    if (indexPath.section == 3) {
        CBUserCustomSCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"CBUserCustomSCell"];
        if (!userCell) {
            userCell = [CBUserCustomSCell userCustomCell];
        }
        userCell.userCustomLab.text = @"推送通知";
        userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_notification", @"user_notification_night");
        

        BOOL isNoti = [[NSUserDefaults standardUserDefaults] boolForKey:KNotification];
        
        if (isNoti) {
            userCell.userCustomSwitch.on = YES;
        }
        else
        {
            userCell.userCustomSwitch.on = NO;
        }
        
        [userCell.userCustomSwitch addTarget:self action:@selector(changeNotification:) forControlEvents:UIControlEventValueChanged];
        userCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x1e1c1d);
        cell = userCell;
    }
    
    
    if (indexPath.section == 4) {
        
        CBUerCustomCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"CBUerCustomCell"];
        if (!userCell) {
            userCell = [CBUerCustomCell userCustomCell];
        }
        
        if (indexPath.row == 0) {
            userCell.userCustomLab.text = @"版本信息";
            userCell.rightLab.hidden = YES;
            userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_version", @"user_version_night");
        }
        if (indexPath.row == 1) {
            userCell.userCustomLab.text = @"去好评";
            userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_goJugde", @"user_goJugde_night");
            userCell.rightArrow.hidden = YES;
            userCell.rightLab.hidden = YES;
        }
        userCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x1e1c1d);
        cell = userCell;
    }
    
    if (indexPath.section == 5) {
        
        CBUerCustomCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"CBUerCustomCell"];
        if (!userCell) {
            userCell = [CBUerCustomCell userCustomCell];
        }
        userCell.userCustomLab.text = @"清理缓存";
        userCell.userCustomImage.dk_imagePicker = DKImageWithNames(@"user_clear", @"user_clear_night");
        userCell.rightArrow.hidden = YES;
        userCell.rightLab.hidden = NO;
        
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        float Cache = [self folderSizeAtPath:cachPath];
        
        NSString *cacheStr = [NSString stringWithFormat:@"%.2f",Cache];
        
        if ([cacheStr isEqualToString:@"0.00"]) {
            userCell.rightLab.text = [NSString stringWithFormat:@"0M"];
        }
        else
        {
            userCell.rightLab.text = [NSString stringWithFormat:@"%.2fM",Cache];
        }
        
        userCell.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x1e1c1d);
        cell = userCell;
    }
    
    if (indexPath.section == 6) {
        
        static NSString *cellIndentifier = @"logOutCell";
        
        UITableViewCell *logOutCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!logOutCell) {
            logOutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            logOutCell.clipsToBounds = YES;
            
            UIButton *logOut = [UIButton buttonWithType:UIButtonTypeCustom];
            logOut.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
            logOut.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
            [logOut setTitle:@"退出登录" forState:UIControlStateNormal];
            [logOut setTitleColor:UIColorFromRGB(0xff4e4e) forState:UIControlStateNormal];
            [logOut addTarget:self action:@selector(logOutMethod) forControlEvents:UIControlEventTouchUpInside];
            
            [logOutCell.contentView  addSubview:logOut];
        }
        
        cell = logOutCell;
    }
    cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (!self.isLog) {
         //登陆
            CBLoginController *login = [[CBLoginController alloc] init];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
            
        }
    }
    if (indexPath.section == 1) {
        //我的收藏
        CBMyCollectController *myCollect = [[CBMyCollectController alloc] init];
        myCollect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCollect animated:YES];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //字体设置
            self.fontView.hidden = NO;
        }
    }
    
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            //版本信息
            CBVersionController *version = [[CBVersionController alloc] init];
            version.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:version animated:YES];
        }
        if (indexPath.row == 1) {
            
            //去好评
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=956379885&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
            
        }
    }
    
    if (indexPath.section == 5) {
        //清除缓存
        [self clearCache];
        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"homeJsonResponse"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"homeGuzhi"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -delegate

-(void)hideFontView
{
    self.fontView.hidden = YES;
}

#pragma mark - button click method
- (void)rightButtonClick
{
    CBSearchController *search = [[CBSearchController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)logOutMethod
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出登录吗？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[CBDataBase sharedDatabase] deleteAllNote];
        
        self.isLog = !self.isLog;
        [self.tableView reloadData];
    }
}

- (void)downLoadChange:(UISwitch *)sender
{
    BOOL onff = sender.on;
    
    [[NSUserDefaults standardUserDefaults] setBool:onff forKey:KDownLoad];
}

- (void)changeModel:(UISwitch *)sender
{
    BOOL onOff = sender.on;
    [[NSUserDefaults standardUserDefaults] setBool:onOff forKey:KNightModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (onOff) {
        [DKNightVersionManager nightFalling];
    }
    else
    {
        [DKNightVersionManager dawnComing];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nightModelChange" object:nil];
}

- (void)changeNotification:(UISwitch *)sender
{
    BOOL onOff = sender.on;
    if (!onOff) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    }
    else
    {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:onOff forKey:KNotification];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/**
 *  清除缓存方法
 */
- (void)clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       CBLog(@"files :%ld",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       NSArray *dataArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"downloadFile"];
                       
                       //NSLog(@"%@",dataArr);
                       for (NSString *path in dataArr) {
                           //   NSURL *fileU = [NSURL URLWithString:fileurl];
                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                               
                               
                               NSFileManager *manager = [NSFileManager defaultManager];
                               
                               if(![manager contentsOfDirectoryAtPath:path error:nil]){
                                   [manager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
                               }
                               
                               [manager removeItemAtPath:path error:nil];
                           });
                       }
                       
                       
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
}

-(void)clearCacheSuccess
{
    [self.tableView reloadData];
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

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
