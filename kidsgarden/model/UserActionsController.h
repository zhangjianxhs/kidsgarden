//
//  UserActions.h
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import <Foundation/Foundation.h>
#import "KidsClass.h"
@class UserAction;
@interface UserActionsController : NSObject{
   NSMutableArray* m_array;
}
+(UserActionsController *)sharedInstance;
-(void)enqueueAReadAction:(KidsArticle *)article;
-(void)enqueueARegisterAction:(NSString *)device;
-(void)enqueueAOpenAction;
-(void)enqueueAEnrollmentAction:(KidsClass *)kidsclass;
-(void)enqueueAGetPushAction:(KidsArticle *)article;
-(void)enqueueAUpdateAction:(NSString *)version;
-(void)enqueueAShareAction:(KidsArticle *)article;
-(void)enqueueACollecionAction:(KidsArticle *)article;
-(void)enqueueACoverADAction:(NSString *)url;
-(void)reportActionsToServer;
@property (nonatomic, readonly) int count;
@end
