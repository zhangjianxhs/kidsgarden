//
//  KidsFavorViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/27.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KidsFavorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)KidsService *content_service;
@property(nonatomic,strong)NSMutableArray *items;
@end
