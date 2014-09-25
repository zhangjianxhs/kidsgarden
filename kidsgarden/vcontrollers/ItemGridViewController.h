//
//  KidsItemGridViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/12.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsHeaderView.h"
#import "KidsTouchEnrollView.h"
@interface ItemGridViewController : UIViewController<UICollectionViewDataSource,HeaderViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,TouchViewDelegate>
@property(nonatomic, strong)  UICollectionView *collectionView;
@property(nonatomic,strong)KidsHeaderView *headerView;
@property(nonatomic,strong)KidsTouchEnrollView *touchView;
@property(nonatomic,strong)KidsService *content_service;
@property(nonatomic,strong)KidsChannel *channel;
@property(nonatomic,strong)KidsArticle *header_item;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,assign)NSUInteger refresh_interval_minutes;
- (id)initWithChannel:(KidsChannel *)channel;
-(void)reloadDataFromDB;
-(void)reloadDataFromNET;
-(BOOL)isOld;
@end
