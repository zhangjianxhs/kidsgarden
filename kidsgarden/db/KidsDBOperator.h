//
//  KidsDBOperator.h
//  kidsgarden
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KidsChannel.h"
#import "KidsArticle.h"
#import "KidsImage.h"
#import "KidsArticleContent.h"

@interface KidsDBOperator : NSObject
@property(nonatomic,strong)NSManagedObjectContext *context;
-(id)initWithContext:(NSManagedObjectContext *)context;
-(BOOL)save;
-(void)addChannel:(KidsChannel *)channel;
-(NSArray *)fetchTopChannels;
-(NSArray *)fetchLeftChannels;
-(KidsChannel *)fetchADOutOfContentChannel;
-(KidsChannel *)fetchADInContentChannel;
-(KidsChannel *)fetchNotificationChannel;
-(void)removeAllChannels;

-(void)addArticle:(KidsArticle *)article;
-(KidsArticle *)fetchHeaderArticleWithChannel:(KidsChannel *)channel;
-(NSArray *)fetchArticlesWithChannel:(KidsChannel *)channel exceptArticleID:(NSArray *)exceptArticleIDs topN:(int)topN;
-(NSArray *)fetchMutiCoverImageArticlesWithChannel:(KidsChannel *)channel topN:(int)topN;
-(NSArray *)fetchFavorArticles;
-(void)addImage:(KidsImage *)image;
-(NSArray *)fetchImageWithArticleID:(NSString *)articleID;
-(void)updateArticleContentWithArticle:(KidsArticle *)article articleContent:(KidsArticleContent *)articleContent;
-(void)markArticleReadWithArticleID:(NSString *)articleID;
-(void)markArticleFavorWithArticleID:(NSString *)articleID favor:(BOOL)favor;
-(BOOL)deleteArticleWithArticleIDs:(NSArray *)articleIDs;
@end
