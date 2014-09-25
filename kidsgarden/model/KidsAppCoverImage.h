//
//  KidsSetupImage.h
//  kidsgarden
//
//  Created by apple on 14/7/3.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KidsAppCoverImage : NSObject<NSCoding,NSCopying>
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *goUrl;
@property(nonatomic,strong)NSString *dateStr;
-(BOOL)isEmpty;
@end
