//
//  CBGuzhiController.m
//  ChinaBond
//
//  Created by wangran on 15/12/28.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBGuzhiController.h"
#import "UIScrollView+Associated.h"
#import "CBGuzhiCell.h"

@interface CBGuzhiController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *guzhiList;

@end

@implementation CBGuzhiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"中债估值";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

    [self requestData];
}

- (void)requestData
{
    //估值接口
    [[CBHttpRequest shareRequest] postWithUrl:@"https://testyield.chinabond.com.cn/cbweb-mn/GetIndexServlet/d2s"
                                       Params:nil
                              completionBlock:^(id responseObject) {
                                  
                                  NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
                                  if ([state isEqualToString:@"0"]) {
                                      self.guzhiList = responseObject[@"lists"];
                                      [self.collectionView reloadData];
                                      
                                  }
                                  else
                                  {
                                      [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                  }
                                  
                              }   failBlock:^(NSError *error) {
                                  
                                  CBLog(@"%@",error);
                                  
                              }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.guzhiList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-30)/2, 100);
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"CBGuzhiCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"CBGuzhiCell"];
    CBGuzhiCell *cell = [[CBGuzhiCell alloc]init];
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CBGuzhiCell"
                                                     forIndexPath:indexPath];
    
    cell.zqjc.text = self.guzhiList[indexPath.row][@"zqjc"];
    cell.gzjz.text = self.guzhiList[indexPath.row][@"gzjz"];
    cell.dcq.text = [NSString stringWithFormat:@"%@年",self.guzhiList[indexPath.row][@"dcq"]];
    cell.gzsyl.text = [NSString stringWithFormat:@"%@%@",self.guzhiList[indexPath.row][@"gzsyl"],@"%"];
    
    return cell;
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
