//
//  SUNListViewController.m
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-5.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import "ItemListViewController.h"
#import "KidsContentViewController.h"
#import "KidsClassListViewController.h"
#import "KidsDetailCell.h"
#import "KidsNotificationCell.h"
#import "MJRefresh.h"
#import "KidsMutiImageCell.h"
#import "KidsTableCellInterface.h"
#import "KidsNavigationController.h"
@implementation ItemListViewController{
    NSDate *_time_stamp;
    
}
@synthesize tableView=_tableView;
@synthesize headerView=_headerView;
@synthesize touchView=_touchView;
BOOL hasNotification;
- (id)initWithChannel:(KidsChannel *)channel
{
    self = [super init];
    if (self) {
        _content_service=AppDelegate.content_service;
        _refresh_interval_minutes=5;
        _items=[[NSMutableArray alloc] init];
        _time_stamp=[NSDate distantPast];
        _channel=channel;
        self.title=channel.name;
        hasNotification=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    self.touchView=[[KidsTouchEnrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.touchView.delegate=self;
    [self.view addSubview:self.touchView];
}
- (void)viewWillAppear:(BOOL)animated{
    [self reloadDataFromDB];
    if(self.channel.auth_type==AuthorizationRequired){
        NSString *class_id=[_content_service fetchClassIDFromLocal];
        if([class_id isEqual:@"0"]){
            [self.touchView show];
        }else{
            [self.touchView hide];
            
        }
    }
    if(self.channel.show_location==Left||self.channel.show_location==Notification)
        self.title=self.channel.nickname;
    else
        [AppDelegate.main_vc setTopTitle:self.channel.nickname];
    if([self isOld]){
        [self.tableView headerBeginRefreshing];
    }
}
- (void)setupTableView
{
    self.view.backgroundColor=[UIColor redColor];
    if(self.channel.show_location==Top)
        if(lessiOS7){
            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-kHeightOfTopScrollView)];
        }else{
            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20-kHeightOfTopScrollView)];
        }
    
    else{
        if(lessiOS7){
            NSLog(@"%f",self.view.bounds.size.height);
            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
        }else{
            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        }
        [((KidsNavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"title_menu_btn_normal.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.headerView=[[KidsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 160)];
    [self.headerView setArticle:self.header_item];
    self.headerView.delegate=self;
    [self.view addSubview:self.tableView];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
-(void)clicked{
[AppDelegate.main_vc presentClassListVCWithChannel:self.channel];
}
-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self reloadDataFromNET];
}

- (void)footerRereshing
{
    [self  loadMoreData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KidsArticle *item=[_items objectAtIndex:indexPath.row];
    return [item preferHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KidsArticle * article = [self.items objectAtIndex:indexPath.row];
[AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}
-(void)headerClicked:(KidsArticle *)article{
[AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}




-(void)reloadDataFromDB{
    [_items removeAllObjects];
    _header_item=[_content_service fetchHeaderArticleWithChannel:self.channel];
    NSString *exceptID=@"";
    if(_header_item!=nil){
        if(self.tableView.tableHeaderView==nil) self.tableView.tableHeaderView=[[KidsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 160)];
        [((KidsHeaderView *)self.tableView.tableHeaderView) setArticle:_header_item];
        ((KidsHeaderView *)self.tableView.tableHeaderView).delegate=self;
        exceptID=_header_item.article_id;
    }else{
        self.tableView.tableHeaderView=nil;
    }
    
    [_items addObjectsFromArray:[_content_service fetchArticlesWithChannel:self.channel exceptArticleID:exceptID topN:countPerPage*2]];
    
    if(self.channel.auth_type==AuthorizationRequired){
        KidsChannel *notificationChannel=[_content_service fetchNotificationChannelFromDB];
        if(notificationChannel!=nil){
            NSArray *articles=[_content_service fetchArticlesWithChannel:notificationChannel exceptArticleID:@"" topN:1];
            if([articles count]==1){
                [_items insertObject:articles[0] atIndex:0];
                hasNotification=YES;
            }
            
        }
    }
    [self.tableView reloadData];
    
}
-(void)reloadDataFromNET{
    _time_stamp=[NSDate date];
    [_content_service fetchArticlesFromNETWithChannelID:self.channel.channel_id pageIndex:0 successHandler:^(NSArray *articles) {
        [self reloadDataFromDB];
        [self.tableView headerEndRefreshing];
        [_content_service fetchToDeleteArtilceIDsWithChannelID:self.channel.channel_id succcessHander:^(BOOL hasDeleted) {
            if(hasDeleted){
                [self reloadDataFromDB];
            }
        } errorHandler:^(NSError *error) {
            //
        }];
    } errorHandler:^(NSError *error) {
        [self.tableView headerEndRefreshing];
    }];
}
-(void)loadMoreData{
    int pageIndex=[self.items count]/countPerPage+1;
    if(_header_item!=nil){
        pageIndex=([self.items count]+1)/countPerPage+1;
    }
    [_content_service fetchArticlesFromNETWithChannelID:self.channel.channel_id pageIndex:pageIndex successHandler:^(NSArray *articles) {
        int topN=[self.items count]+countPerPage;
        [_items removeAllObjects];
        [_items addObjectsFromArray:[_content_service fetchArticlesWithChannel:self.channel exceptArticleID:self.header_item.article_id topN:topN]];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    } errorHandler:^(NSError *error) {
        [self.tableView footerEndRefreshing];
    }];
}
-(BOOL)isOld{
    NSDate *now=[NSDate date];
    NSTimeInterval date1=[now timeIntervalSinceReferenceDate];
    NSTimeInterval date2=[_time_stamp timeIntervalSinceReferenceDate];
    long interval=date1-date2;
    if(interval>_refresh_interval_minutes*60){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - 表格视图数据源代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}
NSString *DetailCellID = @"DetailCellID";
NSString *MutiImageCellID=@"MutiImageCellID";
NSString *NotificationCellID=@"NotificationCellID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<KidsTableCellInterface> cell=nil;
    KidsArticle *article=[_items objectAtIndex:indexPath.row];
    if(self.channel.auth_type==AuthorizationRequired&&indexPath.row==0&&hasNotification){
        cell = [tableView dequeueReusableCellWithIdentifier:NotificationCellID];
        if(cell==nil){
            cell=[[KidsNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NotificationCellID];
        }
    }else{
        if(article.cover_images!=nil&&[article.cover_images count]>=3){
            cell = [tableView dequeueReusableCellWithIdentifier:MutiImageCellID];
            if(cell==nil){
                cell=[[KidsMutiImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MutiImageCellID];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:DetailCellID];
            if(cell==nil){
                cell=[[KidsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellID];
            }
        }
    }
    [cell setArticle:article];
    return (UITableViewCell *)cell;
}


@end
