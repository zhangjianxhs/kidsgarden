//
//  KidsADView.h
//  kidsgarden
//
//  Created by apple on 14/7/18.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsArticleViewDelegate.h"
@interface KidsADView : UIView
@property(nonatomic,assign)id<KidsArticleViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame articles:(NSArray *)articles;
@end
