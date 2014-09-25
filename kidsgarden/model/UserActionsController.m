//
//  UserActions.m
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import "UserActionsController.h"
#import "UserAction.h"
#import "KidsService.h"
static  UserActionsController *_sharedInstance=nil;
static dispatch_once_t once_token=0;

@implementation UserActionsController{
    NSMutableArray *marked_array;
    int window_width;
    NSURL *_fetchingURL;
    NSURLConnection *_fetchingConnection;
    NSMutableData *_receivedData;
    KidsService *_service;
}

@synthesize count;
+(UserActionsController *)sharedInstance{
    dispatch_once(&once_token,^{
        if(_sharedInstance==nil){
            _sharedInstance=[[UserActionsController alloc] init];
        }
    });
    return _sharedInstance;
}
- (id)init
{
    if( self=[super init] )
    {
        m_array=[self fechActions];
        if(m_array==nil){
          m_array = [[NSMutableArray alloc] init];
        }
        marked_array=[[NSMutableArray alloc] init];
        count = 0;
        window_width=50;
        _service=AppDelegate.content_service;
    }
    return self;
}
-(void)enqueueAReadAction:(KidsArticle *)article{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"3";
    action.action_description=[NSString stringWithFormat:@"%@",article.title];
    action.action_target=article.article_id;
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)enqueueARegisterAction:(NSString *)device{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"0";
    action.action_description=device;
    action.action_target=@"iOS";
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)enqueueAOpenAction{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"1";
    action.action_description=@"进入软件";
    action.action_target=@"0";
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)enqueueAEnrollmentAction:(KidsClass *)kidsclass{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"2";
    action.action_description=[NSString stringWithFormat:@"加入班级:%@",kidsclass.class_name];
    action.action_target=@"0";
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)enqueueACollecionAction:(KidsArticle *)article{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"5";
    action.action_description=[NSString stringWithFormat:@"%@",article.title];
    action.action_target=article.article_id;
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)enqueueAShareAction:(KidsArticle *)article{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"6";
    action.action_description=[NSString stringWithFormat:@"%@",article.title];
    action.action_target=article.article_id;
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)enqueueAUpdateAction:(NSString *)version{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"4";
    action.action_description=[NSString stringWithFormat:@"%@",version];
    action.action_target=version;
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)enqueueAGetPushAction:(KidsArticle *)article{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"7";
    action.action_description=[NSString stringWithFormat:@"%@",article.title];
    action.action_target=article.article_id;
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)enqueueACoverADAction:(NSString *)url{
    UserAction *action=[[UserAction alloc] init];
    action.action_type=@"8";
    action.action_description=[NSString stringWithFormat:@"%@",url];
    action.action_target=@"";
    action.action_time=[NSDate date];
    action.action_remark=@"";
    [self enqueue:action];
}
-(void)archiveActions:(NSMutableArray *)actions{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:actions];
    [[NSUserDefaults standardUserDefaults]   setObject:data  forKey:@"user_actions"];
}
-(NSMutableArray *)fechActions{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_actions"];
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray * actions=[[NSMutableArray alloc]initWithArray:array];;
    return actions;
}
- (void)enqueue:(UserAction *)anObject
{
    [m_array addObject:anObject];
    count = m_array.count;
    [self archiveActions:m_array];
}
-(void)reportActionsToServer{
    [_service reportActionsToServer:[self markToReport] succcessHander:^(BOOL isOK) {
        [self dequeueMarked];
    } errorHandler:^(NSError *error) {
        //<#code#>
    }];
}
- (NSString *)markToReport
{
    [marked_array removeAllObjects];
    for(int i=0;i<[m_array count]&&i<window_width;i++){
        UserAction *action=[m_array objectAtIndex:i];
        [marked_array addObject:action];
    }
    return [self buildReportJson:marked_array];
}
-(NSString *)buildReportJson:(NSArray *)array{
    NSMutableArray *items_arr=[[NSMutableArray alloc]init];
    NSTimeZone *zone=[NSTimeZone systemTimeZone];
    for(UserAction *action in array){
        NSInteger interval=[zone secondsFromGMTForDate:action.action_time];
        NSString *localDateString=[[[action.action_time dateByAddingTimeInterval:interval] description] substringToIndex:19];
        NSDictionary *item_dic=[NSDictionary dictionaryWithObjectsAndKeys:action.action_type,@"type",action.action_description,@"content",action.action_target,@"itemid",action.action_remark,@"remark",localDateString,@"time", nil];
        [items_arr addObject:item_dic];
    }
    NSDictionary* json_dic =[NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%d",[items_arr count]],
                                    @"count",
                                     items_arr,
                                     @"items",
                                    nil];
    __autoreleasing NSError *error=nil;
    id json_data=[NSJSONSerialization dataWithJSONObject:json_dic options:kNilOptions error:&error];
    if(error!=nil)return nil;    
    return [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
}
- (void)dequeueMarked
{
    [m_array removeObjectsInArray:marked_array];
    [marked_array removeAllObjects];
    count = [m_array count];
    [self archiveActions:m_array];
}

@end
