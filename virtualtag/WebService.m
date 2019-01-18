//
//  WebService.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-15.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "WebService.h"
#import "NetworkErrorAlertView.h"
#import "User.h"
#import "VirtualTag.h"

NSString* BASE_URL = @"http://virtualtag-backend.herokuapp.com/";

@interface WebService ()

@property(nonatomic,strong) NSString* basicAuth;

@end

@implementation WebService

+(WebService*) sharedInstance
{
    static dispatch_once_t once;
    static WebService* instance = nil;
    if(!instance)
    {
        dispatch_once(&once, ^{
            instance = [WebService new];
            instance.requestSerializer = [AFJSONRequestSerializer serializer];
            instance.responseSerializer = [AFJSONResponseSerializer serializer];
            
            instance.responseSerializer.acceptableStatusCodes =
            [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 499)];
        });
    }
    return instance;
}


-(id)init
{
    if(self = [super initWithBaseURL:[NSURL URLWithString:BASE_URL]])
    {
    }
    return self;
}

-(void)setBasicAuthWithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSData* basicAuthData = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    self.basicAuth = [basicAuthData base64EncodedStringWithOptions:0];
    
    [[WebService sharedInstance].requestSerializer
     setValue:[NSString stringWithFormat:@"Basic %@",self.basicAuth]
     forHTTPHeaderField:@"Authorization"];
}

#pragma mark -
#pragma mark POST /users

-(void)createUser:(User*)user
       completion:(WebServiceCompletionBlock)completion
            error:(WebServiceErrorBlock)error
          finally:(WebServiceFinallyBlock)finally
{
    [self POST:@"users"
    parameters:@{
                 @"name" : user.name,
                 @"password" : user.password
                 }
       success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         if(completion) completion(response.statusCode);
         if(finally) finally();
     }
       failure:^(NSURLSessionDataTask *task, NSError *e) {
           NSLog(@"%@",e);
           dispatch_async(dispatch_get_main_queue(), ^{
               [[NetworkErrorAlertView new] show];
           });
           if(error) error(e);
           if(finally) finally();
       }];
}

#pragma mark -
#pragma mark GET /virtualtags

-(void)fetchVirtualTagsWithCompletion:(WebServiceCompletionArrayBlock)completion
                                error:(WebServiceErrorBlock)error
                              finally:(WebServiceFinallyBlock)finally
{
    [self GET:@"virtualtags" parameters:@{}
      success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSArray* jsonArray = responseObject[@"virtual_tags"];
         NSArray* virtualTags = [NSArray fromDictionaryArray:jsonArray of:[VirtualTag class]];
         if(completion) completion(virtualTags, response.statusCode);
         if(finally) finally();
     } failure:^(NSURLSessionDataTask *task, NSError *e) {
         NSLog(@"%@",e);
         dispatch_async(dispatch_get_main_queue(), ^{
             [[NetworkErrorAlertView new] show];
         });
         if(error) error(e);
         if(finally) finally();
     }];
}

#pragma mark -
#pragma mark GET /virtualtags/{id}

-(void)fetchVirtualTagWithId:(NSString*)identifier
                completion:(WebServiceCompletionObjectBlock)completion
                     error:(WebServiceErrorBlock)error
                   finally:(WebServiceFinallyBlock)finally
{
    [self GET:[@"virtualtags/" stringByAppendingString:identifier] parameters:@{}
      success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         id jsonObject = responseObject[@"virtual_tag"];
         if(completion) completion([[VirtualTag new] fromDictionary:jsonObject], response.statusCode);
         if(finally) finally();
     } failure:^(NSURLSessionDataTask *task, NSError *e) {
         NSLog(@"%@",e);
         dispatch_async(dispatch_get_main_queue(), ^{
             [[NetworkErrorAlertView new] show];
         });
         if(error) error(e);
         if(finally) finally();
     }];
}

#pragma mark -
#pragma mark POST /virtualtags

-(void)createVirtualTag:(VirtualTag*)virtualTag
             completion:(WebServiceCompletionObjectBlock)completion
                  error:(WebServiceErrorBlock)error
                finally:(WebServiceFinallyBlock)finally
{
    [self POST:@"virtualtags" parameters:@{@"virtual_tag" : [virtualTag dictionaryRepresentation]}
       success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         if(completion) completion(responseObject[@"created_virtual_tag_id"],response.statusCode);
         if(finally) finally();
     } failure:^(NSURLSessionDataTask *task, NSError *e) {
         NSLog(@"%@",e);
         dispatch_async(dispatch_get_main_queue(), ^{
             [[NetworkErrorAlertView new] show];
         });
         if(error) error(e);
         if(finally) finally();
     }];
}

#pragma mark -
#pragma mark DELETE /virtualtags/{id}

-(void)deleteVirtualTagWithId:(NSString*)identifier
                   completion:(WebServiceCompletionBlock)completion
                        error:(WebServiceErrorBlock)error
                      finally:(WebServiceFinallyBlock)finally
{
    [self DELETE:[@"virtualtags/" stringByAppendingString:identifier] parameters:@{}
         success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         if(completion) completion(response.statusCode);
         if(finally) finally();
     } failure:^(NSURLSessionDataTask *task, NSError *e) {
         NSLog(@"%@",e);
         dispatch_async(dispatch_get_main_queue(), ^{
             [[NetworkErrorAlertView new] show];
         });
         if(error) error(e);
         if(finally) finally();
     }];
}

@end
