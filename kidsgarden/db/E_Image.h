//
//  E_Image.h
//  kidsgarden
//
//  Created by apple on 14/7/18.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class E_Article;

@interface E_Image : NSManagedObject

@property (nonatomic, retain) NSString * a_article_id;
@property (nonatomic, retain) NSString * a_image_id;
@property (nonatomic, retain) NSString * a_pushlish_time;
@property (nonatomic, retain) NSNumber * a_show_type;
@property (nonatomic, retain) NSString * a_url;
@property (nonatomic, retain) E_Article *r_article;

@end
