//
//  KidsEnrollViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/23.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsClass.h"
@interface KidsEnrollmentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)KidsClass *kidsclass;
@end
