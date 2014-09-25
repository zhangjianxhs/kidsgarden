//
//  KidsContentViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/10.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsContentViewController.h"
#import "UIWindow+YzdHUD.h"
#import "KidsADView.h"
#import "KidsNavigationController.h"
#import "UserActionsController.h"
@interface KidsContentViewController (){
    KidsArticle *_article;
    KidsService *_service;
    KidsArticle * _adArticle;
    NSString *_pushArticleID;
    NSArray *fonts;
    int offset;
}
@property WebViewJavascriptBridge* bridge;
@end

@implementation KidsContentViewController
@synthesize waitingView=_waitingView;
@synthesize popupMenuView=_popupMenuView;
@synthesize fontAlertView=_fontAlertView;
@synthesize isAD=_isAD;
- (id)initWithAritcle:(KidsArticle *)article
{
    self = [super init];
    if (self) {
        _service=AppDelegate.content_service;
        _article=article;
        _isAD=NO;
        fonts=[NSArray arrayWithObjects:@"特大",@"较大",@"正常",@"较小",nil];

        if(lessiOS7){
            offset=44;
        }else{
            offset=0;
        }
    }
    return self;
}
-(id)initWithPushArticleID:(NSString *)articleID{
    self = [super init];
    if (self) {
        _service=AppDelegate.content_service;
        _pushArticleID=articleID;
        _isAD=NO;
        fonts=[NSArray arrayWithObjects:@"特大",@"较大",@"正常",@"较小",nil];
        
        if(lessiOS7){
            offset=44;
        }else{
            offset=0;
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate=self;
    [self.view addSubview:self.webView];
    if(!self.isAD)[self addOutsideAD];
    self.waitingView=[[KidsWaitingView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.waitingView];
    self.touchView=[[KidsTouchRefreshView alloc]initWithFrame:self.view.bounds];
    self.touchView.delegate=self;
    [self.view addSubview:self.touchView];
    [_service markArticleReadWithArticle:_article];
    if(_article==nil){
        [self loadPushArticleFromNet];
    }else{
        if(_article.content==nil){
            [self.waitingView show];
            [self loadArticleContentFromNet];
        }else{
            
            NSString *path=[[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
            [self initBridge];
        }
    }
    [((KidsNavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [((KidsNavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"ic_menu_normal.png"] target:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.fontAlertView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 240)];
    self.fontAlertView.titleName.text = @"选择字体大小";
    self.fontAlertView.web_delegate=self;
    [self.fontAlertView setSelectedFontSize:[_service getFontSize]];
    
    self.popupMenuView=[[KidsPopupMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.popupMenuView.delegate=self;
    self.popupMenuView.favor_status=_article.is_favor;
    NSLog(@"%d %d",_article.is_favor,self.popupMenuView.favor_status);
    [self.view addSubview:self.popupMenuView];
}
-(void)addOutsideAD{
    KidsChannel *channel_ad_outside=[_service fetchOutsideADChannelFromDB];
    if(channel_ad_outside!=nil){
        NSArray *articles_ad_outside=[_service fetchArticlesWithChannel:channel_ad_outside exceptArticleID:@"" topN:3];
        if(articles_ad_outside!=nil &&[articles_ad_outside count]>0){
            
            KidsADView * adView=[[KidsADView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-50-offset, self.view.bounds.size.width, 50) articles:articles_ad_outside];
            adView.delegate=self;
            self.webView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50-offset);
            [self.view addSubview:adView];
        }
    }
}
-(void)clickedWithArticle:(KidsArticle *)article{
    KidsContentViewController *controller=[[KidsContentViewController alloc] initWithAritcle:article];
    controller.isAD=YES;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)back{
    if(self.isAD)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)clicked{
    [self.touchView hide];
    [self.waitingView show];
    if(_article==nil){
        [self loadPushArticleFromNet];
    }else{
        [self loadArticleContentFromNet];
    }
}
-(void)loadPushArticleFromNet{
    [_service fetchPushArticleWithArticleID:_pushArticleID successHandler:^(KidsArticle *article) {
        _article=article;
        self.popupMenuView.favor_status=NO;
        NSString *path=[[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        [self initBridge];
        [self.waitingView hide];
    } errorHandler:^(NSError *error) {
        [self.waitingView hide];
        [self.touchView show];
    }];
}
-(void)loadArticleContentFromNet{    
    [_service fetchArticleContentFromNETWithArticle:_article  successHandler:^(KidsArticle *article) {
        _article=article;
        self.popupMenuView.favor_status=_article.is_favor;
        NSString *path=[[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        [self initBridge];
        [self.waitingView hide];
    } errorHandler:^(NSError *error) {
        [self.waitingView hide];
        [self.touchView show];
    }];
}
-(void)initBridge{
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    [_bridge registerHandler:@"getTitleCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        //NSLog(@"testObjcCallback called: %@", data);
        if(responseCallback)
            responseCallback(_article.title);
    }];
    [_bridge registerHandler:@"getPubTimeCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        //NSLog(@"testObjcCallback called: %@", data);
        if(responseCallback){
            NSString * pubtime=_article.pubish_time;
            if(pubtime==nil){
                pubtime=@"";
            }else{
                pubtime=[NSString stringWithFormat:@"时间：%@",_article.pubish_time ];
            }
            responseCallback(pubtime);
        }
    }];
    [_bridge registerHandler:@"getSourceCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        //NSLog(@"testObjcCallback called: %@", data);
        if(responseCallback){
            NSString * source=_article.source;
            if(source==nil){
                source=@"";
            }else{
                source=[NSString stringWithFormat:@"来源：%@",_article.source ];
            }
            responseCallback(source);
        }
    }];
    
    [_bridge registerHandler:@"getContentCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        //NSLog(@"testObjcCallback called: %@", data);
        if(responseCallback){
           responseCallback(_article.content);
            if(!self.isAD){
              [self appendInsideAD];
                
            }
        }
            
        
        //
    }];
    [_bridge registerHandler:@"openAd" handler:^(id data, WVJBResponseCallback responseCallback) {
        if(_adArticle){
            KidsContentViewController *controller=[[KidsContentViewController alloc] initWithAritcle:_adArticle];
            controller.isAD=YES;
           [self.navigationController pushViewController:controller animated:YES];
            
        }
    }];

}
-(void)appendInsideAD{
    KidsChannel *channel_ad=[_service fetchInsideADChannelFromDB];
    if(channel_ad!=nil){
        NSArray *ads=[_service fetchArticlesWithChannel:channel_ad exceptArticleID:@"" topN:1];
        if(ads!=nil && [ads count]>0){
            KidsArticle *article_ad=[ads objectAtIndex:0];
            if(article_ad.thumbnail_url!=nil&&![article_ad.thumbnail_url isEqual:@""]){
                _adArticle=article_ad;
                [_bridge callHandler:@"appendAd" data:article_ad.thumbnail_url];
            }
        }
        
    }
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_waitingView hide];
}
-(void)showMenu{
    [self.popupMenuView show];
}
-(void)favor{
    _article.is_favor=YES;
    [_service markArticleFavor:_article favor:YES];
    [self.view.window showHUDWithText:@"收藏成功" Type:ShowPhotoYes Enabled:YES];
}
-(void)unfavor{
    _article.is_favor=NO;
    [_service markArticleFavor:_article favor:NO];
    [self.view.window showHUDWithText:@"已取消收藏" Type:ShowPhotoYes Enabled:YES];
}
-(void)font{    
    [self.fontAlertView show];
}
-(void)changeWebContentFontSize:(NSString *)strFontSize webView:(UIWebView *)webView{
    if([strFontSize isEqualToString:@"特大"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"];
    }else if([strFontSize isEqualToString:@"较大"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'"];
    }else if([strFontSize isEqualToString:@"正常"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    }else if([strFontSize isEqualToString:@"较小"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'"];
    }
}
-(void)share{
    [[UserActionsController sharedInstance] enqueueAShareAction:_article];
    FrontiaShare *share = [Frontia getShare];
    
    [share registerQQAppId:@"100358052" enableSSO:NO];
    [share registerWeixinAppId:@"wx712df8473f2a1dbe"];
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
    };
    
    //授权成功回调函数
    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
        NSLog(@"OnResult: %@", [respones description]);
    };
    
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = _article.url;
    content.title = _article.title;
    content.description = _article.summary;
    content.imageObj = _article.thumbnail_url;
    
//    NSArray *platforms = @[FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQ,FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN,FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,FRONTIA_SOCIAL_SHARE_PLATFORM_SMS];
     NSArray *platforms = @[FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQ,FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN,FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,FRONTIA_SOCIAL_SHARE_PLATFORM_QQFRIEND,FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,FRONTIA_SOCIAL_SHARE_PLATFORM_SMS,FRONTIA_SOCIAL_SHARE_PLATFORM_COPY];
    [share showShareMenuWithShareContent:content displayPlatforms:platforms supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO targetViewForPad:self.view cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}
#pragma mark -


-(void)changeFontWithFontSize:(NSString *)fontSize{
    [self changeWebContentFontSize:fontSize webView:self.webView];
    [_service saveFontSize:fontSize];
}
@end
