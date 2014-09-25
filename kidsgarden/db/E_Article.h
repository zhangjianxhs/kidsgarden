//
//  E_Article.h
//  kidsgarden
//
//  Created by apple on 14/7/18.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class E_Channel, E_Image;

@interface E_Article : NSManagedObject

@property (nonatomic, retain) NSString * a_article_id;
@property (nonatomic, retain) NSString * a_channel_id;
@property (nonatomic, retain) NSString * a_content;
@property (nonatomic, retain) NSNumber * a_is_deleted;
@property (nonatomic, retain) NSNumber * a_is_favor;
@property (nonatomic, retain) NSNumber * a_is_notification;
@property (nonatomic, retain) NSNumber * a_is_read;
@property (nonatomic, retain) NSNumber * a_priority;
@property (nonatomic, retain) NSString * a_pubish_time;
@property (nonatomic, retain) NSString * a_thumbnail_url;
@property (nonatomic, retain) NSString * a_title;
@property (nonatomic, retain) NSString * a_url;
@property (nonatomic, retain) NSString * a_summary;
@property (nonatomic, retain) E_Channel *r_channel;
@property (nonatomic, retain) NSSet *r_image;
@end

@interface E_Article (CoreDataGeneratedAccessors)

- (void)addR_imageObject:(E_Image *)value;
- (void)removeR_imageObject:(E_Image *)value;
- (void)addR_image:(NSSet *)values;
- (void)removeR_image:(NSSet *)values;

@end
