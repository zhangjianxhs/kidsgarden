#import "LeftMenuViewController.h"
#import "KidsColors.h"
#import "KidsNavigationController.h"
#import "ItemListViewController.h"
#import "ItemGridViewController.h"
@interface LeftMenuViewController ()
@property(nonatomic,strong)NSMutableArray *leftChannelVCs;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)KidsService *service;
@end

@implementation LeftMenuViewController{
    KidsColors *_colors;
}
@synthesize leftChannelVCs;
@synthesize tableView;
@synthesize service;
#pragma mark - 控制器初始化方法
- (id)init
{
    self = [super init];
    if (self) {
        self.service=AppDelegate.content_service;
        self.leftChannelVCs=[[NSMutableArray alloc] init];
        _colors=[[KidsColors alloc]init];
    }
    return self;
}

#pragma mark - 控制器方法

#pragma mark - 视图加载方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    
    self.title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width, 30)];
    self.title_label.textColor=[UIColor grayColor];
    self.title_label.text=@"蓝天幼儿园";
    self.title_label.font = [UIFont fontWithName:@"Arial" size:20];
    self.title_label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.title_label];

    self.sub_title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width, 20)];
    self.sub_title_label.textColor=[UIColor grayColor];
    self.sub_title_label.text=@"爱亲子";
    self.sub_title_label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.sub_title_label];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 80, 300, self.view.bounds.size.height-44)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView setScrollEnabled:NO];
    [self.view addSubview:self.tableView];
    [self rebuildUI];
    UIImageView *pandaView=[[UIImageView alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height-125, 120, 120)];
    pandaView.image=[UIImage imageNamed:@"panda.jpg"] ;
    [self.view addSubview:pandaView];
}
-(void)rebuildUI{
    [self.leftChannelVCs removeAllObjects];
    NSArray *leftChannels=[self.service fetchLeftChannelsFromDB];
    for(KidsChannel *channel in leftChannels){
        UINavigationController  *left_vc;
        if(channel.show_type==Detail){
            ItemListViewController *ilvc=[[ItemListViewController alloc] initWithChannel:channel];
            left_vc = [[KidsNavigationController alloc] initWithRootViewController:ilvc];
        }else{
            ItemGridViewController *igvc=[[ItemGridViewController alloc]initWithChannel:channel];
            left_vc = [[KidsNavigationController alloc] initWithRootViewController:igvc];
        }
        [self.leftChannelVCs addObject:left_vc];
    }
    self.leftChannelVCs=[self wrapLeftChannels:self.leftChannelVCs];
    [self.tableView reloadData];
}
-(NSMutableArray *)wrapLeftChannels:(NSArray *)channels{
    return [AppDelegate.main_vc appendOriginalChannels:channels];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc= [self.leftChannelVCs objectAtIndex:indexPath.row];
    [AppDelegate.main_vc setCenterViewController:vc
                              withCloseAnimation:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.leftChannelVCs count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)indexPath.row;
    NSString *LeftSideCellId = @"LeftSideCellId";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LeftSideCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LeftSideCellId];
    }
    UIView *colorBar=[[UIView alloc]initWithFrame:CGRectMake(2,1,5,41)];
    [colorBar setBackgroundColor:[_colors getAColor]];
    [[cell contentView] addSubview:colorBar];
    UIViewController *vc=[self.leftChannelVCs objectAtIndex:row];
    cell.textLabel.text=vc.title;
    [cell.textLabel setFont: [UIFont boldSystemFontOfSize:25]];
    if(row==0){
        cell.textLabel.text=@"首页";
    }
    cell.textLabel.textColor=[UIColor blackColor];
    cell.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    return  cell;
}


@end
