//
//  KidsWelcomeViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/9.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsWelcomeViewController.h"
#import "LeftMenuViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "DrawerViewController.h"
#import "SlideSwitchViewController.h"
#import "KidsAppCoverImage.h"
#import "KidsNavigationController.h"

static const CGFloat kPublicLeftMenuWidth = 240.0f;
@interface KidsWelcomeViewController ()

@end
BOOL canEnter;
@implementation KidsWelcomeViewController{
    NSDate *_startup_time;
}
@synthesize coverimageView=_coverimageView;
@synthesize content_service=_content_service;
@synthesize lasting_ms=_lasting_ms;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.lasting_ms=5.0f;
        canEnter=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *defaultImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    if(self.view.bounds.size.height==568.0){
        defaultImageView.image=[UIImage imageNamed:@"Default~iphone.png"] ;
    }else{
        defaultImageView.image=[UIImage imageNamed:@"Default.png"] ;
    }
    [self.view addSubview:defaultImageView];
    
    
    _startup_time=[NSDate date];
    if([self isFirstStartup]){
        [self firstStartup];
    }else{
        [self setupCoverImage];
        [_content_service fetchAppCoverImageFromNet:^(KidsAppCoverImage *img) {
            //<#code#>
        } errorHandler:^(NSError *error) {
            //
        }];
        NSTimeInterval need_waiting_ms=_lasting_ms-[self consumedTime];
        if(need_waiting_ms>0){
            [self performSelector:@selector(enterMainViewController) withObject:nil afterDelay:need_waiting_ms];
        }else{
            [self enterMainViewController];
        }
    }
    UIButton *enterBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100,10,100,100)];
    [enterBtn setBackgroundImage:[UIImage imageNamed:@"skip.png"] forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterMainViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    // Do any additional setup after loading the view.
}
-(void)setupCoverImage{
    KidsAppCoverImage *img=[_content_service fetchAppCoverImage];
    if(![img isEmpty]){
        if(self.coverimageView==nil)
            self.coverimageView = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-100)];
        self.coverimageView.imageURL = img.url;
        [self.view  addSubview:self.coverimageView];
        self.coverimageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterMainViewController)];
        [self.coverimageView addGestureRecognizer:singleTap];
    }
}
-(void)showADArticle{
    
}
-(void)firstStartup{
    [_content_service registerDevice:^(BOOL isOK) {
        if(isOK){
            [_content_service fetchChannelsFromNET:^(NSArray *channels) {
                if([channels count]>0){
                    [self markFirstStartupSuccess];
                    NSTimeInterval need_waiting_ms=_lasting_ms-[self consumedTime];
                    if(need_waiting_ms>0){
                        [self performSelector:@selector(enterMainViewController) withObject:nil afterDelay:need_waiting_ms];
                    }else{
                        [self enterMainViewController];
                    }
                }else{
                    [self errorReport];
                }
            } errorHandler:^(NSError *error) {
               [self errorReport];
            }];
        }else{
            [self errorReport];
        }
    } errorHandler:^(NSError * error){
        [self errorReport];
    }];
}
-(void)errorReport{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"初始化错误，请检查网络稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    exit(0);
}
-(void)enterMainViewController{
  //  [self dismissViewControllerAnimated:YES completion:nil];
    if(!canEnter)return;
    canEnter=NO;
    SlideSwitchViewController *slideSwitchVC = [[SlideSwitchViewController alloc] init];
    AppDelegate.nav_slideswitch_vc = [[KidsNavigationController alloc] initWithRootViewController:slideSwitchVC];
    AppDelegate.nav_slideswitch_vc.delegate=slideSwitchVC;
    //初始化左侧菜单对象
    AppDelegate.left_menu_vc= [[LeftMenuViewController alloc]init];
    //初始化抽屉视图对象
    DrawerViewController * drawerController = [[DrawerViewController alloc]
                                               initWithCenterViewController:AppDelegate.nav_slideswitch_vc
                                               leftDrawerViewController: AppDelegate.left_menu_vc
                                               rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    AppDelegate.main_vc=drawerController;
    [self presentViewController:AppDelegate.main_vc animated:YES completion:nil];
}
-(BOOL)isFirstStartup{
    BOOL startuped=[[NSUserDefaults standardUserDefaults]  boolForKey:@"startuped"];
    return !startuped;
}
-(void)markFirstStartupSuccess{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"startuped"] ;
}
-(NSTimeInterval)consumedTime{
    NSDate *now=[NSDate date];
    NSTimeInterval date1=[now timeIntervalSinceReferenceDate];
    NSTimeInterval date2=[_startup_time timeIntervalSinceReferenceDate];
    NSTimeInterval interval=date1-date2;
    return interval;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
