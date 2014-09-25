//
//  KidsChannel.h
//  kidsgarden
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ShowType)
{
    Detail = 0,
    Tile   = 1
};
typedef NS_ENUM(NSInteger, ShowLocation)
{
    Top = 0,
    Left   = 1,
    ADInContent   =2,
    ADOutOfContent =3,
    Notification =4
};
typedef NS_ENUM(NSInteger, CacheType)
{
    CacheWhenOpen = 0,
    Always        = 1
};
typedef NS_ENUM(NSInteger, AuthType)
{
    Opened = 0,
    AuthorizationRequired = 1
};
@interface KidsChannel : NSObject
@property (nonatomic, strong) NSString * channel_id;//频道ID
@property (nonatomic, strong) NSString * name;//频道名称
@property (nonatomic, strong) NSString * nickname;//频道简称
@property (nonatomic, assign) NSInteger show_count_in_row;//每行显示几张文章标题
@property (nonatomic, assign) ShowLocation show_location;//显示位置
@property (nonatomic, assign) ShowType show_type;//显示类型
@property (nonatomic, assign) CacheType cache_type;//缓存类型
@property (nonatomic, assign) AuthType auth_type;//授权类型
@property (nonatomic, assign) NSInteger priority;//显示优先级
@property (nonatomic, strong) NSArray  * articles;
@property (nonatomic,strong) NSString *update_time;
@end
static NSString * const SHOW_LOCATION_LEFT = @"SHOW_LOCATION_LEFT";
static NSString * const SHOW_LOCATION_TOP = @"SHOW_LOCATION_TOP";
