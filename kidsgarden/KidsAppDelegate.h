//
//  KidsAppDelegate.h
//  kidsgarden
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsDBManager.h"
#import "LeftMenuViewController.h"
#import "DrawerViewController.h"
#import <Frontia/Frontia.h>
@interface KidsAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)KidsService *content_service;
@property(nonatomic,strong)   DrawerViewController *main_vc;

@property(nonatomic,strong)FrontiaShare *share;


@end
