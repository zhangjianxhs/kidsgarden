//
//  KidsDownloadingService.h
//  kidsgarden
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KidsServerCommunicator.h"
#import "KidsJSONParser.h"
#import "KidsArticleContent.h"
#import "KidsArticle.h"
#import "KidsClass.h"
@interface KidsService : NSObject
@property(nonatomic,strong)KidsServerCommunicator *communicator;
@property(nonatomic,strong)KidsDBManager *db_manager;
@property(nonatomic,strong)KidsJSONParser *parser;
//网络
-(void)fetchChannelsFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchArticlesFromNETWithChannelID:(NSString *)channelID pageIndex:(int)pageIndex successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchArticleContentFromNETWithArticle:(KidsArticle *)article successHandler:(void(^)(KidsArticle *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)registerDevice:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchClassListFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)enrollViaNETWithUsername:(NSString *)username phone:(NSString *)phone kidsclass:(KidsClass *)kidsclass successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchAppCoverImageFromNet:(void(^)(KidsAppCoverImage *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchToDeleteArtilceIDsWithChannelID:(NSString *)channelID succcessHander:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchFoundationalDataFromNET:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)reportActionsToServer:(NSString *)postJSON succcessHander:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchPushArticleWithArticleID:(NSString *)articleID successHandler:(void(^)(KidsArticle *))successBlock errorHandler:(void(^)(NSError *))errorBlock;

//数据
-(NSArray *)fetchFavorArticlesFromDB;
-(NSArray *)fetchLeftChannelsFromDB;
-(NSArray *)fetchTopChannelsFromDB;
-(KidsArticle *)fetchHeaderArticleWithChannel:(KidsChannel *)channel;
-(NSArray *)fetchArticlesWithChannel:(KidsChannel *)channel exceptArticleID:(NSString *)exceptArticleID topN:(int)topN;
-(void)markArticleFavor:(KidsArticle *)article favor:(BOOL)favor;
-(void)markArticleReadWithArticle:(KidsArticle *)article;
-(KidsChannel *)fetchInsideADChannelFromDB;
-(KidsChannel *)fetchOutsideADChannelFromDB;
-(KidsChannel *)fetchNotificationChannelFromDB;

//配置
-(void)saveUserInfo:(NSString *)username userphone:(NSString *)userphone classid:(NSString *)classid;
-(NSString *)fetchUserPhoneFromLocal;
-(NSString *)fetchUserNameFromLocal;
-(NSString *)fetchClassIDFromLocal;
-(KidsAppCoverImage *)fetchAppCoverImage;
-(NSString *)getFontSize;
-(void)saveFontSize:(NSString *)fontSize;

//push
-(void)registerBaiduPushToken:(NSData *)deviceToken;
-(void)bindBaiduChannel;
@end
