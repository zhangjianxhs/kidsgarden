//
//  KidsContentViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/10.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "KidsService.h"
#import "KidsWaitingView.h"
#import "KidsPopupMenuView.h"
#import "ZSYPopoverListView.h"
#import "KidsTouchRefreshView.h"
#import "KidsArticleViewDelegate.h"
@interface KidsContentViewController : UIViewController<UIWebViewDelegate,PopupMenuDelegate,FontAlertDelegate,TouchViewDelegate,KidsArticleViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)KidsWaitingView *waitingView;
@property(nonatomic,strong)KidsTouchRefreshView *touchView;
@property(nonatomic,strong)KidsPopupMenuView *popupMenuView;
@property(nonatomic,strong)ZSYPopoverListView *fontAlertView;

@property(nonatomic,assign)BOOL isAD;
- (id)initWithAritcle:(KidsArticle *)article;
-(id)initWithPushArticleID:(NSString *)articleID;
@end
