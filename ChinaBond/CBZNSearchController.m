//
//  CBZNSearchController.m
//  ChinaBond
//
//  Created by wangran on 15/12/4.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBZNSearchController.h"
#import "DWTagList.h"
#import "CBZNSearchResultController.h"

@interface CBZNSearchController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    CGFloat _totalWidth;
    CGFloat _width;
    int _n;
    int _m;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *channelView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *channelButton;
@property (nonatomic, strong) NSMutableArray *channelArr;
@property (nonatomic, strong) UIView *footerView1;

@property (nonatomic, strong) NSString *channelID;

@property (nonatomic, strong) NSArray *wordList;
@end

@implementation CBZNSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    

    //搜索
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53)];
    headerView.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.tableFooterView = self.footerView1;
    
    self.channelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 9, 65, 35)];
    [self.channelButton setTitle:@"全部频道" forState:UIControlStateNormal];
    self.channelButton.titleLabel.font = Font(14);
    [self.channelButton dk_setTitleColorPicker:DKColorWithRGB(0x4c4c4c, 0x8c8c8c) forState:UIControlStateNormal];
    self.channelButton.dk_backgroundColorPicker = DKColorWithRGB(0xf8f8f8, 0x313233);
    [self.channelButton addTarget:self action:@selector(changeChannel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.channelButton];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(75, 9, 5, 35)];
    shadowView.dk_backgroundColorPicker = DKColorWithRGB(0xf8f8f8, 0x313233);
    [headerView addSubview:shadowView];
    
    UIImageView *shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 5, 5)];
    shadowImage.image = [UIImage imageNamed:@"zn_search_shadow"];
    [shadowView addSubview:shadowImage];
    
    
    self.channelID = @"all";
    
    self.channelView = [[UITableView alloc] initWithFrame:CGRectMake(10, 44+64, 110, 235) style:UITableViewStylePlain];
    self.channelView.delegate = self;
    self.channelView.dataSource = self;
    self.channelView.scrollEnabled = NO;
    self.channelView.hidden = YES;
    self.channelView.showsHorizontalScrollIndicator = NO;
    self.channelView.showsVerticalScrollIndicator = NO;
    self.channelView.tableFooterView = [UIView new];
    self.channelView.dk_separatorColorPicker = DKColorWithRGB(0xffffff, 0x262626);
    [self.view addSubview:self.channelView];
    
    
    if ([self.channelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.channelView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.channelView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.channelView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 9, SCREEN_WIDTH-80-60, 35)];
    self.searchTF.placeholder = @"请输入关键词";
    self.searchTF.dk_backgroundColorPicker = DKColorWithRGB(0xf8f8f8, 0x313233);
    self.searchTF.delegate = self;
    [headerView addSubview:self.searchTF];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 9, 50, 35)];
    searchButton.dk_backgroundColorPicker = DKColorWithRGB(0xf36c6c, 0x963232);
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton dk_setTitleColorPicker:DKColorWithRGB(0xffffff, 0xbebebe) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchButton];
    
    [self requestHot];
    [self requestChannel];
}
//获取热词
- (void)requestHot
{
    [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                        Params:@{@"SID":@"13"}
                                        completionBlock:^(id responseObject) {
                                            
                                            NSString *state = responseObject[@"state"];
                                            if ([state isEqualToString:@"0"]) {
                                                self.wordList = responseObject[@"wordList"];
                                                self.tableView.tableFooterView = self.footerView1;
                                                [self.tableView reloadData];
                                            }
                                            else
                                            {
                                                [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                            }

                                            
                                        } failBlock:^(NSError *error) {
                                            
                                        }];
    
}

-(NSMutableArray *)channelArr
{
    if (!_channelArr) {
        _channelArr = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _channelArr;
}
//获取频道列表
- (void)requestChannel
{
    [[CBHttpRequest shareRequest] getWithUrl:@"https://www.chinabond.com.cn/d2s/menu.json"
                                        Params:nil
                                        completionBlock:^(id responseObject) {
                                            
                                            NSArray *arr = responseObject[@"menu1List"];
                                            
                                            for (NSDictionary *dic in arr) {
                                                
                                                if ([dic[@"canSearchable"] isEqualToString:@"true"]) {
                                                    [self.channelArr addObject:@{@"label":dic[@"label"],
                                                                                 @"channelD":dic[@"channelD"]}];
                                                }
                                                
                                                //遍历一级菜单，如果一级菜单没有子菜单，添加canSearchable为true的对象
                                                NSArray *menu2List = dic[@"menu2List"];
                                                if (menu2List.count>0) {
                                                    
                                                    //遍历二级菜单，如果二级菜单没有子菜单，添加canSearchable为true的对象
                                                    for (NSDictionary *dic1 in menu2List) {
                                                        
                                                        if ([dic1[@"canSearchable"] isEqualToString:@"true"]) {
                                                            [self.channelArr addObject:@{@"label":dic1[@"label"],
                                                                                         @"channelD":dic1[@"channelD"]}];
                                                        }
                                                        
                                                        NSArray *menu3List = dic1[@"menu3List"];
                                                        
                                                        if (menu3List.count>0) {
                                                            
                                                            for (NSDictionary *dic2 in menu3List) {
                                                                
                                                                if ([dic2[@"canSearchable"] isEqualToString:@"true"]) {
                                                                    [self.channelArr addObject:@{@"label":dic2[@"label"],
                                                                                                 @"channelD":dic2[@"channelD"]}];
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            [self.channelArr insertObject:@{@"label":@"全部频道",
                                                                            @"channelD":@"all"}
                                                                  atIndex:0];
                                            
                                            [self.channelView reloadData];
                                            
                                        } failBlock:^(NSError *error) {
                                            
                                        }];
}

#pragma mark - CBChannelChoseDelegate

-(void)changeChannel:(NSString *)channelName
{
    [self.channelButton setTitle:channelName forState:UIControlStateNormal];
}

#pragma maek- button click method

- (void)changeChannel
{
    self.channelView.hidden = !self.channelView.hidden;
}
//搜索
- (void)searchbuttonClick
{
    [self.searchTF resignFirstResponder];
    self.channelView.hidden = YES;
    
    if (self.searchTF.text.length == 0) {
        [MBProgressHUD bwm_showTitle:@"请输入搜索关键字" toView:self.view hideAfter:2];
    }
    else
    {
        CBZNSearchResultController *result = [[CBZNSearchResultController alloc] init];
        result.channelID = self.channelID;
        result.searchWord = self.searchTF.text;
        [self.navigationController pushViewController:result animated:YES];
    }
    
}

- (void)hotwordSearch:(UIButton *)sender
{
    self.searchTF.text = self.wordList[sender.tag][@"keyWord"];
    
    CBZNSearchResultController *result = [[CBZNSearchResultController alloc] init];
    result.channelID = self.channelID;
    result.searchWord = self.wordList[sender.tag][@"keyWord"];
    [self.navigationController pushViewController:result animated:YES];
}

-(UIView *)footerView1
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    footer.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 20)];
    label.text = @"热门搜索";
    label.dk_textColorPicker = DKColorWithRGB(0x000000, 0x737373);
    [footer addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 55, SCREEN_WIDTH-10, 1)];
    line.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x242526);
    [footer addSubview:line];
    
    for (int i=0; i<self.wordList.count; i++) {
        NSDictionary *dic = self.wordList[i];
        NSString *title = dic[@"keyWord"];
        //如果是自定义按钮
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize textSize = [title sizeWithFont:[UIFont systemFontOfSize:12]
                            constrainedToSize:CGSizeMake(SCREEN_WIDTH, 28)
                                lineBreakMode:NSLineBreakByWordWrapping];
        _totalWidth += 20 + (textSize.width + 20);
        
        if (_totalWidth >= (SCREEN_WIDTH-20)) {
            _n++;
            _totalWidth = 0;
            _totalWidth += 20 + (textSize.width + 20);
            _width = 0;
            _m=0;
        }
        
        
        button.frame = CGRectMake(20*(_m+1)+_width, 65+(28+15)*_n, textSize.width+20, 28);
        
        _width += textSize.width+20;
        _m++;
        
        button.titleLabel.font = Font(12);
        [button setTitle:title forState:UIControlStateNormal];
        button.layer.cornerRadius = 14;
        button.layer.borderColor = UIColorFromRGB(0xd4d5d6).CGColor;
        button.layer.borderWidth = 1;
        [button dk_setTitleColorPicker:DKColorWithRGB(0x868686, 0x262626) forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(hotwordSearch:) forControlEvents:UIControlEventTouchUpInside];
        
        [footer addSubview:button];
    }
    
    return footer;
}

#pragma mark - tableview datasource delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.channelView) {
        return self.channelArr.count;
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
        channelCell.textLabel.adjustsFontSizeToFitWidth = YES;
        channelCell.textLabel.text = self.channelArr[indexPath.row][@"label"];
        
        cell = channelCell;
    }
    else
    {
        static NSString *cellIndentifier = @"searchCell";
        UITableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!searchCell) {
            searchCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        searchCell.textLabel.text = @"07国债05  (010705)";

        cell = searchCell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.channelView) {
        self.channelID = self.channelArr[indexPath.row][@"channelD"];
        [self.channelButton setTitle:self.channelArr[indexPath.row][@"label"] forState:UIControlStateNormal];
        self.channelView.hidden = !self.channelView.hidden;
    }
    else
    {
       
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 100;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        self.channelView.hidden = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTF resignFirstResponder];
    return YES;
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
