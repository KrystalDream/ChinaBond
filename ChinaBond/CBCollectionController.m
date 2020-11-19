//
//  CBCollectionController.m
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBCollectionController.h"
#import "CBCollectCell.h"
#import "CBFocusDetailController.h"
#import "CBDataBase.h"
#import "UIScrollView+Associated.h"

@interface CBCollectionController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *noCollectImage;//无数据显示image
@property (strong, nonatomic) NSMutableArray *dataList;//数据源

@end

@implementation CBCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.tableFooterView = [UIView new];

    self.noCollectImage.dk_imagePicker = DKImageWithNames(@"noCollection", @"noCollection_night");
    
    self.tableView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x000000);
    
    __weak typeof(self)weafSelf=self;
    
    self.tableView.refreshView=[[TiRefreshView alloc]initWithHandler:^{
        
        [weafSelf requestForMyCollect];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weafSelf.tableView.refreshView stopRefresh];
        });
    }];
}

-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _dataList;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestForMyCollect];
}

- (void)requestForMyCollect
{
    [[CBDataBase sharedDatabase] initialData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
     NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    [[CBHttpRequest shareRequest] postWithUrl:CBBaseUrl
                                        Params:@{@"SID":@"07",
                                                  @"userName":infoDic[@"userName"],
                                                  @"sFlag":@"2"}
                                completionBlock:^(id responseObject) {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    
                                    [self.dataList removeAllObjects];
                                    
                                    NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
                                    if ([state isEqualToString:@"0"]) {
                                        for (NSDictionary *dic in responseObject[@"dataList"]) {
                                            if (![dic[@"title"] isEqualToString:@""]) {
                                                [self.dataList addObject:dic];
                                            }
                                        }
                                    }
                                    
                                    
                                    //self.dataList = [responseObject[@"dataList"] mutableCopy];
                                    
                                    NSArray *noteList = self.dataList;//[responseObject objectForKey:@"dataList"];
                                    
                                    if (noteList.count > 0) {
                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                            [[CBDataBase sharedDatabase] insertAllNewsList:noteList];
                                        });
                                    }
                                    [self configueTable];
                                } failBlock:^(NSError *error) {
                                    
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    //NSLog(@"%@",error);
                                }];
}

- (void)configueTable
{
    if (self.dataList.count == 0) {
        self.tableView.hidden = YES;
    }
    else
    {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBCollectCell *collect = [tableView dequeueReusableCellWithIdentifier:@"CBCollectCell"];
    if (!collect) {
        collect = [CBCollectCell collectCell];
    }
    
    
    collect.titleLab.text = self.dataList[indexPath.row][@"title"];
    collect.timeLab.text = self.dataList[indexPath.row][@"vTime"];
    collect.newsForm.text = [NSString stringWithFormat:@"【%@】",self.dataList[indexPath.row][@"cName"]];
    collect.timeLab.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x404040);
    collect.newsForm.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x404040);
    collect.lineView.dk_backgroundColorPicker = DKColorWithRGB(0xd9d9d9, 0x262626);
    collect.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
    
    return collect;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBFocusDetailController *focusDetail = [[CBFocusDetailController alloc] init];
    focusDetail.infoDic = self.dataList[indexPath.row];
    focusDetail.infoUrl = self.dataList[indexPath.row][@"infoUrl"];
    focusDetail.tId = self.dataList[indexPath.row][@"tId"];
    [self.navigationController pushViewController:focusDetail animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [[CBDataBase sharedDatabase] deleteNewsWithTid:@"14315820"];
        
        NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        
       [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                        Params:@{@"SID":@"11",
                                                 @"userName":infoDic[@"userName"],
                                                 @"infoId":self.dataList[indexPath.row][@"tId"]}
                                        completionBlock:^(id responseObject) {
                                            
                                            [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                            
                                            NSString *state = [responseObject objectForKey:@"state"];
                                            if ([state isEqualToString:@"0"]) {
                                                
                                                [self.dataList removeObjectAtIndex:indexPath.row];
                                                [self configueTable];
                                            }
                                            
                                        } failBlock:^(NSError *error) {
                                            
                                        }];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
