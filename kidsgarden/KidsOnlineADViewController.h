//
//  KidsOnlineADViewController.h
//  kidsgarden
//
//  Created by apple on 14/7/31.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsWaitingView.h"
#import "KidsTouchRefreshView.h"
@interface KidsOnlineADViewController : UIViewController<UIWebViewDelegate,TouchViewDelegate>
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)KidsWaitingView *waitingView;
@property(nonatomic,strong)KidsTouchRefreshView *touchView;
@end
