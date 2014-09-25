//
//  KidsSlideSwithDataSource.h
//  kidsgarden
//
//  Created by apple on 14-5-29.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUNSlideSwitchView.h"
#import "ItemListViewController.h"
#import "DrawerViewController.h"
@interface KidsListVCDataSource : NSObject<SUNSlideSwitchViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)KidsService *content_service;
@property(nonatomic,strong)UIViewController *slide_switch_view_controller;
@property(nonatomic,strong)UITableView *left_menu_table_view;
@property(nonatomic,strong)NSMutableArray *leftChannelVCs;
@property(nonatomic,strong)NSMutableArray *topChannelVCs;
@property(nonatomic,strong)UIViewController *currentVC;
-(void)reloadDataFromDB;
@end
