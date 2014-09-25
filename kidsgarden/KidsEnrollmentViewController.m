//
//  KidsEnrollViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/23.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsEnrollmentViewController.h"
#import "UIWindow+YzdHUD.h"
#import "KidsNavigationController.h"
@interface KidsEnrollmentViewController ()
@property(nonatomic,strong)KidsService *service;
@end

@implementation KidsEnrollmentViewController
@synthesize kidsclass=_kidsclass;
@synthesize service=_service;
int height=40;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor whiteColor];
        _service=AppDelegate.content_service;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    self.title=@"加入班级";
    UIButton *left_btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [left_btn setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(lessiOS7){
        negativeSpacer.width=0;
    }else{
        negativeSpacer.width=-10;
    }
    UIBarButtonItem *left_btn_item=[[UIBarButtonItem alloc] initWithCustomView:left_btn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,left_btn_item,nil] animated:YES];
    
    UIButton *right_btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [right_btn setTitle:@"提交" forState:UIControlStateNormal];
    [right_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [right_btn setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [right_btn addTarget:self action:@selector(enroll) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer2=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(lessiOS7){
        negativeSpacer2.width=0;
    }else{
        negativeSpacer2.width=-10;
    }
    UIBarButtonItem *right_btn_item=[[UIBarButtonItem alloc] initWithCustomView:right_btn];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer2,right_btn_item,nil] animated:YES];
    

    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView
{
    self.view.backgroundColor=[UIColor redColor];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(20, 5, self.view.bounds.size.width-40, self.view.bounds.size.height-50)];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.scrollEnabled=NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    /*UIButton * btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(20, height*4, self.view.bounds.size.width-40, 44);
    if(lessiOS7){
        btn.backgroundColor=[UIColor whiteColor];
    }else{
        btn.backgroundColor=[UIColor colorWithRed:30.0/255 green:144.0/255 blue:255.0/255 alpha:1.0];
    }
    
    btn.tintColor=[UIColor whiteColor];
    [btn setTitle:@"加入班级" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(enroll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];*/

}


-(void)enroll{
    [self closeKeyboard];
    NSIndexPath *name_index=[NSIndexPath indexPathForRow:2 inSection:0];
    NSString *name=((UITextField *)[[self.tableView cellForRowAtIndexPath:name_index] viewWithTag:123]).text;
    NSIndexPath *phone_index=[NSIndexPath indexPathForRow:3 inSection:0];
    NSString *phone=((UITextField *)[[self.tableView cellForRowAtIndexPath:phone_index] viewWithTag:123]).text;
    [self.view.window showHUDWithText:@"正在处理" Type:ShowLoading Enabled:YES];
    [_service  enrollViaNETWithUsername:name phone:phone kidsclass:self.kidsclass successHandler:^(BOOL isOK) {
        if(isOK){
            [self.view.window showHUDWithText:@"加入班级成功" Type:ShowPhotoYes Enabled:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.view.window showHUDWithText:@"加入班级失败" Type:ShowPhotoNo Enabled:YES];
        }
    } errorHandler:^(NSError * error) {
        [_service saveUserInfo:name userphone:phone classid:@"0"];
        [self.view.window showHUDWithText:@"加入班级失败" Type:ShowPhotoNo Enabled:YES];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(void)closeKeyboard{
    UITextField *tf1=(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] viewWithTag:123];
    [tf1 resignFirstResponder];
    UITextField *tf2=(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] viewWithTag:123];
    [tf2 resignFirstResponder];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EnrollViewCellID=@"EnrollViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EnrollViewCellID];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EnrollViewCellID];
    }
    
    int labelWidth=100;
    int textWidth=180;
    if(indexPath.row==0){
        UILabel *tipText=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, labelWidth, height)];
        tipText.text=@"幼儿园";
        UILabel *input=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, textWidth, height)];
        input.tag=123;
        [input setText:kindergarten_name];
        [[cell contentView] addSubview:tipText];
        [[cell contentView]addSubview:input];
    }else if(indexPath.row==1){
        UILabel *tipText=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, labelWidth, height)];
        tipText.text=@"班级";
        UILabel *input=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, textWidth, height)];
        input.tag=123;
        [input setText:self.kidsclass.class_name];
        [[cell contentView] addSubview:tipText];
        [[cell contentView]addSubview:input];
    }else if(indexPath.row==2){
        UILabel *tipText=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, labelWidth, height)];
        tipText.text=@"姓名";
        UITextField *input=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, textWidth, height)];
        input.tag=123;
        input.borderStyle = UITextBorderStyleRoundedRect;
         input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [input setText:[_service fetchUserNameFromLocal]];
        [[cell contentView] addSubview:tipText];
        [[cell contentView]addSubview:input];
    }else if(indexPath.row==3){
        UILabel *tipText=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, labelWidth, height)];
        tipText.text=@"手机号";
        UITextField *input=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, textWidth, height)];
        input.tag=123;
        input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        [input setText:[_service fetchUserPhoneFromLocal]];
        input.borderStyle = UITextBorderStyleRoundedRect;
        input.keyboardType=UIKeyboardTypePhonePad;
        [[cell contentView] addSubview:tipText];
        [[cell contentView]addSubview:input];
    }
    cell.selectionStyle=NO;
    
    return cell;
}
//设置rowHeight
/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return height+5;
}*/


@end
