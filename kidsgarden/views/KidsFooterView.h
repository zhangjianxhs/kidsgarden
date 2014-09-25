//
//  KidsFooterView.h
//  kidsgarden
//
//  Created by apple on 14/6/18.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, FooterViewStatus)
{
    buzy = 0,
    idle = 1
};
@protocol FooterViewDelegate <NSObject>
-(void)loadMoreData;
@end
@interface KidsFooterView : UICollectionReusableView
@property(nonatomic,strong)id<FooterViewDelegate> delegate;
-(void)setStatus:(FooterViewStatus)status;
@end
