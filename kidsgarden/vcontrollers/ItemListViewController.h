#import <UIKit/UIKit.h>
#import "KidsTouchEnrollView.h"
#import "KidsHeaderView.h"
#import "KidsService.h"
@interface ItemListViewController : UIViewController<UITableViewDelegate,HeaderViewDelegate,TouchViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
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
