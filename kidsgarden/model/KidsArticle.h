//
//  KidsArticle.h
//  kidsgarden
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KidsArticle : NSObject
@property (nonatomic, strong) NSString * article_id;//文章ID
@property (nonatomic, strong) NSString * title;//文章标题
@property (nonatomic, strong) NSString * summary;//摘要
@property (nonatomic, strong) NSString * source;//来源
@property (nonatomic, strong) NSString * content;//内容
@property (nonatomic, strong) NSString * channel_id;//频道ID
@property (nonatomic, assign)  BOOL       is_favor;//是否收藏
@property (nonatomic, assign)  BOOL       is_notification;//是否通知
@property (nonatomic, strong) NSNumber * priority;//显示顺序优先级
@property (nonatomic, strong) NSString * pubish_time;//发布时间
@property (nonatomic, assign)  BOOL       is_deleted;//是否删除
@property (nonatomic, assign)  BOOL       is_read;//是否已读
@property (nonatomic, strong) NSString * thumbnail_url;//缩略图URL
@property (nonatomic, strong) NSString * url;//文章URL
@property (nonatomic, strong) NSArray  * images;//文章图片URL
@property (nonatomic, strong) NSArray  * cover_images;//封面图片URL
-(float)preferHeight;
@end
