//
//  CBZQSearchController.m
//  ChinaBond
//
//  Created by wangran on 15/12/4.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBZQSearchController.h"
#import "CBZQSearchCell.h"
#import "CBProductDetailController.h"
#import "CBCacheManager.h"

@interface CBZQSearchController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL _noResult;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *channelView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *channelButton;
@property (nonatomic, strong) NSArray *channelArr;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic) ZQSearchType searchType;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *clearHistoryRecord;
@property (nonatomic, strong) NSMutableArray *recordArr;
@end

@implementation CBZQSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取搜索记录
    
    NSArray *tmpArr = [[NSUserDefaults standardUserDefaults] objectForKey:KSearchRecord];
    
    if (tmpArr) {
        [self.recordArr addObjectsFromArray:tmpArr];
    }


    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-61) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor orangeColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    
    //搜索
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53)];
    headerView.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.tableView.tableHeaderView = headerView;
    
    self.channelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 9, 65, 35)];
    [self.channelButton setTitle:@"债券简称" forState:UIControlStateNormal];
    self.channelButton.titleLabel.font = Font(14);
    [self.channelButton dk_setTitleColorPicker:DKColorWithRGB(0x4c4c4c, 0x8c8c8c) forState:UIControlStateNormal];
    self.channelButton.dk_backgroundColorPicker = DKColorWithRGB(0xf8f8f8, 0x313233);
    [self.channelButton addTarget:self action:@selector(changeChannel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.channelButton];
    
    _searchType = ZQSearchTypeZQJC;
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(75, 9, 5, 35)];
    shadowView.dk_backgroundColorPicker = DKColorWithRGB(0xf8f8f8, 0x313233);
    [headerView addSubview:shadowView];
    
    UIImageView *shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 5, 5)];
    shadowImage.image = [UIImage imageNamed:@"zn_search_shadow"];
    [shadowView addSubview:shadowImage];
    
    self.channelArr = @[@"债券简称",@"债券代码"];
    
    self.channelView = [[UITableView alloc] initWithFrame:CGRectMake(10, 44+64, 110, 80) style:UITableViewStylePlain];
    self.channelView.delegate = self;
    self.channelView.dataSource = self;
    self.channelView.hidden = YES;
    self.channelView.showsHorizontalScrollIndicator = NO;
    self.channelView.showsVerticalScrollIndicator = NO;
    self.channelView.tableFooterView = [UIView new];
    [self.view addSubview:self.channelView];
    
    self.channelView.dk_separatorColorPicker = DKColorWithRGB(0xffffff, 0x262626);
    self.channelView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 9, SCREEN_WIDTH-80-60, 35)];
    self.searchTF.placeholder = @"债券简称/债券代码";
    self.searchTF.delegate = self;
    self.searchTF.font = Font(15);
    self.searchTF.dk_backgroundColorPicker = DKColorWithRGB(0xf8f8f8, 0x313233);
    [headerView addSubview:self.searchTF];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 9, 50, 35)];
    searchButton.dk_backgroundColorPicker = DKColorWithRGB(0xf36c6c, 0x963232);
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchButton];
    
    self.clearHistoryRecord = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-61, SCREEN_WIDTH-20, 40)];
    self.clearHistoryRecord.dk_backgroundColorPicker = DKColorWithRGB(0xfc8e39, 0xab6936);
    [self.clearHistoryRecord setTitle:@"清空历史记录" forState:UIControlStateNormal];
    [self.clearHistoryRecord dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
    [self.clearHistoryRecord addTarget:self action:@selector(clearHistoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearHistoryRecord];
    
    _noResult = NO;
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark- button click method

- (void)searchbuttonClick
{
    [self.searchTF resignFirstResponder];
   self.channelView.hidden = YES;
    
    NSDictionary *params = nil;
    
    if (self.searchTF.text.length == 0) {
        
        if ([self.channelButton.titleLabel.text isEqualToString:@"搜索类型"]) {
            [MBProgressHUD bwm_showTitle:@"请输入搜索关键字" toView:self.view hideAfter:2];
        }
        else
        {
            if (_searchType == ZQSearchTypeZQDM) {
                [MBProgressHUD bwm_showTitle:@"请输入债券代码" toView:self.view hideAfter:2];
            }
            else
            {
                [MBProgressHUD bwm_showTitle:@"请输入债券简称" toView:self.view hideAfter:2];
            }
        }
    }
    else
    {
        if (_searchType == ZQSearchTypeZQDM) {
            
            params = @{@"SID":@"01",
                       @"zqdm":self.searchTF.text,
                       @"pc":@"100"};
        }
        else
        {
            params = @{@"SID":@"01",
                       @"zqjc":[self.searchTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                       @"pc":@"100"};
        }
        
        
        [self.recordArr insertObject:self.searchTF.text atIndex:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.recordArr forKey:KSearchRecord];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                          Params:params
                                 completionBlock:^(id responseObject) {
                                     
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     
                                     NSString *state = responseObject[@"state"];
                                     if ([state isEqualToString:@"0"]) {
                                         
                                         self.dataList = responseObject[@"dataList"];
                                     }
                                     else
                                     {
                                         _noResult = YES;
                                         self.tableView.tableFooterView =self.footerView;
                                         self.clearHistoryRecord.hidden = YES;
                                     }
                                     [self.tableView reloadData];
                                     
                                 } failBlock:^(NSError *error) {
                                     
                                 }];
    }
}

- (void)changeChannel
{
    self.channelView.hidden = !self.channelView.hidden;
}

- (void)clearHistoryButtonClick
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KSearchRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.recordArr removeAllObjects];
    
    [self.tableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.searchTF.text.length == 0) {
        _noResult = NO;
        self.tableView.tableFooterView = [[UIView alloc] init];;
        [self.tableView reloadData];
        self.clearHistoryRecord.hidden = NO;
    }
    
    return YES;
}

-(UIView *)footerView
{
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-35)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-90)/2, 220, 90, 85)];
    imageView.dk_imagePicker = DKImageWithNames(@"noResult", @"noResult_night");
    [foot addSubview:imageView];
    
    UILabel *resultName = [[UILabel alloc] initWithFrame:CGRectMake(10, 325, SCREEN_WIDTH-20, 15)];
    resultName.dk_textColorPicker = DKColorWithRGB(0x868686, 0x666666);
    resultName.text = @"未搜到相关资讯";
    resultName.textAlignment = NSTextAlignmentCenter;
    resultName.font = Font(15);
    [foot addSubview:resultName];
    
    return foot;
}

#pragma mark - tableview datasource delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.channelView) {
        return self.channelArr.count;
    }
    else
    {
        if (self.dataList.count>0) {
            return self.dataList.count;
        }
        else
        {
            if (_noResult) {
                return 0;
            }
            //return [CBCacheManager shareCache].searchRecordArr.count+1;
            return self.recordArr.count+1;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.channelView) {
        return 40;
    }
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView == self.channelView) {
        static NSString *cellIndentifier = @"channelCell";
        
        UITableViewCell *channelCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!channelCell) {
            channelCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            channelCell.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x323232);
            channelCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            view.dk_backgroundColorPicker = DKColorWithRGB(0x23a8f5, 0x2979a7);
            [channelCell.selectedBackgroundView addSubview:view];
            
        }
        channelCell.textLabel.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0xbebebe);
        channelCell.textLabel.text = self.channelArr[indexPath.row];
        
        cell = channelCell;
    }
    else
    {
        if (self.dataList.count>0) {
            
            static NSString *cellIndentifier = @"resultCell";
            UITableViewCell *resultCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!resultCell) {
                resultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            resultCell.selectionStyle = UITableViewCellSelectionStyleNone;
            resultCell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
            resultCell.textLabel.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
            resultCell.textLabel.text = self.dataList[indexPath.row][@"zqjc"];
            
            cell = resultCell;
        }
        else
        {
            if (!_noResult) {
                if (indexPath.row == 0) {
                    static NSString *cellIndentifier = @"firstCell";
                    
                    UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                    if (!titleCell) {
                        titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    titleCell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
                    titleCell.textLabel.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0xbebebe);
                    titleCell.textLabel.text = @"历史记录";
                    
                    cell = titleCell;
                }
                else
                {
                    CBZQSearchCell *recordCell = [tableView dequeueReusableCellWithIdentifier:@"CBZQSearchCell"];
                    if (!recordCell) {
                        recordCell = [CBZQSearchCell zqSearchCell];
                    }
                    recordCell.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
                    recordCell.zqTitle.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
                    recordCell.zqTitle.text = self.recordArr[indexPath.row-1];
                    recordCell.zqDelete.tag = indexPath.row;
                    [recordCell.zqDelete addTarget:self action:@selector(deletehistoryWord:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cell = recordCell;
                }
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.channelView) {
        
        [self.channelButton setTitle:self.channelArr[indexPath.row] forState:UIControlStateNormal];
        self.channelView.hidden = !self.channelView.hidden;
        
        _searchType = indexPath.row;
        self.searchTF.text = @"";
        self.dataList = nil;
        [self.tableView reloadData];
    }
    else
    {
        if (self.dataList.count>0) {
            
            CBProductDetailController *detail = [[CBProductDetailController alloc] init];
            detail.infoDic = self.dataList[indexPath.row];
            detail.zqdm = self.dataList[indexPath.row][@"zqdm"];
            [self.navigationController pushViewController:detail animated:YES];
            
        }
        else
        {
            if (!_noResult) {
                if (indexPath.row != 0) {
                    self.searchTF.text = self.recordArr[indexPath.row-1];
                    [self searchbuttonClick];
                }
            }
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        self.channelView.hidden = YES;
    }
}

- (void)deletehistoryWord:(UIButton *)sender
{
    [self.recordArr removeObjectAtIndex:(sender.tag-1)];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.recordArr forKey:KSearchRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

-(NSMutableArray *)recordArr
{
    if (!_recordArr) {
        _recordArr = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    return _recordArr;
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
