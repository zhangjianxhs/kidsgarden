
//
//  KidsDownloadingService.m
//  kidsgarden
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 ikid. All rights reserved.
//
#import <sys/utsname.h>
#import "KidsService.h"
#import "KidsChannel.h"
#import "KidsArticle.h"
#import "UserActionsController.h"
#import "KidsAppCoverImage.h"
#define url_prefix @"http://182.92.10.72/Api/Kindergarten/"
#define reg_url @"reg_device?imei=%@&kindergartenid=%@&device_model=%@&os=%@&app_version=%@"
#define puh_url @"bind_push?imei=%@&kindergartenid=%@&appid=%@&userid=%@&channelid=%@"
#define startup_image_url @"startup_image?imei=%@&kindergartenid=%@"
#define channel_list_url @"get_columns?imei=%@&kindergartenid=%@"
#define article_list_url @"get_articles?imei=%@&kindergartenid=%@&classid=%@&columnid=%@&pageindex=%d&cntperpage=%d"
#define artilce_content_url @"get_article_content?imei=%@&articleid=%@"
#define push_article_url @"get_article_by_id?imei=%@&articleid=%@"
#define class_list_url @"get_classes?imei=%@&kindergartenid=%@"
#define enroll_class_url @"select_class?imei=%@&kindergartenid=%@&classid=%@&phone=%@&username=%@"
#define delete_url @"get_delete_ids?imei=%@&kindergartenid=%@&columnid=%@&aftertime=%@"
#define upload_log_url @"log"


@implementation KidsService
@synthesize communicator=_communicator;
@synthesize db_manager=_db_manager;
@synthesize parser=_parser;
-(id)init{
    if(self=[super init]){
        self.communicator=[[KidsServerCommunicator alloc]init];
        self.db_manager=[[KidsDBManager alloc] init];
        self.parser=[[KidsJSONParser alloc] init];
    }
    return self;
}
-(void)fetchPushArticleWithArticleID:(NSString *)articleID successHandler:(void(^)(KidsArticle *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:push_article_url,[KidsOpenUDID value],articleID]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * jsonString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error=nil;
            KidsArticle *article=[_parser pushArticleFromJSON:jsonString error:&error];
            KidsDBOperator *db_operator=[_db_manager aOperator];
            [db_operator addArticle:article];
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(article);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)registerBaiduPushToken:(NSData *)deviceToken{
    NSLog(@"frontia application:%@", deviceToken);
    [FrontiaPush registerDeviceToken:deviceToken];
}
-(void)bindBaiduChannel{
    FrontiaPush *push=[Frontia getPush];
    [push bindChannel:^(NSString *appId, NSString *userId, NSString *channelId) {
        NSString *message = [[NSString alloc] initWithFormat:@"appid:%@ userid:%@ channelID:%@", appId, userId, channelId];
        
//        self.appidText.text = appId;
//        self.useridText.text = userId;
//        self.channelidText.text = channelId;
        
    } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
        
        NSString *message = [[NSString alloc] initWithFormat:@"string is %@ error code : %d error message %@", action, errorCode, errorMessage];
    }];
}
-(NSArray *)fetchLeftChannelsFromDB{
    NSArray * channels=[[_db_manager aOperator] fetchLeftChannels];
    NSMutableArray *res=[[NSMutableArray alloc]init];
    for (KidsChannel* ch in channels) {
            [res addObject:ch];
    }
    return res;
}
-(NSArray *)fetchTopChannelsFromDB{
    NSArray * channels=[[_db_manager aOperator] fetchTopChannels];
    NSMutableArray *res=[[NSMutableArray alloc]init];
    for (KidsChannel* ch in channels) {
       [res addObject:ch];
    }
    return res;
}
-(KidsChannel* )fetchInsideADChannelFromDB{
    KidsChannel* channel=[[_db_manager aOperator] fetchADInContentChannel];
    return channel;
}
-(KidsChannel* )fetchOutsideADChannelFromDB{
    KidsChannel* channel=[[_db_manager aOperator] fetchADOutOfContentChannel];
    return channel;
}
-(KidsChannel *)fetchNotificationChannelFromDB{
    KidsChannel* channel=[[_db_manager aOperator] fetchNotificationChannel];
    return channel;
}
-(void)markArticleFavor:(KidsArticle *)article favor:(BOOL)favor{
    if(favor){
        [[UserActionsController sharedInstance] enqueueACollecionAction:article];
    }
    KidsDBOperator *db_operator=[_db_manager aOperator];
    [db_operator markArticleFavorWithArticleID:article.article_id favor:favor];
    [db_operator save];
    
}
-(void)markArticleReadWithArticle:(KidsArticle *)article{
    [[UserActionsController sharedInstance] enqueueAReadAction:article];
    KidsDBOperator *db_operator=[_db_manager aOperator];
    [db_operator markArticleReadWithArticleID:article.article_id];
    [db_operator save];
}
-(KidsArticle *)fetchHeaderArticleWithChannel:(KidsChannel *)channel{
    return [[_db_manager aOperator] fetchHeaderArticleWithChannel:channel];
}
-(NSArray *)fetchFavorArticlesFromDB{
    NSArray *articles=[[_db_manager aOperator] fetchFavorArticles];
    return articles;
}
-(NSArray *)fetchArticlesWithChannel:(KidsChannel *)channel exceptArticleID:(NSString *)exceptArticleID topN:(int)topN{
    NSArray *articles=[[_db_manager aOperator] fetchMutiCoverImageArticlesWithChannel:channel topN:2];
    NSMutableArray *array_ids=[[NSMutableArray alloc] init];
    for(KidsArticle *article in articles){
        [array_ids addObject:article.article_id];
    }
    if(exceptArticleID!=nil&&![exceptArticleID isEqual:@""]){
        [array_ids insertObject:exceptArticleID atIndex:0];
    }
   NSArray * articles_only_thumail=[[_db_manager aOperator] fetchArticlesWithChannel:channel exceptArticleID:array_ids topN:topN];
    NSMutableArray *res=[[NSMutableArray alloc] init];
    [res addObjectsFromArray:articles_only_thumail];
    if(articles!=nil&&[articles count]>0){
        if([res count]>=5)
             [res insertObject:articles[0] atIndex:5];
        else
            [res addObject:articles[0]];
    }
    if(articles!=nil&&[articles count]>1){
        if([res count]>=10)
            [res insertObject:articles[1] atIndex:10];
        else
            [res addObject:articles[1]];
        
    }
    return res;
}
-(void)reportActionsToServer:(NSString *)postJSON succcessHander:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:[KidsOpenUDID value],@"imei",kindergartenid,@"kindergartenid",postJSON,@"json",nil];
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,upload_log_url];
    [_communicator postJSONToServerAtURL:url parameters:parameters successHandler:^(NSDictionary *response) {
        NSError *error=nil;
        BOOL isOK=[_parser invalidateJSONWith:response error:&error];
        if(successBlock){
            successBlock(isOK);
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
    
}
-(void)fetchFoundationalDataFromNET:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    //获取所有栏目
    [self fetchChannelsFromNET:^(NSArray *channels) {
        //获取硬广告内容
        KidsChannel *channel_ad_outsider=[self fetchOutsideADChannelFromDB];
        if(channel_ad_outsider==nil)return;
        [self fetchArticlesFromNETWithChannelID:channel_ad_outsider.channel_id pageIndex:0 successHandler:^(NSArray *articles) {
            //获取推广广告内容
            KidsChannel *channel_ad_insider=[self fetchInsideADChannelFromDB];
            if(channel_ad_insider==nil)return;
            [self fetchArticlesFromNETWithChannelID:channel_ad_insider.channel_id pageIndex:0 successHandler:^(NSArray *articles) {
                //获取启动图
                [self fetchAppCoverImageFromNet:^(KidsAppCoverImage *img) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(successBlock){
                            successBlock(YES);
                        }
                    });
                } errorHandler:^(NSError *error) {
                    if(errorBlock){
                        errorBlock(error);
                    }
                }];
            } errorHandler:^(NSError *error) {
                if(errorBlock){
                    errorBlock(error);
                }
            }];
        } errorHandler:^(NSError *error) {
            if(errorBlock){
                errorBlock(error);
            }
        }];
        
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}

-(void)fetchChannelsFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:channel_list_url,[KidsOpenUDID value], kindergartenid]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary *jsonString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error=nil;
            NSArray *channels=[_parser channelsFromJSON:jsonString error:&error];
            KidsDBOperator *db_operator=[_db_manager aOperator];
            if([channels count]>0){
                [db_operator removeAllChannels];
            }
            [db_operator save];
            for(KidsChannel *channel in channels){
                [db_operator addChannel:channel];
            }
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(channels);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchArticlesFromNETWithChannelID:(NSString *)channelID pageIndex:(int)pageIndex successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:article_list_url,[KidsOpenUDID value], kindergartenid,[self fetchClassIDFromLocal],channelID,pageIndex,countPerPage]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * jsonString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error=nil;
            NSArray *articles=[_parser articlesFromJSON:jsonString error:&error];
            KidsDBOperator *db_operator=[_db_manager aOperator];
            for(KidsArticle *article in articles){
                article.channel_id=channelID;
                [db_operator addArticle:article];
            }
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(articles);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchArticleContentFromNETWithArticle:(KidsArticle *)article successHandler:(void(^)(KidsArticle *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:artilce_content_url,[KidsOpenUDID value], article.article_id]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * jsonString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error=nil;
            KidsArticleContent *content=[_parser articleContentFromJSON:jsonString error:&error];
            KidsDBOperator *db_operator=[_db_manager aOperator];
            [db_operator updateArticleContentWithArticle:article articleContent:content];
            [db_operator save];
            article.content=content.content;
            article.images=content.pics;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(article);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)registerDevice:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:reg_url,[KidsOpenUDID value], kindergartenid,[self phoneModel],[self osVersion], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
        NSError *error=nil;
        BOOL isOK=[_parser invalidateJSONWith:response error:&error];
        if(successBlock){
            [[UserActionsController sharedInstance] enqueueARegisterAction:[NSString stringWithFormat:@"%@ iOS %@",[self phoneModel],[self osVersion]]];
            successBlock(isOK);
        }
        
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchToDeleteArtilceIDsWithChannelID:(NSString *)channelID succcessHander:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *imei=[KidsOpenUDID value];
    NSString *timeStamp=[self getDeleteTimeStamp];
    NSString *tempURL=[NSString stringWithFormat:delete_url,imei,kindergartenid,channelID,timeStamp ];
    NSString *url=[[NSString stringWithFormat:@"%@%@",url_prefix,tempURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
        NSError *error=nil;
        NSArray *articleIDs=[_parser toDeleteArticleIDsFromJSON:response error:&error];
        if(!error){
            [self saveDeleteTimeStamp];
        }
        KidsDBOperator *db_operator=[_db_manager aOperator];
        BOOL hasDeleted=[db_operator deleteArticleWithArticleIDs:articleIDs];
        [db_operator save];
        if(successBlock){
            successBlock(hasDeleted);
        }
        
    } errorHandler:^(NSError *error) {
    if(errorBlock){
        errorBlock(error);
    }
     }];
    
}
-(void)fetchClassListFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:class_list_url,[KidsOpenUDID value],kindergartenid]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
         NSError *error=nil;
        NSArray *grades=[_parser gradesFromJSON:response error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(successBlock){
                successBlock(grades);
            }
        });
        
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)enrollViaNETWithUsername:(NSString *)username phone:(NSString *)phone kidsclass:(KidsClass *)kidsclass successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *tempURL=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:enroll_class_url,[KidsOpenUDID value],kindergartenid,kidsclass.class_id,phone,username]];
    NSString *url=[tempURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
        NSError *error=nil;
        BOOL isOK=[_parser invalidateJSONWith:response error:&error];
        if(isOK){
            NSString *old_class_id=[self fetchClassIDFromLocal];
            FrontiaPush *push=[Frontia getPush];
            [push delTag:old_class_id tagOpResult:^(int count, NSArray *failureTag) {
               // <#code#>
            } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
              //  <#code#>
            }];
            [push setTag:[NSString stringWithFormat:@"%@",kidsclass.class_id] tagOpResult:^(int count, NSArray *failureTag) {
               // <#code#>
            } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
              //  <#code#>
            }];
            [self saveUserInfo:username userphone:phone classid:kidsclass.class_id];
            [[UserActionsController sharedInstance] enqueueAEnrollmentAction:kidsclass];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(successBlock){
                successBlock(isOK);
            }
        });
        
    } errorHandler:^(NSError *error) {
        [self saveUserInfo:username userphone:phone classid:@"0"];
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchAppCoverImageFromNet:(void(^)(KidsAppCoverImage *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:startup_image_url,[KidsOpenUDID value],kindergartenid]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
        NSError *error=nil;
         KidsAppCoverImage *image=[_parser  setupImageFromJSON:response error:&error];
        [self saveAppCoverImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(successBlock){
                successBlock(image);
            }
        });
        
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)saveAppCoverImage:(KidsAppCoverImage *)appCoverImage{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:appCoverImage];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SetupImage"];
}
-(KidsAppCoverImage *)fetchAppCoverImage{
   NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"SetupImage"];
    KidsAppCoverImage *setup_image = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(setup_image==nil)setup_image=[[KidsAppCoverImage alloc]init];
    return setup_image;
}
-(void)saveUserInfo:(NSString *)username userphone:(NSString *)userphone classid:(NSString *)classid{
    [self saveUserNameToLocal:username];
    [self saveUserPhoneToLocal:userphone];
    [self saveClassIDToLocal:classid];
}
-(NSString *)fetchUserNameFromLocal{
    NSString *UserName=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    if(UserName==nil){
        return @"";
    }else{
        return UserName;
    }
}
-(void)saveUserNameToLocal:(NSString *)UserName{
    [[NSUserDefaults standardUserDefaults] setObject:UserName forKey:@"UserName"];
}
-(NSString *)fetchUserPhoneFromLocal{
    NSString *UserPhone=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"];
    if(UserPhone==nil){
        return @"";
    }else{
        return UserPhone;
    }
}
-(void)saveUserPhoneToLocal:(NSString *)UserPhone{
    [[NSUserDefaults standardUserDefaults] setObject:UserPhone forKey:@"UserPhone"];
}
-(NSString *)fetchClassIDFromLocal{
    NSString *classID=[[NSUserDefaults standardUserDefaults] objectForKey:@"classID"];
    if(classID==nil){
        return @"0";
    }else{
        return classID;
    }
}
-(void)saveClassIDToLocal:(NSString *)classID{
    [[NSUserDefaults standardUserDefaults] setObject:classID forKey:@"classID"];
}
-(NSString *)getFontSize{
   NSString *fontSize=[[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"];
    if(fontSize==nil){
        return @"正常";
    }else{
        return fontSize;
    }
}
-(void)saveFontSize:(NSString *)fontSize{
    [[NSUserDefaults standardUserDefaults] setObject:fontSize forKey:@"fontSize"];
}
-(NSString *)getDeleteTimeStamp{
    NSString *deleteTimeStamp=[[NSUserDefaults standardUserDefaults] objectForKey:@"deleteTimeStamp"];
    if(deleteTimeStamp==nil){
        return @"2000-01-01 00:00:00";
    }else{
        return deleteTimeStamp;
    }
}
-(void)saveDeleteTimeStamp{
    NSDate *now=[NSDate date];
    NSTimeInterval aDay=-24*60*60;
    NSDate *yesterday=[NSDate dateWithTimeInterval:aDay sinceDate:now];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowStr=[dateFormatter stringFromDate:yesterday];
    [[NSUserDefaults standardUserDefaults] setObject:nowStr forKey:@"deleteTimeStamp"];
    
}
-(NSString *)osVersion{
    return [[UIDevice currentDevice] systemVersion];
}
-(NSString *)phoneModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = @"iPhone";
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    return modelNameString;
}
@end
