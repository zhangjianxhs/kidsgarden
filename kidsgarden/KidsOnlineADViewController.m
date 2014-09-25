//
//  KidsOnlineADViewController.m
//  kidsgarden
//
//  Created by apple on 14/7/31.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsOnlineADViewController.h"
#import "KidsNavigationController.h"
#import "UserActionsController.h"
@interface KidsOnlineADViewController ()

@end

@implementation KidsOnlineADViewController
@synthesize url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate=self;
    [self.view addSubview:self.webView];
    self.waitingView=[[KidsWaitingView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.waitingView];
    self.touchView=[[KidsTouchRefreshView alloc]initWithFrame:self.view.bounds];
    self.touchView.delegate=self;
    [self.view addSubview:self.touchView];
    [((KidsNavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self loadURL];
}
-(void)back{
   [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.touchView hide];
    [self.waitingView show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_waitingView hide];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_waitingView hide];
    [self.touchView show];
}
-(void)loadURL{
    [[UserActionsController sharedInstance] enqueueACoverADAction:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
-(void)clicked{
    [self loadURL];
}

@end
