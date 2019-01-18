//
//  WebService.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-15.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class User, VirtualTag;

typedef void(^WebServiceCompletionBlock)(NSInteger statusCode);
typedef void(^WebServiceCompletionObjectBlock)(id object, NSInteger statusCode);
typedef void(^WebServiceCompletionArrayBlock)(NSArray* objects, NSInteger statusCode);
typedef void(^WebServiceErrorBlock)(NSError* error);
typedef void(^WebServiceFinallyBlock)();

@interface WebService : AFHTTPSessionManager

+(WebService*) sharedInstance;

-(void)setBasicAuthWithUsername:(NSString*)username andPassword:(NSString*)password;

-(void)createUser:(User*)user
       completion:(WebServiceCompletionBlock)completion
            error:(WebServiceErrorBlock)error
          finally:(WebServiceFinallyBlock)finally;

-(void)fetchVirtualTagsWithCompletion:(WebServiceCompletionArrayBlock)completion
                                error:(WebServiceErrorBlock)error
                              finally:(WebServiceFinallyBlock)finally;

-(void)fetchVirtualTagWithId:(NSString*)identifier
                completion:(WebServiceCompletionObjectBlock)completion
                     error:(WebServiceErrorBlock)error
                   finally:(WebServiceFinallyBlock)finally;

-(void)createVirtualTag:(VirtualTag*)virtualTag
             completion:(WebServiceCompletionObjectBlock)completion
                  error:(WebServiceErrorBlock)error
                finally:(WebServiceFinallyBlock)finally;

-(void)deleteVirtualTagWithId:(NSString*)identifier
                   completion:(WebServiceCompletionBlock)completion
                        error:(WebServiceErrorBlock)error
                      finally:(WebServiceFinallyBlock)finally;

@end
