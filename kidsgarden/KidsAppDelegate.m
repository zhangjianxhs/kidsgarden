//
//  KidsAppDelegate.m
//  kidsgarden
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsAppDelegate.h"
#import "LeftMenuViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "DrawerViewController.h"
#import "SlideSwitchViewController.h"
#import "UserActionsController.h"
#import "KidsNavigationController.h"
#import <Frontia/FrontiaPush.h>
#import <Frontia/Frontia.h>
#import "iVersion.h"
@implementation KidsAppDelegate
@synthesize content_service=_content_service;
@synthesize  share=_share;
#define DeviceTokenRegisteredKEY @"DeviceTokenStringKEY"
#define DeviceTokenStringKEY @"DeviceTokenStringKEY"
+ (void)initialize
{
    [iVersion sharedInstance].appStoreID = 908566596;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Frontia initWithApiKey:APP_KEY];
    [Frontia getPush];
    [FrontiaPush setupChannel:launchOptions];
    [self setupApp];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.main_vc];
    [self.window makeKeyAndVisible];
    if (launchOptions) {
        //截取apns推送的消息
        NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        [self.main_vc presentArticleContentVCWithPushArticleID:[pushInfo valueForKey:@"id"]];
    }
    [self performSelectorInBackground:@selector(initBaiduFrontia) withObject:nil];
    return YES;
}
-(void)setupApp{
    self.content_service=[[KidsService alloc] init];
    AppDelegate.main_vc=[[DrawerViewController alloc] init];

}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)initBaiduFrontia{
    self.share=[Frontia getShare];
    [self.share registerQQAppId:@"100358052" enableSSO:NO];
    [self.share registerWeixinAppId:@"wx712df8473f2a1dbe"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //每次醒来都需要去判断是否得到device token
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
    
    [[UserActionsController sharedInstance] enqueueAOpenAction];
    [[UserActionsController sharedInstance] reportActionsToServer];
    [_content_service fetchFoundationalDataFromNET:^(BOOL success) {
        NSLog(@"%d",success);
    } errorHandler:^(NSError *error) {
        //<#code#>
    }];
}

//向服务器申请发送token 判断事前有没有发送过
- (void)registerForRemoteNotificationToGetToken
{
    NSLog(@"Registering for push notifications...");
    
    //注册Device Token, 需要注册remote notification
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if (![userDefaults boolForKey:DeviceTokenRegisteredKEY])   //如果没有注册到令牌 则重新发送注册请求
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeNewsstandContentAvailability |
              UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
              UIRemoteNotificationTypeSound)];
        });
    }
    
    //将远程通知的数量置零
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //1 hide the local badge
        if ([[UIApplication sharedApplication] applicationIconBadgeNumber] == 0) {
            return;
        }
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        //2 ask the provider to set the BadgeNumber to zero
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *deviceTokenStr = [userDefaults objectForKey:DeviceTokenStringKEY];
        [self resetBadgeNumberOnProviderWithDeviceToken:deviceTokenStr];
    });
    
}
- (void)resetBadgeNumberOnProviderWithDeviceToken: (NSString *)deviceTokenString
{
    NSLog(@"  reset Provider DeviceToken %@", deviceTokenString);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"frontia application:%@", deviceToken);
       [_content_service registerBaiduPushToken:deviceToken];
    [_content_service bindBaiduChannel];
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSLog(@"%@",@"注册通知失败！！！！！！！！！");
    NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ?
                        @"Notifications were active for this application" :
                        @"Remote notifications were not active for this application", [error localizedDescription]];
    NSLog(@"Error in registration. Error: %@", error);
	NSLog(@"status = %@",status);
    NSLog(@"%@",@"注册通知失败！！！！！！！！！");
}
KidsArticle *push_article;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if([UIApplication sharedApplication].applicationState==UIApplicationStateInactive){
        [self.main_vc presentArticleContentVCWithPushArticleID:[userInfo valueForKey:@"id"]];
    }else{
        [_content_service fetchPushArticleWithArticleID:[userInfo valueForKey:@"id"] successHandler:^(KidsArticle *article) {
            push_article=article;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:article.title  message:article.summary delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"点击阅读", nil];
        
            [alertView show];
        } errorHandler:^(NSError *error) {
           // <#code#>
        }];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self.main_vc presentArtilceContentVCWithArticle:push_article channel:nil];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
