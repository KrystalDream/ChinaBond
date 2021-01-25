//
//  ADViewController.m
//  ChinaBond
//
//  Created by Krystal on 2021/1/11.
//  Copyright © 2021 chinaBond. All rights reserved.
//

#import "ADViewController.h"
#import "EAIntroView.h"
#import "CBPrivacyPolicyPopViewController.h"
#import "CBPrivacyWebViewController.h"
#import "RKTabBarViewController.h"

@interface ADViewController ()<EAIntroDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) EAIntroView *intro;

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //启动动画
    NSString *LaunchingGifName;
    if(IS_IPHONE_X_XR){
        LaunchingGifName = @"zhongzhai1_XR";
    }else{
        LaunchingGifName = @"zhongzhai1";
    }
    NSString *path=[[NSBundle mainBundle]pathForResource:LaunchingGifName ofType:@"gif"];
    NSMutableArray *array =[self praseGIFDataToImageArray:[NSData dataWithContentsOfFile:path]];
    self.iconImageView.animationImages = array; //动画图片数组
    self.iconImageView.animationDuration = 3.5; //执行一次完整动画所需的时长
    //gifImageView.animationRepeatCount = 999;  //动画重复次数
    [self.iconImageView startAnimating];
    
    dispatch_time_t adTime = dispatch_time(DISPATCH_TIME_NOW, 3.5*NSEC_PER_SEC);
    dispatch_after(adTime, dispatch_get_main_queue(), ^{
        
        [self.iconImageView removeFromSuperview];
        
        RKTabBarViewController *tab = [[RKTabBarViewController alloc] init];
        tab.tabBar.tintColor = UIColorFromRGB(0xff4e4e);
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
            
            //字体
            [[NSUserDefaults standardUserDefaults] setObject:@"100%" forKey:KWebFont];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //夜间模式
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KNightModel];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //自动下载
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KDownLoad];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
    //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            
            //引导页
            [self showIntroWithCrossDissolve];

        }
    });
}
//引导页
- (void)showIntroWithCrossDissolve {
    
    EAIntroPage *page1 = [EAIntroPage page];
    EAIntroPage *page2 = [EAIntroPage page];
    EAIntroPage *page3 = [EAIntroPage page];
    
    NSString *pageName1;
    NSString *pageName2;
    NSString *pageName3;

    if(IS_IPHONE_X_XR){
        pageName1 = @"icon_yindao_1_XR";
        pageName2 = @"icon_yindao_2_XR";
        pageName3 = @"icon_yindao_3_XR";

    }else{
        pageName1 = @"icon_yindao_1";
        pageName2 = @"icon_yindao_2";
        pageName3 = @"icon_yindao_3";
    }
    
    page1.bgImage = [UIImage imageNamed:pageName1];
    page2.bgImage = [UIImage imageNamed:pageName2];
    page3.bgImage = [UIImage imageNamed:pageName3];
    
    self.intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    self.intro.delegate = self;
    [self.intro showInView:[UIApplication sharedApplication].keyWindow animateDuration:0.0];
    
    //用户协议 弹窗
    [self PrivacyView];

}
//用户协议 弹窗
- (void)PrivacyView{
    [[CBPrivacyPolicyPopViewController shareInstance]initPrivacyViewWithTitle:@"用户须知" subTilte:@"欢迎使用中国债券信息网app！为了保护您的隐私和使用安全，请您务必仔细阅读我们的《用户协议》和《隐私政策》。在确认充分理解并同意后再开始使用此应用。感谢！" leftBtnTitle:@"退出" leftBtnBlock:^{
        
        if([self.delegate respondsToSelector:(@selector(privacyPolicyPopViewExit))]){
            [self.delegate privacyPolicyPopViewExit];
        }

    } rightBtnTitle:@"同意" BtnBlock:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];

    }];

    __weak __typeof(self)weakSelf = self;
    //[UIApplication sharedApplication].keyWindow.rootViewController
    [CBPrivacyPolicyPopViewController shareInstance].PrivacyClickBlock = ^(NSString* text) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        RKTabBarViewController *tab = (RKTabBarViewController *)window.rootViewController;
        UINavigationController *nav = tab.viewControllers[0];
        [CBPrivacyPolicyPopViewController shareInstance].view.alpha = 0;
        self.intro.alpha = 0;
        
        if([text isEqualToString:@"《用户协议》"]){

            CBPrivacyWebViewController *cs = [CBPrivacyWebViewController new];
            cs.CBPrivacyWebViewClickBlock = ^{
                [CBPrivacyPolicyPopViewController shareInstance].view.alpha = 1;
                weakSelf.intro.alpha = 1;

            };
            cs.localHtmlName =  @"user_agreement";
            cs.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:cs animated:YES];

        }else{
            CBPrivacyWebViewController *cs = [CBPrivacyWebViewController new];
            cs.CBPrivacyWebViewClickBlock = ^{
                [CBPrivacyPolicyPopViewController shareInstance].view.alpha = 1;
                weakSelf.intro.alpha = 1;
            };
            cs.localHtmlName = @"privacy_policy(1)";
            cs.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:cs animated:YES];
        }
    };
   
}
#pragma mark -EAIntroDelegate
- (void)introDidFinish{

}
-(NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;
{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
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
