//
//  CBChannelController.m
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#define SectionCount 5
#define ExpandCount 6

#import "CBChannelController.h"
#import "CBChannelChildCell.h"
#import "CBChannelGroupCell.h"
#import "CBChannelModel.h"
#import "CBChannelSChildCell.h"
#import "CBCacheManager.h"

@interface CBChannelController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _selectRow;
     CGFloat _totalWidth;
     CGFloat _width;
     int _n;
     int _m;
}
@property (nonatomic, strong) UITableView *tableView;
@property (assign, nonatomic) BOOL isExpand;//是否展开二级列表
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSArray *listArr;
@property (strong, nonatomic) NSArray *disPlayArr;

@property (nonatomic) BOOL isExpandThree;

@end

@implementation CBChannelController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.title = @"自定义";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.isExpand = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];

    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.tableView.dk_separatorColorPicker = DKColorWithRGB(0xdbdcdd, 0x252525);
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    
    [self requestChannelList];
}

- (void)requestChannelList
{
    [[CBHttpRequest shareRequest] getWithUrl:@"http://www.chinabond.com.cn/d2s/menu.json"
                                      Params:nil
                             completionBlock:^(id responseObject) {
                                 
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 
                                 NSArray *menuList = responseObject[@"menu1List"];
                                 
                                 self.listArr = [self setModelWithArr:menuList];
                                 
                                 [self reloadDataForDisplayArray];
                                 
                             }
                                   failBlock:^(NSError *error) {
                                       
                                       CBLog(@"%@",error);
                                       
                                   }];
}

- (NSArray *)setModelWithArr:(NSArray *)menuList
{
    
    NSMutableArray *channelArr = [[NSMutableArray alloc] initWithCapacity:100];
    
    for (int i=0;i<menuList.count;i++) {
        
        NSDictionary *dic = menuList[i];
        CBChannelModel *model1 = [[CBChannelModel alloc] init];
        
        //检查第一层是否有菜单
        NSArray *menuList2 = [dic objectForKey:@"menu2List"];
        if (menuList2.count>0) {
            
            //第一层有子菜单
            
            NSMutableArray *chilrenArr = [[NSMutableArray alloc] initWithCapacity:100];
            
            for (int m=0;m<menuList2.count;m++) {
                
                NSDictionary *dic2 = menuList2[m];
                CBChannelModel *model2 = [[CBChannelModel alloc] init];
                
                //检查第二层是否有菜单
                NSArray *menuList3 = [dic2 objectForKey:@"menu3List"];
                
                if (menuList3.count > 0) {
                    
                    //第二层有子菜单
                    NSMutableArray *chilrenArr1 = [[NSMutableArray alloc] initWithCapacity:100];
                    
                    for (int n=0;n<menuList3.count;n++) {
                        NSDictionary *dic3 = menuList3[n];
                        CBChannelModel *model3 = [[CBChannelModel alloc] init];
                        model3.channelD =      [dic3 objectForKey:@"channelD"];
                        model3.label =         [dic3 objectForKey:@"label"];
                        model3.canSearchable = [dic3 objectForKey:@"canSearchable"];
                        model3.typeID =        [dic objectForKey:@"typeid"];
                        model3.parentName =    [dic objectForKey:@"label"];
                        model3.isExpand = NO;
                        model3.type = 3;
                        model3.level1 = i;
                        model3.level2 = m;
                        model3.level3 = n;
                        
                        [chilrenArr1 addObject:model3];
                    }
                    model2.channelD =      [dic2 objectForKey:@"channelD"];
                    model2.label =         [dic2 objectForKey:@"label"];
                    model2.canSearchable = [dic2 objectForKey:@"canSearchable"];
                    model2.typeID =        [dic objectForKey:@"typeid"];
                    model2.parentName   =  [dic objectForKey:@"label"];
                    model2.isExpand = NO;
                    model2.type = 2;
                    model2.level1 = i;
                    model2.level2 = m;
                    model2.level3 = 0;
                    model2.childrens = chilrenArr1;
                }
                else
                {
                    //第二层没有子菜单
                    
                    model2.channelD =      [dic2 objectForKey:@"channelD"];
                    model2.label =         [dic2 objectForKey:@"label"];
                    model2.canSearchable = [dic2 objectForKey:@"canSearchable"];
                    model2.typeID =        [dic objectForKey:@"typeid"];
                    model2.parentName =    [dic objectForKey:@"label"];
                    model2.isExpand = NO;
                    model2.type = 2;
                    model2.level1 = i;
                    model2.level2 = m;
                    model2.level3 = 0;
                }
                
                [chilrenArr addObject:model2];
                
            }
            model1.channelD =      [dic objectForKey:@"channelD"];
            model1.label =         [dic objectForKey:@"label"];
            model1.canSearchable = [dic objectForKey:@"canSearchable"];
            model1.typeID =        [dic objectForKey:@"typeid"];
            model1.parentName =    [dic objectForKey:@"label"];
            model1.isExpand = NO;
            model1.type = 1;
            model1.level1 = i;
            model1.level2 = 0;
            model1.level3 = 0;
            model1.childrens = chilrenArr;
            
        }
        else
        {
            //第一层没有子菜单
            
            model1.channelD =      [dic objectForKey:@"channelD"];
            model1.label =         [dic objectForKey:@"label"];
            model1.canSearchable = [dic objectForKey:@"canSearchable"];
            model1.typeID =        [dic objectForKey:@"typeid"];
            model1.parentName =    [dic objectForKey:@"label"];
            model1.isExpand = NO;
            model1.type = 1;
            model1.level1 = i;
            model1.level2 = 0;
            model1.level3 = 0;
        }
        
        [channelArr addObject:model1];
        
    }
    
    return channelArr;
}

- (void)reloadDataForDisplayArray
{
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:100];
    for (CBChannelModel *model in self.listArr) {
        [tmp addObject:model];
    }
    self.disPlayArr = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}

-(UIView *)headerView
{
    _totalWidth = 0;
    _width = 0;
    _m = 0;
    _n = 0;
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165)];
    hView.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH-20, 10)];
    label.font = Font(10);
    label.dk_textColorPicker = DKColorWithRGB(0xa8a8a8, 0x40404);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您可以自定义三个快速通道";
    [hView addSubview:label];
    
    
    NSArray *array = [[CBCacheManager shareCache] getCache];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = array[i];
        NSString *title = dic[@"name"];
        //如果是自定义按钮
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize textSize = [title sizeWithFont:[UIFont systemFontOfSize:12]
                            constrainedToSize:CGSizeMake(SCREEN_WIDTH, 28)
                                lineBreakMode:NSLineBreakByWordWrapping];
        _totalWidth += 20 + (textSize.width + 30);

        if (_totalWidth >= SCREEN_WIDTH) {
            _n++;
            _totalWidth = 0;
            _totalWidth += 20 + (textSize.width + 30);
            _width = 0;
            _m=0;
        }
        
        
        button.frame = CGRectMake(20*(_m+1)+_width, 27+(28+15)*_n, textSize.width+30, 28);
        
        _width += textSize.width+30;
        _m++;
        
        button.titleLabel.font = Font(12);
        
        if (![title isEqualToString:@"添加自定义"]) {
            
            [button setTitle:title forState:UIControlStateNormal];
            
        }
        else
        {
            [button setTitle:@"" forState:UIControlStateNormal];
        }
        
        if (i<4) {
            button.layer.borderColor = UIColorFromRGB(0xd4d5d6).CGColor;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 14;
        }
        else
        {
            if (![title isEqualToString:@"添加自定义"]) {
                
                button.layer.borderColor = UIColorFromRGB(0x23a8f5).CGColor;
                button.layer.borderWidth = 1;
                button.layer.cornerRadius = 14;
                
                button.tag = i;
                [button addTarget:self action:@selector(deleteChannel:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"brokeRound"] forState:UIControlStateNormal];
            }
        }
        
        [button dk_setTitleColorPicker:DKColorWithRGB(0x868686, 0x262626) forState:UIControlStateNormal];
        [hView addSubview:button];
    }
    
    UIImageView *shapeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 27+(28+15)*_n+30+10, SCREEN_WIDTH, 10)];
    shapeImage.dk_imagePicker = DKImageWithNames(@"channel_shape", @"channel_shape_night");
    [hView addSubview:shapeImage];
    
    hView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 27+(28+15)*_n+30+20);
    
    return hView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.disPlayArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    
    CBChannelModel *model = self.disPlayArr[indexPath.row];
    
    NSArray * nameArr = [[CBCacheManager shareCache] getCache];

    if (model.type == 2) {     // Expand Cell
        CBChannelChildCell *childCell = [tableView dequeueReusableCellWithIdentifier:@"CBChannelChildCell"];
        if (!childCell) {
            childCell = [CBChannelChildCell channelChildCell];
        }
        childCell.channelChildName.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
        //判断是否已经添加到自定义入口
        for (NSDictionary *dic in nameArr) {
            if ([dic[@"name"] isEqualToString:model.label]) {
                childCell.channelChildName.dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0x963132);
            }
        }
        
        childCell.channelChildName.text = model.label;
        
        if (model.childrens.count>0) {
            childCell.channelArrow.hidden = NO;
            childCell.channelAdd.hidden = YES;
            childCell.channelChildAddBtn.userInteractionEnabled = NO;
        }
        else
        {
            childCell.channelArrow.hidden = YES;
            childCell.channelAdd.hidden = NO;
            childCell.channelChildAddBtn.userInteractionEnabled = YES;
            childCell.channelChildAddBtn.tag = indexPath.row;
            [childCell.channelChildAddBtn addTarget:self action:@selector(addCustomChannelMethod:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (model.isExpand) {
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                childCell.channelArrow.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } completion:NULL];
        }
        else
        {
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                childCell.channelArrow.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            } completion:NULL];
        }
        
        childCell.contentView.dk_backgroundColorPicker = DKColorWithRGB(0xEFF0F4, 0x2b2a2a);
        
        cell = childCell;
    } else if(model.type == 1){    // Normal Cell
        CBChannelGroupCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"CBChannelGroupCell"];
        if (!groupCell) {
            groupCell = [CBChannelGroupCell channelGroupCell];
        }
        groupCell.channelGroupName.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
        //判断是否已经添加到自定义入口
        for (NSDictionary *dic in nameArr) {
            if ([dic[@"name"] isEqualToString:model.label]) {
                groupCell.channelGroupName.dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0x963132);
            }
        }
        groupCell.channelGroupName.text = model.label;
        //判断是否有二级菜单
        NSArray *menu2List = model.childrens;
        
        if (menu2List.count) {
            groupCell.channelGroupState.hidden = NO;
            groupCell.channelGroupAdd.hidden = YES;
        }
        else
        {
            groupCell.channelGroupState.hidden = YES;
            groupCell.channelGroupAdd.hidden = NO;
            groupCell.channelGroupAdd.tag = indexPath.row;
            [groupCell.channelGroupAdd addTarget:self action:@selector(addCustomChannelMethod:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (model.isExpand) {
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                groupCell.channelGroupState.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } completion:NULL];
        }
        else
        {
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                groupCell.channelGroupState.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            } completion:NULL];
        }
        
        groupCell.contentView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x171616);
        
        cell = groupCell;
    }else if(model.type == 3)
    {
        CBChannelSChildCell *childCell1 = [tableView dequeueReusableCellWithIdentifier:@"CBChannelSChildCell"];
        if (!childCell1) {
            childCell1 = [CBChannelSChildCell channelSChildCell];
        }
        childCell1.channelName.dk_textColorPicker = DKColorWithRGB(0x4c4c4c, 0x8c8c8c);
        //判断是否已经添加到自定义入口
        for (NSDictionary *dic in nameArr) {
            if ([dic[@"name"] isEqualToString:model.label]) {
                childCell1.channelName.dk_textColorPicker = DKColorWithRGB(0xff4e4e, 0x963132);
            }
        }
        childCell1.channelName.text = model.label;
        
        childCell1.channelAddButton.tag = indexPath.row;
        [childCell1.channelAddButton addTarget:self action:@selector(addCustomChannelMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        childCell1.contentView.dk_backgroundColorPicker = DKColorWithRGB(0xEFF0F4, 0x2b2a2a);
        cell = childCell1;
    }
    
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
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


#pragma mark - Private

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CBChannelModel *node in self.listArr) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpand = !node.isExpand;
        }
        ++cnt;
        if(node.isExpand){
            for(CBChannelModel *node2 in node.childrens){
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpand = !node2.isExpand;
                }
                ++cnt;
                if(node2.isExpand){
                    for(CBChannelModel *node3 in node2.childrens){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                }
            }
        }
    }
    self.disPlayArr = [NSArray arrayWithArray:tmp];
    
    [self.tableView reloadData];
}

#pragma mark 添加自定义菜单方法

- (void) addCustomChannelMethod:(UIButton *)sender
{
    CBChannelModel *model = self.disPlayArr[sender.tag];
    
    NSDictionary *dic = @{@"imgUrl":@"home_7",
                          @"id":model.channelD,
                          @"name":model.label,
                          @"typeId":model.typeID,
                          @"parentName":model.parentName,
                          @"level1":[NSString stringWithFormat:@"%d",model.level1],
                          @"level2":[NSString stringWithFormat:@"%d",model.level2],
                          @"level3":[NSString stringWithFormat:@"%d",model.level3]};

    NSMutableArray *channel = [[[CBCacheManager shareCache] getCache] mutableCopy];
    
    if (channel.count==8) {
        [MBProgressHUD bwm_showTitle:@"频道已满，请删除不需要的频道" toView:self.view hideAfter:2];
    }
    else
    {
        if (![channel containsObject:dic]) {
            
            [[CBCacheManager shareCache] addChannelWithDic:dic atIndex:[[CBCacheManager shareCache] getCache].count-1];
            
            [self.tableView setTableHeaderView:self.headerView];
            
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD bwm_showTitle:@"频道已添加" toView:self.view hideAfter:2];
        }
    }
    
}

- (void)deleteChannel:(UIButton *)sender
{
    [[CBCacheManager shareCache] deleteChannel:sender.tag];

    [self.tableView setTableHeaderView:self.headerView];
    
    [self.tableView reloadData];
}

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
