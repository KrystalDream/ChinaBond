//
//  CBAboutController.m
//  ChinaBond
//
//  Created by wangran on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBAboutController.h"

@interface CBAboutController ()

@property (strong, nonatomic) IBOutlet UILabel *aboutVersion;
@property (strong, nonatomic) IBOutlet UILabel *aboutConpanr;
@property (strong, nonatomic) IBOutlet UIImageView *iconAhout;

@end

@implementation CBAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于App";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xEBECF1, 0x0f0f0f);
    self.iconAhout.dk_imagePicker = DKImageWithNames(@"icon_about", @"icon_about_night");
    self.aboutVersion.dk_textColorPicker = DKColorWithRGB(0x868686, 0x737373);
    self.aboutConpanr.dk_textColorPicker = DKColorWithRGB(0xbebebe, 0x333333);
    
}
- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
