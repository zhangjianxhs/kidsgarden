//
//  KidsArticle.m
//  kidsgarden
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsArticle.h"

@implementation KidsArticle
@synthesize article_id=_article_id;
@synthesize title=_title;
@synthesize content=_content;
@synthesize channel_id=_channel_id;
@synthesize is_favor=_is_favor;
@synthesize  is_notification=_is_notification;
@synthesize priority=_priority;
@synthesize pubish_time=_pubish_time;
@synthesize  is_deleted=_is_deleted;
@synthesize  is_read=_is_read;
@synthesize thumbnail_url=_thumbnail_url;
@synthesize url=_url;
@synthesize images=_images;
@synthesize cover_images=_cover_images;
-(float)preferHeight{
    if(_cover_images!=nil && [_cover_images count]>=3){
        return 100;
    }else{
        return 70;
    }
}
@end
