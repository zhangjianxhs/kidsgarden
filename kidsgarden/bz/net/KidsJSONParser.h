//
//  KidsJSONParser.h
//  kidsgarden
//
//  Created by apple on 14-5-13.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KidsArticleContent.h"
#import "KidsAppCoverImage.h"
@interface KidsJSONParser : NSObject
-(NSArray *)articlesFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error;
-(NSArray *)channelsFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error;
-(KidsArticleContent *)articleContentFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error;
-(NSArray *)gradesFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error;
-(BOOL)invalidateJSONWith:(NSDictionary *)objectionNotation error:(NSError **)error;
-(NSArray *)toDeleteArticleIDsFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error;
-(KidsAppCoverImage *)setupImageFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error;
-(KidsArticle *)pushArticleFromJSON:(NSDictionary *)objectionNotation error:(NSError **)error;
@end
