//
//  KidsServerCommunicator.h
//  kidsgarden
//
//  Created by apple on 14-5-13.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KidsServerCommunicator : NSObject
-(void)fetchJSONContentAtURL:(NSString *)url successHandler:(void(^)(NSDictionary *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)postJSONToServerAtURL:(NSString *)url parameters:(NSDictionary *)parameters successHandler:(void(^)(NSDictionary *))successBlock errorHandler:(void(^)(NSError *))errorBlock ;
@end
