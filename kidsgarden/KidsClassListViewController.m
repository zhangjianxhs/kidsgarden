//
//  KidsClassSettingViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/23.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsClassListViewController.h"
#import "KidsEnrollmentViewController.h"
#import "KidsClassCell.h"
#import "KidsGradeHeaderView.h"
#import "KidsNavigationController.h"

@interface KidsClassListViewController ()
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSString *selected_class_id;
@end
#define invalid_index [NSIndexPath indexPathForRow:100 inSection:100]
@implementation KidsClassListViewController
@synthesize content_service=_content_service;
@synthesize grades=_grades;
@synthesize collectionView=_collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _content_service=AppDelegate.content_service;
        _grades=[[NSMutableArray alloc]init];
        self.indexPath=invalid_index;
   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"班级列表";
    self.selected_class_id=[_content_service fetchClassIDFromLocal];
    [self setupCollectionView];
    [self loadClassListFromNET];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    if([self.indexPath row]!=100){
        [self.collectionView selectItemAtIndexPath:self.indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}
-(void)setupCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(100, 60);
    flowLayout.minimumLineSpacing=5;
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.headerReferenceSize=CGSizeMake(320, 30);
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[KidsClassCell class] forCellWithReuseIdentifier:@"KidsClassCell"];
    [self.collectionView registerClass:[KidsGradeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.0];
    [self.view addSubview:self.collectionView];
    [((KidsNavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadClassListFromNET{
    [_content_service fetchClassListFromNET:^(NSArray *classes) {
        _grades=[NSMutableArray arrayWithArray:classes];
        [self.collectionView reloadData];
        
    } errorHandler:^(NSError *error) {
      //  <#code#>
    }];
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KidsEnrollmentViewController *controller=[[KidsEnrollmentViewController alloc] init];
    controller.kidsclass=[((KidsGrade *)[_grades objectAtIndex:indexPath.section]).classes objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [((KidsGrade *)[_grades objectAtIndex:section]).classes count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_grades count];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview=nil;
    if(kind==UICollectionElementKindSectionHeader){
        KidsGradeHeaderView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            if([_grades count]>0)
            [headerView setGrade:[_grades objectAtIndex:indexPath.section]];
        reusableview=headerView;
    }
    return reusableview;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KidsClassCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KidsClassCell" forIndexPath:indexPath];
    KidsClass *class=[((KidsGrade *)[_grades objectAtIndex:indexPath.section]).classes objectAtIndex:indexPath.row];
    [cell setClass:class];
    if([class.class_id isEqualToString:self.selected_class_id]){
        self.indexPath=indexPath;
    }
    return cell;
}
@end
