//
//  RKStatisticsViewController.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKStatisticsViewController.h"
#import "CBHttpRequest.h"
#import "RKStatisticsModel.h"
#import "RKDataManager.h"

@interface RKStatisticsViewController ()
{
    IBOutlet UITableView *_tableView;
    NSMutableArray *_dataArray2;
    NSMutableDictionary *_dataArray1;
}
@end

@implementation RKStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"统计数据";
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self request];
    
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    _tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    _tableView.dk_separatorColorPicker = DKColorWithRGB(0xffffff, 0x1e1c1d);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x171616);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)request
{
    [self showHud];
    _dataArray1 = [[NSMutableDictionary alloc] initWithCapacity:0];
    _dataArray2 = [[NSMutableArray alloc] initWithCapacity:0];
    [[CBHttpRequest shareRequest] postWithUrl:kApiStatistics
                                       Params:@{@"SID":@"04"}
                              completionBlock:^(id responseObject) {
                                 // NSLog(@"%@",responseObject);
                                  if ([[(NSDictionary *)responseObject objectForKey:@"state"] isEqualToString:@"0"]) {
                                      NSMutableArray *datas1 = [NSMutableArray arrayWithCapacity:0];
                                      NSArray *retArr = [(NSDictionary *)responseObject objectForKey:@"tjglList"];
                                      if (retArr) {
                                          for (NSDictionary *dic in retArr) {
                                              RKStatisticsModel *model = [[RKStatisticsModel alloc] init];
                                              model.sName = [dic objectForKey:@"xmmc"];
                                              model.SNumber = [dic objectForKey:@"sl"];
                                              model.sDate = [dic objectForKey:@"tjny"];
                                              [datas1 addObject:model];
                                          }
                                      }
                                      NSArray *retArr2 = [(NSDictionary*)responseObject objectForKey:@"tjsjList"];
                                      if (retArr2) {
                                          for (NSDictionary *dic in retArr2) {
                                              RKStatisticsModel *model = [[RKStatisticsModel alloc] init];
                                              model.sName = [dic objectForKey:@"xmmc"];
                                              model.SNumber = [dic objectForKey:@"sl"];
                                              model.sDate = [dic objectForKey:@"tjny"];
                                              [_dataArray2 addObject:model];
                                          }
                                      }
                                      [self deal:datas1];
                                  }
                                  else
                                  {
                                      [self hideHud];
                                  }
                              } failBlock:^(NSError *error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                  [alert  show];
                                  [self hideHud];
                              }];
}

- (void)deal:(NSArray *)datas1
{
    for (RKStatisticsModel *model in datas1) {
        if ([model.sName isEqualToString:@"银行间机构开户数"]) {
            [_dataArray1 setObject:model forKey:@"line2"];
        }
        if ([model.sName isEqualToString:@"债券托管量"]) {
            [_dataArray1 setObject:model forKey:@"line1"];
        }
    }
    [_tableView reloadData];
    [self hideHud];
}

#pragma mark - TableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?2:[_dataArray2 count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.00001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x737373);
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-10, 12, 100, 13)];
        countLabel.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
        countLabel.font = [UIFont systemFontOfSize:15];
        countLabel.tag = 12901;
        countLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:countLabel];
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-10, 29, 100, 12)];
        infoLabel.dk_textColorPicker = DKColorWithRGB(0x868686, 0x595959);
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.font = [UIFont systemFontOfSize:11];
        infoLabel.tag = 12902;
        [cell addSubview:infoLabel];
        
        
        cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    }else{
        //重置cell状态
    }
    
    if (indexPath.section==0) {
        NSString *index = [NSString stringWithFormat:@"line%d",(int)indexPath.row+1];
        //给cell配置数据模版
        RKStatisticsModel *model = [_dataArray1 objectForKey:index];
        //配置标题
        cell.textLabel.text = model.sName;
        //配置数值
        ((UILabel *)[cell viewWithTag:12901]).text = model.SNumber;
        //配置单位
        ((UILabel *)[cell viewWithTag:12902]).text = indexPath.row==0?@"亿元":@"家";
        cell.imageView.image = [UIImage imageNamed:indexPath.row==0?@"tongji30":@"tongji29"];
    }else{
        //给cell配置数据模版
        RKStatisticsModel *model = [_dataArray2 objectAtIndex:indexPath.row];
        //配置标题
        cell.textLabel.text = model.sName;
        //配置数值
        ((UILabel *)[cell viewWithTag:12901]).text = model.SNumber;
        //配置单位
        ((UILabel *)[cell viewWithTag:12902]).text = @"亿元";
        cell.imageView.image = [UIImage imageNamed:@"tongji30"];
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    header.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 8, SCREEN_WIDTH, 16)];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*30];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"M月"];
    
    NSString *dateStr = [format stringFromDate:date];
    
    if (section == 0) {
        titleLabel.text = [NSString stringWithFormat:@"%@末",dateStr];
    }
    else if (section == 1)
    {
        titleLabel.text = [NSString stringWithFormat:@"1月~%@",dateStr];
    }
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.dk_textColorPicker = DKColorWithRGB(0xd6d6d, 0x404040);
    [header addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 0.5)];
    line.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x262626);
    [header addSubview:line];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footer.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
