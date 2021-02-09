//
//  RKExponentViewController.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/3.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKExponentViewController.h"
#import "RKExponentView.h"
#import "RKCateFreshView.h"
#import "RKCateLevelModel.h"
#import "RKExponentDetailController.h"
#import "CBHttpRequest.h"
#import "RKExponentTopModel.h"
#import "RKDataManager.h"

@interface RKExponentViewController ()<RKCateFreshViewDelegate>
{
    RKCateFreshView *_freshView;
    NSMutableArray *_topDatas;
    NSArray *_tableViewData;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *cateDataArray;
@end

@implementation RKExponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (RKExponentPageTypeChoice == self.pageType) {
        self.title = @"选择指数";
    }else{
        self.title = @"中债指数";
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
    UIView *tableViewHeader = nil;
    if (RKExponentPageTypeInfoPage == self.pageType) {
        tableViewHeader = [[RKExponentView alloc] init];
    }else{
        tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        tableViewHeader.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
        UIView *icon = [[UIView alloc] initWithFrame:CGRectMake(0, 12, 4, 20)];
        icon.backgroundColor = [UIColor colorWithRed:251/255.0 green:70/255.0 blue:77/255.0 alpha:1.0];
        UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 20)];
        iconLabel.backgroundColor = [UIColor clearColor];
        iconLabel.font = [UIFont systemFontOfSize:15];
        iconLabel.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x737373);
        iconLabel.text = @"中债指数";
        [tableViewHeader addSubview:icon];
        [tableViewHeader addSubview:iconLabel];
    }
    self.tableView.tableHeaderView = tableViewHeader;
    //初始化freshView状态
    _freshView = [[RKCateFreshView alloc] init];
    _freshView.delegate = self;
    
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.tableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.tableView.dk_separatorColorPicker = DKColorWithRGB(0xebeced, 0x252525);
    [self requestForExponentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestForExponentList
{
    [self showHud];
    _topDatas = [NSMutableArray arrayWithCapacity:0];
    self.cateDataArray = [NSMutableArray arrayWithCapacity:0];
    [[CBHttpRequest shareRequest] postWithUrl:kApiExponentList
                                       Params:@{}
                              completionBlock:^(id responseObject) {
                                  
                                  //NSLog(@"%@",responseObject);
                                  
                                  if ([[(NSDictionary *)responseObject objectForKey:@"state"] isEqualToString:@"0"]) {
                                      //解析top
                                      NSArray *retArr = [(NSDictionary *)responseObject objectForKey:@"lists"];
                                      if (retArr) {
                                          NSDictionary *retDicFuckApi = [retArr firstObject];
                                          NSArray *topArray = [retDicFuckApi objectForKey:@"top"];
                                          for (NSDictionary *dic in topArray) {
                                              RKExponentTopModel *model = [[RKExponentTopModel alloc] init];
                                              id cfzs = [dic objectForKey:@"cfzs"];
                                              if ([cfzs isKindOfClass:[NSNumber class]]) {
                                                  model.topcfzsTMD = [cfzs stringValue];
                                              }else if([cfzs isKindOfClass:[NSString class]]){
                                                  model.topcfzsTMD = cfzs;
                                              }
                                              
                                              id topcfzszdfTMD = [dic objectForKey:@"cfzszdf"];
                                              if ([topcfzszdfTMD isKindOfClass:[NSNumber class]]) {
                                                  model.topcfzszdfTMD = [topcfzszdfTMD stringValue];
                                              }else if([topcfzszdfTMD isKindOfClass:[NSString class]]){
                                                  model.topcfzszdfTMD = topcfzszdfTMD;
                                              }
                                              
                                              id topjjzsTMD = [dic objectForKey:@"jjzs"];
                                              if ([topjjzsTMD isKindOfClass:[NSNumber class]]) {
                                                  model.topjjzsTMD = [topjjzsTMD stringValue];
                                              }else if([topjjzsTMD isKindOfClass:[NSString class]]){
                                                  model.topjjzsTMD = topjjzsTMD;
                                              }
                                              
                                              id topjjzszdfTMD = [dic objectForKey:@"jjzszdf"];
                                              if ([topjjzszdfTMD isKindOfClass:[NSNumber class]]) {
                                                  model.topjjzszdfTMD = [topjjzszdfTMD stringValue];
                                              }else if([topjjzszdfTMD isKindOfClass:[NSString class]]){
                                                  model.topjjzszdfTMD = topjjzszdfTMD;
                                              }
                                              model.topNameTMD = [dic objectForKey:@"name"];
                                              [_topDatas addObject:model];
                                          }
                                          //解析目录
                                          NSArray *menuArray = [retDicFuckApi objectForKey:@"menu"];
                                          if (menuArray) {
                                              for (NSDictionary *dicA in menuArray) {
                                                  RKCateLevelModel *model1 = [[RKCateLevelModel alloc] init];
                                                  model1.levelID = [dicA objectForKey:@"id"];
                                                  model1.levelTitle = [dicA objectForKey:@"name"];
                                                  model1.levelType = RKLevelTypeA;
                                                  NSString *isListOrNot = [dicA objectForKey:@"ischannelend"];
                                                  if ([isListOrNot isEqualToString:@"0"]) {
                                                      model1.levelIsList = NO;
                                                  }else{
                                                      model1.levelIsList = NO;//这个特殊，全是列表上的
                                                  }
                                                  NSArray *subArrayB = [dicA objectForKey:@"childs"];
                                                  NSMutableArray *subLevelsB = [NSMutableArray arrayWithCapacity:[subArrayB count]];
                                                  BOOL subLevelsIsListOrNot2 = NO;//标志位，看数据存放到哪个数组中
                                                  for (NSDictionary *dicB in subArrayB) {
                                                      RKCateLevelModel *model2 = [[RKCateLevelModel alloc] init];
                                                      model2.levelID = [dicB objectForKey:@"id"];
                                                      model2.levelTitle = [dicB objectForKey:@"name"];
                                                      model2.levelType = RKLevelTypeB;
                                                      NSString *isListOrNot = [dicB objectForKey:@"ischannelend"];
                                                      if ([isListOrNot isEqualToString:@"0"]) {
                                                          model2.levelIsList = NO;
                                                      }else{
                                                          model2.levelIsList = YES;
                                                          subLevelsIsListOrNot2 = YES;
                                                      }
                                                      NSArray *subArrayC = [dicB objectForKey:@"childs"];
                                                      NSMutableArray *subLevelsC = [NSMutableArray arrayWithCapacity:[subArrayC count]];
                                                      BOOL subLevelsIsListOrNot3 = NO;//标志位，看数据存放到哪个数组中
                                                      for (NSDictionary *dicC in subArrayC) {
                                                          RKCateLevelModel *model3 = [[RKCateLevelModel alloc] init];
                                                          model3.levelID = [dicC objectForKey:@"id"];
                                                          model3.levelTitle = [dicC objectForKey:@"name"];
                                                          model3.levelType = RKLevelTypeC;
                                                          NSString *isListOrNot = [dicC objectForKey:@"ischannelend"];
                                                          if ([isListOrNot isEqualToString:@"0"]) {
                                                              model3.levelIsList = NO;
                                                          }else{
                                                              model3.levelIsList = YES;
                                                              subLevelsIsListOrNot3 = YES;
                                                          }
                                                          NSArray *subArrayD = [dicC objectForKey:@"childs"];
                                                          NSMutableArray *subLevelsD = [NSMutableArray arrayWithCapacity:[subArrayC count]];
                                                          BOOL subLevelsIsListOrNot4 = NO;//标志位，看数据存放到哪个数组中
                                                          for (NSDictionary *dicD in subArrayD) {
                                                              RKCateLevelModel *model4 = [[RKCateLevelModel alloc] init];
                                                              model4.levelID = [dicD objectForKey:@"id"];
                                                              model4.levelTitle = [dicD objectForKey:@"name"];
                                                              model4.levelType = RKLevelTypeD;
                                                              NSString *isListOrNot = [dicD objectForKey:@"ischannelend"];
                                                              if ([isListOrNot isEqualToString:@"0"]) {
                                                                  model4.levelIsList = NO;
                                                              }else{
                                                                  model4.levelIsList = YES;
                                                                  subLevelsIsListOrNot4 = YES;
                                                              }
                                                              [subLevelsD addObject:model4];
                                                          }
                                                          if (subLevelsIsListOrNot4) {
                                                              model3.subListLevels = subLevelsD;
                                                          }else{
                                                              model3.subLevels = subLevelsD;
                                                          }
                                                          [subLevelsC addObject:model3];
                                                      }
                                                      if (subLevelsIsListOrNot3) {
                                                          model2.subListLevels = subLevelsC;
                                                      }else{
                                                          model2.subLevels = subLevelsC;
                                                      }
                                                      [subLevelsB addObject:model2];
                                                  }
                                                  if (subLevelsIsListOrNot2) {
                                                      model1.subListLevels = subLevelsB;
                                                  }else{
                                                      model1.subLevels = subLevelsB;
                                                  }
                                                  [self.cateDataArray addObject:model1];
                                              }
                                          }
                                      }
                                      [_freshView resetWithData:self.cateDataArray];
                                      
                                      if ([self.tableView.tableHeaderView isKindOfClass:[RKExponentView class]]) {
                                          [((RKExponentView *)self.tableView.tableHeaderView) configDataWithArray:_topDatas];
                                      }
                                      [_tableView reloadData];
                                      [self hideHud];
                                  }
                                  
                              } failBlock:^(NSError *error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                  [alert  show];
                                  [self hideHud];
                              }];
}


- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [_freshView heightOfCurrent];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        //重置cell状态
        cell.textLabel.text = @"";
    }
    
    cell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    cell.textLabel.dk_textColorPicker = DKColorWithRGB(0x323232, 0x737373);
    
    //给cell配置数据模版
    RKCateLevelModel *model = nil;
    if (indexPath.row<[_tableViewData count]) {
        model = [_tableViewData objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = model.levelTitle;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _freshView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKCateLevelModel *model = nil;
    if (indexPath.row < [_tableViewData count]) {
        model = [_tableViewData objectAtIndex:indexPath.row];
    }
    if (RKExponentPageTypeInfoPage == self.pageType) {
        RKExponentDetailController*detail = [[RKExponentDetailController alloc] init];
        
        detail.exponentModel = model;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(exponentPage:didChoiceData:)]) {
            
            //记录下所选曲线id
            NSMutableDictionary *dic = [[CBCacheManager shareCache].phoneDic mutableCopy];
            [dic setObject:model.levelID forKey:@"indicsId"];
            [dic setObject:model.levelTitle forKey:@"indicsName"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"phoneConfigue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //[self.delegate exponentPage:self didChoiceData:model];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)freshViewDidRefresh:(RKCateFreshView *)view
{
    [self.tableView reloadData];
}

- (void)freshViewSelectModel:(RKCateLevelModel *)model
{
        _tableViewData = model.subListLevels;

    [self.tableView reloadData];
}

- (NSArray *)configDemoData
{
    //进行数据解析
    NSArray *titles1 = @[@"总指数", @"成分指数", @"策略指数", @"投资者分类指数"];
    NSArray *titles2 = @[@"分类指数",@"综合类指数"];
    NSArray *titles3 = @[@"按流通场所", @"按发行人类型", @"按流通场所", @"按流通场所", @"按流通场所", @"按流通场所", @"按流通场所", @"其他",];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:[titles1 count]];
    for (int i=0;i<[titles1 count];i++) {
        RKCateLevelModel *model1 = [[RKCateLevelModel alloc] init];
        model1.levelTitle = [titles1 objectAtIndex:i];
        model1.levelType = RKLevelTypeA;
        if (0==i) {
            //总指数子level
            NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
            for (int j=0;j<[titles2 count];j++) {
                RKCateLevelModel *model2 = [[RKCateLevelModel alloc] init];
                model2.levelType = RKLevelTypeB;
                model2.levelTitle = [titles2 objectAtIndex:j];
                if (1==j) {
                    //分类指数子level
                    NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
                    for (int k=0;k<[titles3 count];k++) {
                        RKCateLevelModel *model3 = [[RKCateLevelModel alloc] init];
                        model3.levelTitle = [titles3 objectAtIndex:k];
                        model3.levelType = RKLevelTypeC;
                        [arr2 addObject:model3];
                    }
                    model2.subLevels = arr2;
                }else{
                    model2.subLevels = nil;
                }
                [arr1 addObject:model2];
            }
            model1.subLevels = arr1;
        }else{
            model1.subLevels = nil;
        }
        [titleArray addObject:model1];
    }
    return titleArray;
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
    self.tableView.hidden = YES;
}
- (void)hideHud
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.tableView.hidden = NO;
}
@end
