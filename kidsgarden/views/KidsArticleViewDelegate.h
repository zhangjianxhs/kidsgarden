//
//  KidsArticleViewDelegate.h
//  kidsgarden
//
//  Created by apple on 14/7/18.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KidsArticle.h"
@protocol KidsArticleViewDelegate <NSObject>
-(void)clickedWithArticle:(KidsArticle *)article;
@end
