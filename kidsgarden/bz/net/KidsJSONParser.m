//
//  KidsJSONParser.m
//  kidsgarden
//
//  Created by apple on 14-5-13.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsJSONParser.h"
#import "KidsGrade.h"
#import "KidsClass.h"
#import "KidsAppCoverImage.h"
NSString *const JSONParserErrorDomain=@"JSONParserErrorDomain";
typedef enum{
    InvalidJSONError,
    MissingDataError,
    ServerInternalError
}JSONParserError;
@implementation KidsJSONParser
-(BOOL)invalidateJSONWith:(NSDictionary *)objectionNotation error:(NSError **)error{
    NSParameterAssert(objectionNotation!=nil);
    if(objectionNotation==nil){
        if(error!=NULL){
            *error=[NSError errorWithDomain:JSONParserErrorDomain code:InvalidJSONError userInfo:nil];
        }
        return NO;
    }
    NSNumber *status=[objectionNotation valueForKey:@"status"];
    NSString *msg=[objectionNotation valueForKey:@"msg"];
    if([status intValue]==0){
        return YES;
    }
    if(error!=NULL){
        NSDictionary *userInfo=[NSDictionary dictionaryWithObject:msg forKey:@"msg"];
        *error=[NSError errorWithDomain:JSONParserErrorDomain code:ServerInternalError userInfo:userInfo];
    }
    return NO;
}
-(KidsArticle *)pushArticleFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error{
    NSError *localError=nil;
    if(![self invalidateJSONWith:objectionNotation error:&localError])return nil;
    NSDictionary *data=[objectionNotation valueForKey:@"data"];
    KidsArticle *article=[[KidsArticle alloc] init];
    article.article_id=[NSString stringWithFormat:@"%d",[[data valueForKey:@"article_id"] intValue]];
    article.title=[data valueForKey:@"article_title"];
    article.summary=[data valueForKey:@"summary"];
    article.source=[data valueForKey:@"source"];
    int status=[[data valueForKey:@"status"] intValue];
    if(status==-1){
        article.is_deleted=YES;
    }else{
        article.is_deleted=NO;
    }
    article.url=[data valueForKey:@"url"];
    article.thumbnail_url=[data valueForKey:@"thumbnail_url"];
    article.pubish_time=[data valueForKey:@"pub_time"];
    article.is_notification=[[data valueForKey:@"push"] boolValue];
    article.priority=[NSNumber numberWithInt:[[data valueForKey:@"sort"] intValue]];
    article.cover_images=[data valueForKey:@"cover_pic_urls"];
    article.content=[data valueForKey:@"content"];
    if(article==nil){
        if(error!=NULL){
            *error=[NSError errorWithDomain:JSONParserErrorDomain code:MissingDataError userInfo:nil];
        }
        return nil;
    }
    return article;
}
-(NSArray *)articlesFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error{
    NSError *localError=nil;
    if(![self invalidateJSONWith:objectionNotation error:&localError])return nil;
    NSDictionary *data=[objectionNotation valueForKey:@"data"];
    NSArray *articles_dic_array=[data valueForKey:@"items"];
    NSMutableArray *articles=[[NSMutableArray alloc]init];
    for(NSDictionary * article_dic in articles_dic_array){
        KidsArticle *article=[[KidsArticle alloc] init];
        article.article_id=[NSString stringWithFormat:@"%d",[[article_dic valueForKey:@"article_id"] intValue]];
        article.title=[article_dic valueForKey:@"article_title"];
        article.summary=[article_dic valueForKey:@"summary"];
        article.source=[article_dic valueForKey:@"source"];
        int status=[[article_dic valueForKey:@"status"] intValue];
        if(status==-1){
            article.is_deleted=YES;
        }else{
            article.is_deleted=NO;
        }
        article.url=[article_dic valueForKey:@"url"];
        article.thumbnail_url=[article_dic valueForKey:@"thumbnail_url"];
        article.pubish_time=[article_dic valueForKey:@"pub_time"];
        article.is_notification=[[article_dic valueForKey:@"push"] boolValue];
        article.priority=[NSNumber numberWithInt:[[article_dic valueForKey:@"sort"] intValue]];
        article.cover_images=[article_dic valueForKey:@"cover_pic_urls"];
        [articles addObject:article];
    }
    if(articles==nil){
        if(error!=NULL){
            *error=[NSError errorWithDomain:JSONParserErrorDomain code:MissingDataError userInfo:nil];
        }
        return nil;
    }
    return articles;
    
}
-(KidsArticleContent *)articleContentFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error{
    NSError *localError=nil;
    if(![self invalidateJSONWith:objectionNotation error:&localError])return nil;
    NSDictionary *data=[objectionNotation valueForKey:@"data"];
    KidsArticleContent *content=[[KidsArticleContent alloc]init];
    content.content=[data valueForKey:@"content"];
    content.pics=[data valueForKey:@"pic_urls"];
    return content;
}
-(NSArray *)channelsFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error{
    NSError *localError=nil;
    if(![self invalidateJSONWith:objectionNotation error:&localError])return nil;
    NSDictionary *data=[objectionNotation valueForKey:@"data"];
    NSArray *channels_dic_array=[data valueForKey:@"items"];
    NSMutableArray *channels=[[NSMutableArray alloc]init];
    for(NSDictionary * channel_dic in channels_dic_array){
        KidsChannel *channel=[[KidsChannel alloc] init];
        channel.channel_id=[NSString stringWithFormat:@"%d",[[channel_dic valueForKey:@"column_id"] intValue]];
        channel.name=[channel_dic valueForKey:@"column_name"];
        channel.nickname=[channel_dic valueForKey:@"nickname"];
        NSString *show_type_str=[channel_dic valueForKey:@"show_type"];
        if([show_type_str caseInsensitiveCompare:@"Detail"]==NSOrderedSame){
            channel.show_type=Detail;
        }else{
            channel.show_type=Tile;
        }
        NSString *show_location_str=[channel_dic valueForKey:@"location"];
        if([show_location_str caseInsensitiveCompare:@"TOP"]==NSOrderedSame){
            channel.show_location=Top;
        }else if([show_location_str caseInsensitiveCompare:@"Left"]==NSOrderedSame){
            channel.show_location=Left;
        }else if([show_location_str caseInsensitiveCompare:@"AD_IN"]==NSOrderedSame){
            channel.show_location=ADInContent;
        }else if([show_location_str caseInsensitiveCompare:@"AD_OUT"]==NSOrderedSame){
            channel.show_location=ADOutOfContent;
        }else if([show_location_str caseInsensitiveCompare:@"notify"]==NSOrderedSame){
            channel.show_location=Notification;
        }else{
            channel.show_location=Top;
        }
        if([[channel_dic valueForKey:@"auth_type"] intValue]==0){
            channel.auth_type=Opened;
        }else{
            channel.auth_type=AuthorizationRequired;
        }
        if([[channel_dic valueForKey:@"cache_type"] intValue]==0){
            channel.cache_type=CacheWhenOpen;
        }else{
            channel.cache_type=Always;
        }
        channel.show_count_in_row=[[channel_dic valueForKey:@"show_count_in_row"] integerValue];
        channel.update_time=[channel_dic valueForKey:@"update_time"];
        channel.priority=[[channel_dic valueForKey:@"sort"] integerValue];
        [channels addObject:channel];
    }
    if(channels==nil){
        if(error!=NULL){
            *error=[NSError errorWithDomain:JSONParserErrorDomain code:MissingDataError userInfo:nil];
        }
        return nil;
    }
    return channels;
}
-(NSArray *)toDeleteArticleIDsFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error{
    NSError *localError=nil;
    if(![self invalidateJSONWith:objectionNotation error:&localError])return nil;
    NSDictionary *data=[objectionNotation valueForKey:@"data"];
    NSArray *articleID_dic_array=[data valueForKey:@"items"];
    NSMutableArray *articleIDs=[[NSMutableArray alloc]init];
    for(NSNumber * articleID in articleID_dic_array){
        [articleIDs addObject:[NSString stringWithFormat:@"%d",[articleID intValue] ]];
    }
    if(articleIDs==nil){
        if(error!=NULL){
            *error=[NSError errorWithDomain:JSONParserErrorDomain code:MissingDataError userInfo:nil];
        }
        return nil;
    }
    return articleIDs;
}
-(NSArray *)gradesFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error{
    NSError *localError=nil;
    if(![self invalidateJSONWith:objectionNotation error:&localError])return nil;
    NSDictionary *data=[objectionNotation valueForKey:@"data"];
    NSArray *grades_dic_array=[data valueForKey:@"items"];
    NSMutableArray *grades=[[NSMutableArray alloc]init];
    for(NSDictionary * grade_dic in grades_dic_array){
        KidsGrade *grade=[[KidsGrade alloc] init];
        grade.grade_id=[NSString stringWithFormat:@"%d",[[grade_dic valueForKey:@"grade_id"] intValue]];
        grade.grade_name=[grade_dic valueForKey:@"grade_name"];
        NSArray *classes_dic_array=[grade_dic valueForKey:@"classes"];
        grade.classes=[[NSMutableArray alloc]init];
        for(NSDictionary *class_dic in classes_dic_array){
            KidsClass *class=[[KidsClass alloc]init];
            class.class_id=[NSString stringWithFormat:@"%d",((NSString *)[class_dic valueForKey:@"class_id"]).intValue];
            class.class_name=[class_dic valueForKey:@"class_name"];
            [grade.classes addObject:class];
        }
        [grades addObject:grade];
    }
    if(grades==nil){
        if(error!=NULL){
            *error=[NSError errorWithDomain:JSONParserErrorDomain code:MissingDataError userInfo:nil];
        }
        return nil;
    }
    return grades;
}
-(KidsAppCoverImage *)setupImageFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error{
    NSError *localError=nil;
    if(![self invalidateJSONWith:objectionNotation error:&localError])return nil;
    NSDictionary *data=[objectionNotation valueForKey:@"data"];
    KidsAppCoverImage *setupImage=[[KidsAppCoverImage alloc]init];
    setupImage.url=[data valueForKey:@"url"];
    setupImage.goUrl=[data valueForKey:@"gotourl"];
    setupImage.dateStr=[data valueForKey:@"updatetime"];
    if(setupImage==nil){
        if(error!=NULL){
            *error=[NSError errorWithDomain:JSONParserErrorDomain code:MissingDataError userInfo:nil];
        }
        return nil;
    }
    return setupImage;
}
@end
