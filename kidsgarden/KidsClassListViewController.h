//
//  KidsClassSettingViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/23.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KidsClassListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property(nonatomic,strong)KidsService *content_service;
@property(nonatomic,strong)NSArray *grades;
@end
