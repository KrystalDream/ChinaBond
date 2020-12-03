//
//  RKValuationViewController.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKValuationViewController.h"
#import "RKValuationModel.h"
#import "RKValuationFooterView.h"
#import "RKDataManager.h"

@interface RKValuationViewController ()
{
    IBOutlet UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation RKValuationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
    UINib *cellNib = [UINib nibWithNibName:@"RKValuationCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"CellIdentifier"];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self request];
    self.title = @"中债估值";
    
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    _tableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    _tableView.dk_separatorColorPicker = DKColorWithRGB(0xffffff, 0x1e1c1d);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorWithRGB(0xffffff, 0x171616);

}
- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)request
{
    [self showHud];
    [[CBHttpRequest shareRequest] postWithUrl:kApiValuation
                                       Params:@{@"Page":@"1",@"pagecount":@"50"}
                              completionBlock:^(id responseObject) {
                                  CBLog(@"%@",responseObject);
                                  if ([[(NSDictionary *)responseObject objectForKey:@"state"] isEqualToString:@"0"]) {
                                      NSArray *retArr = [(NSDictionary *)responseObject objectForKey:@"lists"];
                                      if (retArr) {
                                          for (NSDictionary *dic in retArr) {
                                              RKValuationModel *model = [[RKValuationModel alloc] init];
                                              model.valuationId = [dic objectForKey:@"zqdm"];
                                              model.valuationName = [dic objectForKey:@"zqjc"];
                                              model.valuationTime = [NSString stringWithFormat:@"%@年",[dic objectForKey:@"dcq"]];
                                              model.valuationRate = [NSString stringWithFormat:@"%@%%",[dic objectForKey:@"gzsyl"]];
                                              model.valuationPrice = [NSString stringWithFormat:@"净价%@",[dic objectForKey:@"gzjz"]];
                                              [_dataArray addObject:model];
                                          }
                                      }
                                  }
                                  [self hideHud];
                                  [_tableView reloadData];
                              } failBlock:^(NSError *error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                  [alert  show];
                                  [self hideHud];
                              }];
}

#pragma mark - TableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *bgView = [cell viewWithTag:12701];
    [bgView.layer setMasksToBounds:YES];
    [[bgView layer] setCornerRadius:3.0];//圆角
    
    //wr add
    
    cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    bgView.dk_backgroundColorPicker = DKColorWithRGB(0xF5F5F5, 0x282727);
    
    ((UILabel *)[cell viewWithTag:12801]).dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
    ((UILabel *)[cell viewWithTag:12802]).dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0xd648484);
    ((UILabel *)[cell viewWithTag:12803]).dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x666666);
    ((UILabel *)[cell viewWithTag:12804]).dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x666666);
    
    //wr add end
    
    //给cell配置数据模版
    RKValuationModel *model = [_dataArray objectAtIndex:indexPath.row];
    [(UILabel *)[cell viewWithTag:12801] setText:model.valuationName];
    [(UILabel *)[cell viewWithTag:12802] setText:model.valuationRate];
    [(UILabel *)[cell viewWithTag:12803] setText:model.valuationTime];
    [(UILabel *)[cell viewWithTag:12804] setText:model.valuationPrice];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    RKValuationFooterView *footer = [[RKValuationFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    footer.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    return nil;
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
