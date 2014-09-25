//
//  KidsHeaderView.h
//  kidsgarden
//
//  Created by apple on 14/6/13.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALImageView.h"
@protocol HeaderViewDelegate <NSObject>
-(void)headerClicked:(KidsArticle *)article;
@end
@interface KidsHeaderView : UICollectionReusableView
@property(nonatomic,strong)id<HeaderViewDelegate> delegate;
-(void)setArticle:(KidsArticle *)article;
@end
