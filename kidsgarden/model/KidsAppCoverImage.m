//
//  KidsSetupImage.m
//  kidsgarden
//
//  Created by apple on 14/7/3.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsAppCoverImage.h"

@implementation KidsAppCoverImage
@synthesize url=_url;
@synthesize goUrl=_goUrl;
@synthesize dateStr=_dateStr;
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_url forKey:@"url"];
    [aCoder encodeObject:_goUrl forKey:@"goUrl"];
    [aCoder encodeObject:_dateStr forKey:@"dateStr"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if(self){
        self.url=[aDecoder decodeObjectForKey:@"url"];
        self.goUrl=[aDecoder decodeObjectForKey:@"goUrl"];
        self.dateStr=[aDecoder decodeObjectForKey:@"dateStr"];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    KidsAppCoverImage *setup_image=[[[self class] allocWithZone:zone]init];
    setup_image.url=self.url;
    setup_image.goUrl=self.goUrl;

    setup_image.dateStr=self.dateStr;
    return setup_image;
}
-(BOOL)isEmpty{
    if(_url==nil||_dateStr==nil)
        return YES;
    else
        return NO;
}
@end
