//
//  KidsWelcomeViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/9.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KidsWelcomeViewController : UIViewController<UINavigationControllerDelegate>
@property(nonatomic,strong)ALImageView *coverimageView;
@property(nonatomic,strong)KidsService *content_service;
@property(nonatomic,assign)NSTimeInterval lasting_ms;
@end
