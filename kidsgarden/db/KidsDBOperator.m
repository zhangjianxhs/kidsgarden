//
//  KidsDBOperator.m
//  kidsgarden
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsDBOperator.h"
#import "E_Channel.h"
#import "E_Article.h"
#import "E_Image.h"
@implementation KidsDBOperator
@synthesize context=_context;
static NSString * const E_CHANNEL = @"E_Channel";
static NSString * const E_ARTICLE = @"E_Article";
static NSString * const E_IMAGE = @"E_Image";
-(id)initWithContext:(NSManagedObjectContext *)context{
    if(self=[super init]){
        self.context=context;
    }
    return self;
}

-(void)addChannel:(KidsChannel *)channel{
     NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
     NSPredicate * p = [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
     NSFetchRequest *frq = [[NSFetchRequest alloc]init];
     [frq setEntity:e_channel_desc];
     [frq setPredicate:p];
     NSArray *result =[_context executeFetchRequest:frq error:nil];
     E_Channel *e_channel;
    if([result count]>0){
        e_channel=[result objectAtIndex:0];
    }else{
        e_channel=[NSEntityDescription insertNewObjectForEntityForName:E_CHANNEL inManagedObjectContext:_context];
    }
    e_channel.a_channel_id=channel.channel_id;
    e_channel.a_name=channel.name;
    e_channel.a_nickname=channel.nickname;
    e_channel.a_show_type=[NSNumber numberWithInteger:channel.show_type];
    e_channel.a_show_location=[NSNumber numberWithInteger:channel.show_location];
    e_channel.a_show_count_in_row=[NSNumber numberWithInteger:channel.show_count_in_row];
    e_channel.a_cache_type=[NSNumber numberWithInteger:channel.cache_type];
    e_channel.a_auth_type=[NSNumber numberWithInteger:channel.auth_type];
    e_channel.a_sort=[NSNumber numberWithInteger:channel.priority];
}
-(void)removeAllChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(E_Article *article in result){
        [_context deleteObject:article];
    }
}
-(KidsChannel *)fetchADOutOfContentChannel{

    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_show_location = %d",ADOutOfContent];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        E_Channel *e_channel=result[0];
        KidsChannel *channel=[[KidsChannel alloc]init];
        channel.channel_id=e_channel.a_channel_id;
        channel.name=e_channel.a_name;
        channel.nickname=e_channel.a_nickname;
        channel.show_type=[e_channel.a_show_type integerValue];
        channel.show_location=[e_channel.a_show_location integerValue];
        channel.show_count_in_row=[e_channel.a_show_count_in_row integerValue];
        channel.cache_type=[e_channel.a_cache_type integerValue];
        channel.auth_type=[e_channel.a_auth_type integerValue];
        return channel;
    }
    return nil;
}
-(KidsChannel *)fetchADInContentChannel{
    
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
     NSPredicate* p = [NSPredicate predicateWithFormat:@"a_show_location = %d",ADInContent];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        E_Channel *e_channel=result[0];
        KidsChannel *channel=[[KidsChannel alloc]init];
        channel.channel_id=e_channel.a_channel_id;
        channel.name=e_channel.a_name;
        channel.nickname=e_channel.a_nickname;
        channel.show_type=[e_channel.a_show_type integerValue];
        channel.show_location=[e_channel.a_show_location integerValue];
        channel.show_count_in_row=[e_channel.a_show_count_in_row integerValue];
        channel.cache_type=[e_channel.a_cache_type integerValue];
        channel.auth_type=[e_channel.a_auth_type integerValue];
        return channel;
    }
    return nil;
}
-(KidsChannel *)fetchNotificationChannel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_show_location = %d",Notification];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        E_Channel *e_channel=result[0];
        KidsChannel *channel=[[KidsChannel alloc]init];
        channel.channel_id=e_channel.a_channel_id;
        channel.name=e_channel.a_name;
        channel.nickname=e_channel.a_nickname;
        channel.show_type=[e_channel.a_show_type integerValue];
        channel.show_location=[e_channel.a_show_location integerValue];
        channel.show_count_in_row=[e_channel.a_show_count_in_row integerValue];
        channel.cache_type=[e_channel.a_cache_type integerValue];
        channel.auth_type=[e_channel.a_auth_type integerValue];
        return channel;
    }
    return nil;
}
-(NSArray *)fetchTopChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_show_location = %d",Top];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *channels=[[NSMutableArray alloc]init];
    for(E_Channel *e_channel in result){
        KidsChannel *channel=[[KidsChannel alloc]init];
        channel.channel_id=e_channel.a_channel_id;
        channel.name=e_channel.a_name;
        channel.nickname=e_channel.a_nickname;
        channel.show_type=[e_channel.a_show_type integerValue];
        channel.show_location=[e_channel.a_show_location integerValue];
        channel.show_count_in_row=[e_channel.a_show_count_in_row integerValue];
        channel.cache_type=[e_channel.a_cache_type integerValue];
        channel.auth_type=[e_channel.a_auth_type integerValue];
        [channels addObject:channel];
    }
    return channels;
}
-(NSArray *)fetchLeftChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_show_location = %d ",Left];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *channels=[[NSMutableArray alloc]init];
    for(E_Channel *e_channel in result){
        KidsChannel *channel=[[KidsChannel alloc]init];
        channel.channel_id=e_channel.a_channel_id;
        channel.name=e_channel.a_name;
        channel.nickname=e_channel.a_nickname;
        channel.show_type=[e_channel.a_show_type integerValue];
        channel.show_location=[e_channel.a_show_location integerValue];
        channel.show_count_in_row=[e_channel.a_show_count_in_row integerValue];
        channel.cache_type=[e_channel.a_cache_type integerValue];
        channel.auth_type=[e_channel.a_auth_type integerValue];
        [channels addObject:channel];
    }
    return channels;
}

-(KidsArticle *)fetchHeaderArticleWithChannel:(KidsChannel *)channel{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_is_deleted = %d", channel.channel_id,NO];
    NSSortDescriptor *sortPriorityDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_priority" ascending:NO];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_pubish_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPriorityDescriptor,sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    
    for(E_Article *e_article in result){
        NSEntityDescription * e_image_desc = [NSEntityDescription entityForName:E_IMAGE inManagedObjectContext:_context];
        NSPredicate * p2 = [NSPredicate predicateWithFormat:@"a_article_id = %@ and a_show_type= %d", e_article.a_article_id,CoverImage];
        NSSortDescriptor *sortImageIDDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_image_id" ascending:NO];
        NSArray *sortImageDescriptors = [[NSArray alloc] initWithObjects:sortImageIDDescriptor, nil];
        NSFetchRequest *frq2 = [[NSFetchRequest alloc]init];
        [frq2 setEntity:e_image_desc];
        [frq2 setPredicate:p2];
        [frq2 setSortDescriptors:sortImageDescriptors];
        NSArray *result2 =[_context executeFetchRequest:frq2 error:nil];
        if([result2 count]==0||[result2 count]==3)continue;
        KidsArticle *article=[[KidsArticle alloc]init];
        article.article_id=e_article.a_article_id;
        article.title=e_article.a_title;
        article.channel_id=e_article.a_channel_id;
        article.content=e_article.a_content;
        article.url=e_article.a_url;
        article.is_deleted=[e_article.a_is_deleted boolValue];
        article.priority=e_article.a_priority;
        article.is_favor=[e_article.a_is_favor boolValue];
        article.is_read=[e_article.a_is_read boolValue];
        article.pubish_time=e_article.a_pubish_time;
        article.thumbnail_url=e_article.a_thumbnail_url;
        article.is_notification=[e_article.a_is_notification boolValue];
        article.summary=e_article.a_summary;
        NSMutableArray *cover_images=[[NSMutableArray alloc]init];
        for(E_Image *e_image in result2){
            KidsImage *image=[[KidsImage alloc]init];
            image.article_id=e_image.a_article_id;
            image.image_id=e_image.a_image_id;
            image.pushlish_time=e_image.a_pushlish_time;
            image.show_type=[e_image.a_show_type integerValue];
            image.url=e_image.a_url;
            [cover_images addObject:e_image.a_url];
        }
        article.cover_images=cover_images;
        return article;
    }
    return nil;
}
-(NSArray *)fetchMutiCoverImageArticlesWithChannel:(KidsChannel *)channel topN:(int)topN{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_is_deleted = %d", channel.channel_id,NO];
    NSSortDescriptor *sortPriorityDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_priority" ascending:NO];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_pubish_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPriorityDescriptor,sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[[NSMutableArray alloc]init];
    for(E_Article *e_article in result){
        
        NSEntityDescription * e_image_desc = [NSEntityDescription entityForName:E_IMAGE inManagedObjectContext:_context];
        NSPredicate * p2 = [NSPredicate predicateWithFormat:@"a_article_id = %@ and a_show_type= %d", e_article.a_article_id,CoverImage];
        NSFetchRequest *frq2 = [[NSFetchRequest alloc]init];
        [frq2 setEntity:e_image_desc];
        [frq2 setPredicate:p2];
        NSArray *result2 =[_context executeFetchRequest:frq2 error:nil];
        if([result2 count]>2){
            KidsArticle *article=[[KidsArticle alloc]init];
            NSLog(@"%@",e_article.r_image);
            article.article_id=e_article.a_article_id;
            article.title=e_article.a_title;
            article.channel_id=e_article.a_channel_id;
            article.content=e_article.a_content;
            article.url=e_article.a_url;
            article.is_deleted=[e_article.a_is_deleted boolValue];
            article.priority=e_article.a_priority;
            article.is_favor=[e_article.a_is_favor boolValue];
            article.is_read=[e_article.a_is_read boolValue];
            article.pubish_time=e_article.a_pubish_time;
            article.thumbnail_url=e_article.a_thumbnail_url;
            article.is_notification=[e_article.a_is_notification boolValue];
            article.summary=e_article.a_summary;
            NSMutableArray *images=[[NSMutableArray alloc]init];
            NSMutableArray *cover_images=[[NSMutableArray alloc]init];
            for(E_Image *e_image in result2){
                KidsImage *image=[[KidsImage alloc]init];
                image.article_id=e_image.a_article_id;
                image.image_id=e_image.a_image_id;
                image.pushlish_time=e_image.a_pushlish_time;
                image.show_type=[e_image.a_show_type integerValue];
                image.url=e_image.a_url;
                [images addObject:image];
                if([e_image.a_show_type intValue]==CoverImage){
                    [cover_images addObject:e_image.a_url];
                }
            }
            article.images=images;
            article.cover_images=cover_images;
            [articles addObject:article];
            if([articles count]>=topN){
                return articles;
            }
            
        }
    }
    return articles;
}
-(NSArray *)fetchArticlesWithChannel:(KidsChannel *)channel exceptArticleID:(NSArray *)exceptArticleIDs topN:(int)topN{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p ;
    if(exceptArticleIDs!=nil){
        switch ([exceptArticleIDs count]) {
            case 0:
                p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and  a_is_deleted = %d", channel.channel_id,NO];
                break;
            case 1:
                p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_article_id <>%@ and  a_is_deleted = %d", channel.channel_id,exceptArticleIDs[0],NO];
                break;
            case 2:
                p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_article_id <>%@ and a_article_id <>%@ and  a_is_deleted = %d", channel.channel_id,exceptArticleIDs[0],exceptArticleIDs[1],NO];
                break;
            case 3:
                p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_article_id <>%@ and a_article_id <>%@ and a_article_id <>%@ and  a_is_deleted = %d", channel.channel_id,exceptArticleIDs[0],exceptArticleIDs[1],exceptArticleIDs[2],NO];
                break;
        }
    }else{
        p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and  a_is_deleted = %d", channel.channel_id,NO];
    }
   
    NSSortDescriptor *sortPriorityDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_priority" ascending:NO];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_pubish_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPriorityDescriptor,sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setFetchLimit:topN];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[[NSMutableArray alloc]init];
    for(E_Article *e_article in result){
        
        NSEntityDescription * e_image_desc = [NSEntityDescription entityForName:E_IMAGE inManagedObjectContext:_context];
        NSPredicate * p2 = [NSPredicate predicateWithFormat:@"a_article_id = %@", e_article.a_article_id];
        NSFetchRequest *frq2 = [[NSFetchRequest alloc]init];
        [frq2 setEntity:e_image_desc];
        [frq2 setPredicate:p2];
        NSArray *result2 =[_context executeFetchRequest:frq2 error:nil];
        
        KidsArticle *article=[[KidsArticle alloc]init];
        NSLog(@"%@",e_article.r_image);
        article.article_id=e_article.a_article_id;
        article.title=e_article.a_title;
        article.channel_id=e_article.a_channel_id;
        article.content=e_article.a_content;
        article.url=e_article.a_url;
        article.is_deleted=[e_article.a_is_deleted boolValue];
        article.priority=e_article.a_priority;
        article.is_favor=[e_article.a_is_favor boolValue];
        article.is_read=[e_article.a_is_read boolValue];
        article.pubish_time=e_article.a_pubish_time;
        article.thumbnail_url=e_article.a_thumbnail_url;
        article.is_notification=[e_article.a_is_notification boolValue];
        article.summary=e_article.a_summary;
        NSMutableArray *images=[[NSMutableArray alloc]init];
        NSMutableArray *cover_images=[[NSMutableArray alloc]init];
        for(E_Image *e_image in result2){
            KidsImage *image=[[KidsImage alloc]init];
            image.article_id=e_image.a_article_id;
            image.image_id=e_image.a_image_id;
            image.pushlish_time=e_image.a_pushlish_time;
            image.show_type=[e_image.a_show_type integerValue];
            image.url=e_image.a_url;
            [images addObject:image];
            if([e_image.a_show_type intValue]==CoverImage){
                [cover_images addObject:e_image.a_url];
            }
        }
        article.images=images;
        article.cover_images=cover_images;
        [articles addObject:article];
    }
    return articles;
}

-(void)addArticle:(KidsArticle *)article{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", article.article_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
    }else{
        e_article=[NSEntityDescription insertNewObjectForEntityForName:E_ARTICLE inManagedObjectContext:_context];
    }
    //如果新稿件或者更新后的稿件，插入数据库
    if(![e_article.a_pubish_time isEqualToString: article.pubish_time]){
        e_article.a_article_id=article.article_id;
        e_article.a_title=article.title;
        e_article.a_channel_id=article.channel_id;
        e_article.a_content=article.content;
        e_article.a_url=article.url;
        e_article.a_is_deleted=[NSNumber numberWithBool:article.is_deleted];
        e_article.a_priority=article.priority;
        e_article.a_is_favor=[NSNumber numberWithBool:article.is_favor];
        e_article.a_pubish_time=article.pubish_time;
        e_article.a_thumbnail_url=article.thumbnail_url;
        e_article.a_is_notification=[NSNumber numberWithBool:article.is_notification];
        e_article.a_is_read=[NSNumber numberWithBool:article.is_read];
        e_article.a_channel_id=article.channel_id;
        e_article.a_summary=article.summary;
        
        NSEntityDescription * e_image_desc = [NSEntityDescription entityForName:E_IMAGE inManagedObjectContext:_context];
        NSPredicate * p2 = [NSPredicate predicateWithFormat:@"a_article_id = %@", article.article_id];
        NSFetchRequest *frq2 = [[NSFetchRequest alloc]init];
        [frq2 setEntity:e_image_desc];
        [frq2 setPredicate:p2];
        NSArray *result2 =[_context executeFetchRequest:frq2 error:nil];
        for(E_Image *image in result2){
            [_context deleteObject:image];
        }
//        if(article.thumbnail_url!=nil&&![article.thumbnail_url isEqualToString:@""]){
//            E_Image *e_image=[NSEntityDescription insertNewObjectForEntityForName:E_IMAGE inManagedObjectContext:_context];
//            e_image.a_pushlish_time=article.pubish_time;
//            e_image.a_show_type=[NSNumber numberWithInteger:ThumbnailImage];
//            e_image.a_url=article.thumbnail_url;
//            e_image.a_article_id=article.article_id;
//            e_image.a_image_id=[NSString stringWithFormat:@"%@%d",article.article_id,0];
//        }
        int i=1;
        for(NSString *pic in article.cover_images){
            E_Image *e_image=[NSEntityDescription insertNewObjectForEntityForName:E_IMAGE inManagedObjectContext:_context];
            e_image.a_pushlish_time=article.pubish_time;
            e_image.a_show_type=[NSNumber numberWithInteger:CoverImage];
            e_image.a_url=pic;
            e_image.a_article_id=article.article_id;
            e_image.a_image_id=[NSString stringWithFormat:@"%@%d",article.article_id,i++];
        }
    }
}
-(NSArray *)fetchNotificationArticleWithTopN:(NSNumber *)topN{
    return nil;
}
-(void)addImage:(KidsImage *)image{
    NSEntityDescription * e_image_desc = [NSEntityDescription entityForName:E_IMAGE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_image_id = %@", image.image_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_image_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Image *e_image;
    if([result count]==1){
        e_image=[result objectAtIndex:0];
    }else{
        e_image=[NSEntityDescription insertNewObjectForEntityForName:E_IMAGE inManagedObjectContext:_context];
    }
    e_image.a_image_id=image.image_id;
    e_image.a_pushlish_time=image.pushlish_time;
    e_image.a_show_type=[NSNumber numberWithInteger:image.show_type];
    e_image.a_url=image.url;
    e_image.a_article_id=image.article_id;
    [self save];
}
-(NSArray *)fetchImageWithArticleID:(NSString *)articleID{
    NSEntityDescription * e_image_desc = [NSEntityDescription entityForName:E_IMAGE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_image_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *images=[[NSMutableArray alloc]init];
    for(E_Image *e_image in result){
        KidsImage *image=[[KidsImage alloc]init];
        image.image_id=e_image.a_image_id;
        image.pushlish_time=e_image.a_pushlish_time;
        image.show_type=[e_image.a_show_type integerValue];
        image.url=e_image.a_url;
        image.article_id=e_image.a_article_id;
        [images addObject:image];
    }
    return images;
}
-(BOOL)deleteArticleWithArticleIDs:(NSArray *)articleIDs{
    BOOL deleted=NO;
    for(NSString *articleID in articleIDs){
        NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
        NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@",articleID];
        NSFetchRequest *frq = [[NSFetchRequest alloc]init];
        [frq setEntity:e_article_desc];
        [frq setPredicate:p];
        NSArray *result =[_context executeFetchRequest:frq error:nil];
        for(E_Article *article in result){
            [_context deleteObject:article];
            deleted=YES;
        }
    }
    return deleted;
}
-(void)updateArticleContentWithArticle:(KidsArticle *)article articleContent:(KidsArticleContent *)articleContent{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@ ", article.article_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Article *e_article;
    if([result count]>0){
        e_article=[result objectAtIndex:0];
    }
    e_article.a_content=articleContent.content;
    
    NSEntityDescription * e_image_desc = [NSEntityDescription entityForName:E_IMAGE inManagedObjectContext:_context];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"a_article_id = %@ and a_show_type= %d", article.article_id,ContentImage];
    NSFetchRequest *frq2 = [[NSFetchRequest alloc]init];
    [frq2 setEntity:e_image_desc];
    [frq2 setPredicate:p2];
    NSArray *result2 =[_context executeFetchRequest:frq2 error:nil];
    for(E_Image *image in result2){
        [_context deleteObject:image];
    }
    for(NSString *pic in articleContent.pics){
        E_Image *e_image=[NSEntityDescription insertNewObjectForEntityForName:E_IMAGE inManagedObjectContext:_context];
        e_image.a_pushlish_time=article.pubish_time;
        e_image.a_show_type=[NSNumber numberWithInteger:ContentImage];
        e_image.a_url=pic;
        e_image.a_article_id=article.article_id;
    }
}
-(void)markArticleReadWithArticleID:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
    }else{
        e_article=[NSEntityDescription insertNewObjectForEntityForName:E_ARTICLE inManagedObjectContext:_context];
    }
    e_article.a_is_read=[NSNumber numberWithBool:YES];
}
-(void)markArticleFavorWithArticleID:(NSString *)articleID favor:(BOOL)favor{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
    }else{
        e_article=[NSEntityDescription insertNewObjectForEntityForName:E_ARTICLE inManagedObjectContext:_context];
    }
    e_article.a_is_favor=[NSNumber numberWithBool:favor];
}
-(NSArray *)fetchFavorArticles{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_is_favor = %d and  a_is_deleted = %d",YES,NO];
    NSSortDescriptor *sortPriorityDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_priority" ascending:NO];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_pubish_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPriorityDescriptor,sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[[NSMutableArray alloc]init];
    for(E_Article *e_article in result){
        
        NSEntityDescription * e_image_desc = [NSEntityDescription entityForName:E_IMAGE inManagedObjectContext:_context];
        NSPredicate * p2 = [NSPredicate predicateWithFormat:@"a_article_id = %@", e_article.a_article_id];
        NSFetchRequest *frq2 = [[NSFetchRequest alloc]init];
        [frq2 setEntity:e_image_desc];
        [frq2 setPredicate:p2];
        NSArray *result2 =[_context executeFetchRequest:frq2 error:nil];
        
        KidsArticle *article=[[KidsArticle alloc]init];
        NSLog(@"%@",e_article.r_image);
        article.article_id=e_article.a_article_id;
        article.title=e_article.a_title;
        article.channel_id=e_article.a_channel_id;
        article.content=e_article.a_content;
        article.url=e_article.a_url;
        article.is_deleted=[e_article.a_is_deleted boolValue];
        article.priority=e_article.a_priority;
        article.is_favor=[e_article.a_is_favor boolValue];
        article.is_read=[e_article.a_is_read boolValue];
        article.pubish_time=e_article.a_pubish_time;
        article.thumbnail_url=e_article.a_thumbnail_url;
        article.is_notification=[e_article.a_is_notification boolValue];
        article.summary=e_article.a_summary;
        NSMutableArray *images=[[NSMutableArray alloc]init];
        NSMutableArray *cover_images=[[NSMutableArray alloc]init];
        for(E_Image *e_image in result2){
            KidsImage *image=[[KidsImage alloc]init];
            image.article_id=e_image.a_article_id;
            image.image_id=e_image.a_image_id;
            image.pushlish_time=e_image.a_pushlish_time;
            image.show_type=[e_image.a_show_type integerValue];
            image.url=e_image.a_url;
            [images addObject:image];
            if([e_image.a_show_type intValue]==CoverImage){
                [cover_images addObject:e_image.a_url];
            }else{
                article.thumbnail_url=e_image.a_url;
            }
        }
        article.images=images;
        article.cover_images=cover_images;
        [articles addObject:article];
    }
    return articles;
}
-(BOOL)save{
    BOOL result=NO;
    NSError *error;
    if(_context!=nil){
        if([_context hasChanges]){
            result=[_context save:&error];
            if(!result){
                NSLog(@"数据库操作失败！%@",error);
                exit(-1);
            }
        }
    }
    return YES;
}
@end
