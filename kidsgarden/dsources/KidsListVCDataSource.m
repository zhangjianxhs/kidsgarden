//
//  KidsSlideSwithDataSource.m
//  kidsgarden
//
//  Created by apple on 14-5-29.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsListVCDataSource.h"
#import "UIViewController+MMDrawerController.h"
#import "ItemListViewController.h"
#import "ItemGridViewController.h"
#import "KidsSettingViewController.h"
#import "KidsFavorViewController.h"
#import "KidsColors.h"
#import "KidsNavigationController.h"
@implementation KidsListVCDataSource{
    KidsColors *_colors;
}
@synthesize content_service=_content_service;
@synthesize slide_switch_view_controller=_slide_switch_view_controller;
@synthesize left_menu_table_view=_left_menu_table_view;
@synthesize leftChannelVCs=_leftChannelVCs;
@synthesize topChannelVCs=_topChannelVCs;
@synthesize currentVC=_currentVC;

-(id)init{
    if(self=[super init]){
        _content_service=AppDelegate.content_service;
        _leftChannelVCs=[[NSMutableArray alloc] init];
        _topChannelVCs=[[NSMutableArray alloc] init];
        _colors=[[KidsColors alloc]init];
    }
    return self;
}
-(void)reloadDataFromDB{
    [_topChannelVCs removeAllObjects];
    NSArray *topChannels=[_content_service fetchTopChannelsFromDB];
    for(KidsChannel *channel in topChannels){
        if(channel.show_type==Detail){
            ItemListViewController *ilvc=[[ItemListViewController alloc] initWithChannel:channel];
            [_topChannelVCs addObject:ilvc];
        }else{
            ItemGridViewController *igvc=[[ItemGridViewController alloc]initWithChannel:channel];
            [_topChannelVCs addObject:igvc];
        }
        
    }
    [_leftChannelVCs removeAllObjects];
    NSArray *leftChannels=[_content_service fetchLeftChannelsFromDB];
    for(KidsChannel *channel in leftChannels){
        UINavigationController  *left_vc;
        if(channel.show_type==Detail){
            ItemListViewController *ilvc=[[ItemListViewController alloc] initWithChannel:channel];
            left_vc = [[KidsNavigationController alloc] initWithRootViewController:ilvc];
        }else{
            ItemGridViewController *igvc=[[ItemGridViewController alloc]initWithChannel:channel];
            left_vc = [[KidsNavigationController alloc] initWithRootViewController:igvc];
        }
        [_leftChannelVCs addObject:left_vc];
    }
    self.leftChannelVCs=[self wrapLeftChannels:self.leftChannelVCs];
    [_left_menu_table_view reloadData];
}

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return [_topChannelVCs count];
}
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    UIViewController *currentVC=(UIViewController *)_topChannelVCs[number];
    return currentVC;
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    DrawerViewController *drawerController = (DrawerViewController *)_slide_switch_view_controller.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if([_topChannelVCs count]>0){
        self.currentVC=(UIViewController *)_topChannelVCs[number];
        [self.currentVC viewWillAppear:YES];
    }
}

-(NSMutableArray *)wrapLeftChannels:(NSArray *)channels{
    return [AppDelegate.main_vc appendOriginalChannels:channels];
}

#pragma mark - 表格视图数据源代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_leftChannelVCs count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)indexPath.row;
    NSString *LeftSideCellId = @"LeftSideCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LeftSideCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LeftSideCellId];
    }
    UIView *colorBar=[[UIView alloc]initWithFrame:CGRectMake(2,1,5,41)];
    [colorBar setBackgroundColor:[_colors getAColor]];
    [[cell contentView] addSubview:colorBar];
    UIViewController *vc=[_leftChannelVCs objectAtIndex:row];
    cell.textLabel.text=vc.title;
    [cell.textLabel setFont: [UIFont boldSystemFontOfSize:25]];
    if(row==0){
        cell.textLabel.text=@"首页";
    }
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    return  cell;
}

@end
