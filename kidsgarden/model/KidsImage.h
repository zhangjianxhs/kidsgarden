//
//  KidsImage.h
//  kidsgarden
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ImageType)
{
    CoverImage = 0,
    ContentImage = 1
};
@interface KidsImage : NSObject
@property (nonatomic, strong) NSString * image_id;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * article_id;
@property (nonatomic, strong) NSString * pushlish_time;
@property (nonatomic, assign) ImageType show_type;//CoverImage / ContentImage
@end
