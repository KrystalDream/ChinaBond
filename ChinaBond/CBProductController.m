//
//  CBProductController.m
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBProductController.h"
#import "CBProductCell.h"
#import "CBProductDetailController.h"

@interface CBProductController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *noProductImage;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *dataList;

@end

@implementation CBProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.noProductImage.dk_imagePicker = DKImageWithNames(@"noProduct", @"noProduct_night");
    
    self.collectionView.dk_backgroundColorPicker = DKColorWithRGB(0xeff0f4, 0x0f0f0f);
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x000000);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestForMyProduct];
}

- (void)requestForMyProduct
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                    Params:@{@"SID":@"07",
                                             @"userName":infoDic[@"userName"],
                                             @"sFlag":@"1"}
                                    completionBlock:^(id responseObject) {
                                        
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        
                                        self.dataList = responseObject[@"dataList"];
                                        
                                        if (self.dataList.count == 0) {
                                            self.collectionView.hidden = YES;
                                        }
                                        else
                                        {
                                            self.collectionView.hidden = NO;
                                            [self.collectionView reloadData];
                                        }
                                    } failBlock:^(NSError *error) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    }];
}

#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UINib *nib = [UINib nibWithNibName:@"CBProductCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"CBProductCell"];
    CBProductCell *cell = [[CBProductCell alloc]init];
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CBProductCell"
                                                     forIndexPath:indexPath];
    
    
    cell.productName.text = self.dataList[indexPath.row][@"pName"];
    cell.productNum.text = self.dataList[indexPath.row][@"pId"];
    
    NSString *rate = self.dataList[indexPath.row][@"pRate"];
    
    cell.productLevel.text = rate;
    
    if ([rate containsString:@"A"]) {
        cell.productColor.dk_imagePicker = DKImageWithNames(@"level_A", @"level_night_A");
    }
    else if ([rate containsString:@"B"])
    {
        cell.productColor.dk_imagePicker = DKImageWithNames(@"level_B", @"level_night_B");
    }
    else if ([rate containsString:@"C"])
    {
        cell.productColor.dk_imagePicker = DKImageWithNames(@"level_C", @"level_night_C");
    }
    else if ([rate containsString:@"D"])
    {
        cell.productColor.dk_imagePicker = DKImageWithNames(@"level_D", @"level_night_D");
    }
    else
    {
        cell.productColor.image = [UIImage imageNamed:@"collect_red"];
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                        Params:@{@"SID":@"01",
                                                 @"zqdm":self.dataList[indexPath.row][@"pId"]}
                                        completionBlock:^(id responseObject) {
                                            
                                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                            
                                            NSString *state = responseObject[@"state"];
                                            if ([state isEqualToString:@"0"]) {
                                                CBProductDetailController *productDetail = [[CBProductDetailController alloc] init];
                                                productDetail.infoDic = responseObject[@"dataList"][0];
                                                productDetail.zqdm = self.dataList[indexPath.row][@"pId"];
                                                [self.navigationController pushViewController:productDetail animated:YES];
                                            }
                                            else
                                            {
                                                [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                            }
                                            
                                        } failBlock:^(NSError *error) {
                                            
                                        }];
    
    
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-30)/2, 110);
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
