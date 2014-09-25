//
//  KidsServerCommunicator.m
//  kidsgarden
//
//  Created by apple on 14-5-13.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsServerCommunicator.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"
#import "NetStreamStatistics.h"

@implementation KidsServerCommunicator
-(void)fetchJSONContentAtURL:(NSString *)url successHandler:(void(^)(NSDictionary *))successBlock errorHandler:(void(^)(NSError *))errorBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    @try{
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            int toAdd=(int)operation.response.expectedContentLength;
            if(toAdd>0){
                [[NetStreamStatistics sharedInstance] appendBytesToDictionary:toAdd];
            }
            
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(errorBlock){
                errorBlock(error);
            }
        }];
    }@catch(NSException *exception){
        if(errorBlock){
            errorBlock(nil);
        }
        NSLog(@"%@",exception);
    }@finally{
        
    }
}
-(void)postJSONToServerAtURL:(NSString *)url parameters:(NSDictionary *)parameters successHandler:(void(^)(NSDictionary *))successBlock errorHandler:(void(^)(NSError *))errorBlock {
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    @try{
       [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
           int toAdd=(int)operation.response.expectedContentLength;
           if(toAdd>0){
               [[NetStreamStatistics sharedInstance] appendBytesToDictionary:toAdd];
           }
           
           if (successBlock) {
               successBlock(responseObject);
           }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if(errorBlock){
               errorBlock(error);
           }
       }];
    }@catch(NSException *exeception){
        if(errorBlock){
            errorBlock(nil);
        }
    }@finally{
        
    }
}

@end
