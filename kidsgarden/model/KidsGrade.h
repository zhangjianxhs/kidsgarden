//
//  KidsGrade.h
//  kidsgarden
//
//  Created by apple on 14/6/23.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KidsGrade : NSObject
@property(nonatomic,strong)NSString *grade_id;
@property(nonatomic,strong)NSString *grade_name;
@property(nonatomic,strong)NSMutableArray *classes;

@end
