//
//  RKYieldRateViewController.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKYieldRateViewController.h"
#import "RKRateDetailController.h"
#import "RKRateInfoModel.h"
#import "CBHttpRequest.h"
#import "RKDataManager.h"

#define RKTableViewLeft 12601
#define RKTableViewRight 12602

@interface RKYieldRateViewController ()
{
    UIView *_tableViewHeader;
    IBOutlet UITableView *_leftTableView;
    IBOutlet UITableView *_rightTableView;
    
//    NSArray *_leftDataArray;
//    NSArray *_rightDataArray;
    
//    NSInteger _leftSelectedIndex;
    BOOL _fuckEver;
//    NSIndexPath *_leftSelectIndexPath;
}
@property (nonatomic, strong) NSArray *leftDataArray;
@property (nonatomic, strong) NSArray *rightDataArray;

@property (nonatomic, assign) NSInteger leftSelectedIndex;

@property (nonatomic, strong) NSIndexPath *leftSelectIndexPath;



@end

@implementation RKYieldRateViewController
@synthesize delegate, pageType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.translucent = NO;
    
    _leftSelectedIndex = -1;
    _fuckEver = NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
    if ([[UIDevice currentDevice].systemVersion integerValue] > 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (RKYieldRatePageTypeChoice == self.pageType) {
        self.title = @"选择曲线";
    }else{
        self.title = @"中债收益率";
    }
    _tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    _tableViewHeader.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    UIView *icon = [[UIView alloc] initWithFrame:CGRectMake(0, 12, 4, 20)];
    icon.backgroundColor = [UIColor colorWithRed:251/255.0 green:70/255.0 blue:77/255.0 alpha:1.0];
    UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 160, 20)];
    iconLabel.backgroundColor = [UIColor clearColor];
    iconLabel.font = [UIFont systemFontOfSize:15];
    iconLabel.dk_textColorPicker = DKColorWithRGB(0x6e6e6e, 0x8c8c8c);
    iconLabel.text = @"中债收益率";
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, .5)];
    line.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
    
    [_tableViewHeader addSubview:line];
    [_tableViewHeader addSubview:icon];
    [_tableViewHeader addSubview:iconLabel];
    [self.view addSubview:_tableViewHeader];
    
    
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    _leftTableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    _rightTableView.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x262626);
    [self requestForRateInfo];
}
- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_fuckEver) {
        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        _fuckEver = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestForRateInfo
{
    [self showHud];
    
    MJWeakSelf
    [[CBHttpRequest shareRequest] postWithUrl:kApiRateInfo
                                       Params:@{}
                              completionBlock:^(id responseObject) {
                                  if ([[(NSDictionary *)responseObject objectForKey:@"state"] isEqualToString:@"0"]) {
                                      NSMutableArray *datas1 = [NSMutableArray arrayWithCapacity:0];
                                      NSArray *retArr = [(NSDictionary *)responseObject objectForKey:@"lists"];
                                      if (retArr) {
                                          for (NSDictionary *dic in retArr) {
                                              RKRateInfoModel *pInfo = [[RKRateInfoModel alloc] init];
                                              pInfo.rateID = [dic objectForKey:@"id"];
                                              pInfo.rateTitle = [dic objectForKey:@"name"];
                                              pInfo.ratePID = [dic objectForKey:@"pid"];
                                              NSMutableArray *childrenInfo = [NSMutableArray arrayWithCapacity:0];
                                              NSArray *childs = [dic objectForKey:@"childs"];
                                              for (NSDictionary *childsDic in childs) {
                                                  RKRateInfoModel *info = [[RKRateInfoModel alloc] init];
                                                  info.rateID = [childsDic objectForKey:@"id"];
                                                  info.rateTitle = [childsDic objectForKey:@"name"];
                                                  info.ratePID = [childsDic objectForKey:@"pid"];
                                                  [childrenInfo addObject:info];
                                              }
                                              pInfo.subInfos = childrenInfo;
                                              [datas1 addObject:pInfo];
                                          }
                                      }
                                      weakSelf.leftDataArray = datas1;
                                      if ([weakSelf.leftDataArray count]>0) {
                                          weakSelf.rightDataArray = ((RKRateInfoModel *)[weakSelf.leftDataArray objectAtIndex:0]).subInfos;
                                      }
                                      weakSelf.leftSelectedIndex = 0;
                                      [_leftTableView reloadData];
                                      [_rightTableView reloadData];
                                  }
                                  [self hideHud];
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
    NSInteger number = (tableView.tag == RKTableViewLeft)?[_leftDataArray count]:[_rightDataArray count];
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == RKTableViewLeft) {
        return 44;
    }
    NSString *text = ((RKRateInfoModel *)[_rightDataArray objectAtIndex:indexPath.row]).rateTitle;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2-18, MAXFLOAT)
                                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    CGFloat textHeight = size.height+8+8;//计算文字右边对应行的文字高度
    return textHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    NSArray *colorArray = @[[UIColor colorWithRed:237/255.0 green:114/255.0 blue:42/255.0 alpha:1.0],
                            [UIColor colorWithRed:69/255.0 green:159/255.0 blue:223/255.0 alpha:1.0],
                            [UIColor colorWithRed:140/255.0 green:208/255.0 blue:30/255.0 alpha:1.0],
                            [UIColor colorWithRed:244/255.0 green:80/255.0 blue:136/255.0 alpha:1.0]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.dk_backgroundColorPicker = DKColorWithRGB(0xf2f2f2, 0x262626);
        if (tableView.tag == RKTableViewLeft) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 4, 14)];
            view.tag = 12605;
            [cell.contentView addSubview:view];
            UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 4, 14)];
            view2.tag = 12606;
            [cell.selectedBackgroundView addSubview:view2];
            
            cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        }else{
            cell.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x262626);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 0, 0)];
            label.tag = 12607;
            label.dk_textColorPicker = DKColorWithRGB(0x323232, 0x737373);
            label.numberOfLines = MAXFLOAT;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell addSubview:label];
        }
    }else{
        //重置cell状态
    }
    
    //给cell配置数据模版
    if (tableView.tag == RKTableViewLeft) {
        cell.textLabel.text = ((RKRateInfoModel *)[_leftDataArray objectAtIndex:indexPath.row]).rateTitle;
        [cell.contentView viewWithTag:12605].backgroundColor = [colorArray objectAtIndex:indexPath.row%4];
        [cell.selectedBackgroundView viewWithTag:12606].backgroundColor = [cell.contentView viewWithTag:12605].backgroundColor;
    }else{
        UILabel *label = (UILabel *)[cell viewWithTag:12607];
        label.text = ((RKRateInfoModel *)[_rightDataArray objectAtIndex:indexPath.row]).rateTitle;
        NSDictionary *attribute = @{NSFontAttributeName:label.font};
        CGSize size = [label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2-18, MAXFLOAT)
                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
        label.frame = CGRectMake(8, 8, SCREEN_WIDTH/2-18, size.height);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == RKTableViewLeft) {

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor redColor];
        
        if (_leftSelectIndexPath) {
            UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:_leftSelectIndexPath];
            cell1.textLabel.dk_textColorPicker = DKColorWithRGB(0x323232, 0x8c8c8c);
        }
        
        _leftSelectIndexPath = indexPath;

        //刷新右边数据
        if ([_leftDataArray count]>indexPath.row) {
            _rightDataArray = ((RKRateInfoModel *)[_leftDataArray objectAtIndex:indexPath.row]).subInfos;
            [_rightTableView reloadData];
        }
    }else{
        RKRateInfoModel *model = [_rightDataArray objectAtIndex:indexPath.row];
        if (RKYieldRatePageTypeInfoPage == self.pageType) {
            //进入收益率曲线页面
            RKRateDetailController *detail = [[RKRateDetailController alloc] init];
            detail.rateModel = model;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(yieldRatePage: didChoiceData:)]) {
                
                //记录下所选曲线id     只有 tabbar 中债数据 viewwillappear 的时候刷新请求 需要用！！！
//                NSMutableDictionary *dic = [[CBCacheManager shareCache].phoneDic mutableCopy];
//                [dic setObject:model.rateID forKey:@"curveId"];
//                [dic setObject:model.rateTitle forKey:@"curveName"];
//                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"phoneConfigue"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                //tabbar 中债数据 viewwillappear 的时候刷新请求  偏好设置存储参数，  代理又刷新  
                [self.delegate yieldRatePage:self didChoiceData:model];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
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
    _leftTableView.hidden = YES;
    _rightTableView.hidden = YES;
}
- (void)hideHud
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _leftTableView.hidden = NO;
    _rightTableView.hidden = NO;
}
@end
