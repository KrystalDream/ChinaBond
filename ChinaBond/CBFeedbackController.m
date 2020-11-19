//
//  CBFeedbackController.m
//  ChinaBond
//
//  Created by wangran on 15/12/14.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBFeedbackController.h"
#import "CBFeedSuccessView.h"

@interface CBFeedbackController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *feedTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHold;
@property (strong, nonatomic) IBOutlet UILabel *remindLab;
@property (strong, nonatomic) CBFeedSuccessView *feedSuccessView;
@end

@implementation CBFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x0f0f0f);
    self.title = @"意见反馈";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.feedTextView.layer.borderWidth = 1.0;
    self.feedTextView.layer.borderColor = UIColorFromRGB(0xbebfc3).CGColor;
    self.feedTextView.layer.cornerRadius = 5;
    
    self.feedSuccessView = [[CBFeedSuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.feedSuccessView.hidden = YES;
    [self.navigationController.view addSubview:self.feedSuccessView];
    
    self.placeHold.dk_textColorPicker = DKColorWithRGB(0xd4d4d4, 0x4c4c4c);
    self.feedTextView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x222222);
    self.remindLab.dk_textColorPicker = DKColorWithRGB(0x868686, 0x404040);
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        self.placeHold.hidden = YES;
    }
    else
    {
        self.placeHold.hidden = NO;
    }
    
    if (self.feedTextView.text.length > 300) {
        
        self.feedTextView.text = [self.feedTextView.text substringToIndex:300];
    }
    
    if (textView.markedTextRange == nil) {

        int num = 300;
        
        int lenght = (int)self.feedTextView.text.length;
        
        num = num-lenght;
        
        self.remindLab.text = [NSString stringWithFormat:@"剩余%d字",num];

        
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length==300) {
        ;
        return YES;
    }
    else
    {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick
{
    if (self.feedTextView.text.length == 0) {
        
        [MBProgressHUD bwm_showTitle:@"请填写反馈" toView:self.view hideAfter:2];
    }
    else
    {
        
         NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.feedSuccessView resignFirstResponder];
        [[CBHttpRequest shareRequest] getWithUrl:CBBaseUrl
                                              Params:@{@"SID":@"16",
                                                       @"sUserName":infoDic[@"userName"],
                                                       @"sContent":[self.feedTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]}
                                     completionBlock:^(id responseObject) {
                                         
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         
                                         NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
                                         if ([state isEqualToString:@"0"])
                                         {
                                             self.feedSuccessView.hidden = NO;
                                             [self performSelector:@selector(pushController) withObject:nil afterDelay:2];
                                         }
                                         else
                                         {
                                             [MBProgressHUD bwm_showTitle:responseObject[@"errorMsg"] toView:self.view hideAfter:2];
                                         }
                                         
                                     } failBlock:^(NSError *error) {
                                         
                                     }];
    }
}

- (void)pushController
{
    self.feedSuccessView.hidden = YES;
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

@end
