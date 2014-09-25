//
//  UserAction.m
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import "UserAction.h"

@implementation UserAction
@synthesize action_type;
@synthesize action_time;
@synthesize action_target;
@synthesize action_description;
@synthesize action_remark;
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:action_type forKey:@"TYPE"];
    [aCoder encodeObject:action_time forKey:@"TIME"];
    [aCoder encodeObject:action_target forKey:@"TARGET"];
    [aCoder encodeObject:action_description forKey:@"DESCRIPTION"];
    [aCoder encodeObject:action_remark forKey:@"REMARK"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if(self){
        self.action_type=[aDecoder decodeObjectForKey:@"TYPE"];
        self.action_time=[aDecoder decodeObjectForKey:@"TIME"];
        self.action_target=[aDecoder decodeObjectForKey:@"TARGET"];
        self.action_remark=[aDecoder decodeObjectForKey:@"REMARK"];
        self.action_description=[aDecoder decodeObjectForKey:@"DESCRIPTION"];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    UserAction *actions=[[[self class] allocWithZone:zone]init];
    actions.action_type=self.action_type;
    actions.action_time=self.action_time;
    actions.action_target=self.action_target;
    actions.action_description=self.action_description;
    actions.action_remark=self.action_remark;
    return actions;
}
@end
