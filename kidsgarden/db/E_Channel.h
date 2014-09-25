//
//  E_Channel.h
//  kidsgarden
//
//  Created by apple on 14/7/18.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class E_Article;

@interface E_Channel : NSManagedObject

@property (nonatomic, retain) NSNumber * a_auth_type;
@property (nonatomic, retain) NSNumber * a_cache_type;
@property (nonatomic, retain) NSString * a_channel_id;
@property (nonatomic, retain) NSString * a_name;
@property (nonatomic, retain) NSString * a_nickname;
@property (nonatomic, retain) NSNumber * a_show_count_in_row;
@property (nonatomic, retain) NSNumber * a_show_location;
@property (nonatomic, retain) NSNumber * a_show_type;
@property (nonatomic, retain) NSNumber * a_sort;
@property (nonatomic, retain) NSSet *r_article;
@end

@interface E_Channel (CoreDataGeneratedAccessors)

- (void)addR_articleObject:(E_Article *)value;
- (void)removeR_articleObject:(E_Article *)value;
- (void)addR_article:(NSSet *)values;
- (void)removeR_article:(NSSet *)values;

@end
