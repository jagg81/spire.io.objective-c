//
//  SPJSONRequestOperation.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/30/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPJSONRequestOperation.h"

@implementation SPJSONRequestOperation

-(void) dealloc
{
    [super dealloc];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request 
{
    // In the parent class, this method checks the file extension and mime type. AFJSONRequestOperation seems to
    // make it difficult to customize the accepted mime types on the fly (instead using a bunch of class methods to
    // handle it) so for v0.1 I'm going with this kludge.
    return YES;
}

- (BOOL)hasAcceptableContentType 
{
    // In the parent class, this checks against a static variable, see canProcessRequest
    return YES;
}

+ (SPJSONRequestOperation *)SPJSONRequestOperationWithRequest:(NSURLRequest *)urlRequest delegate:(id<SPHTTPRequestOperationDelegate>)delegate
{    
    SPJSONRequestOperation *requestOperation = [[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([delegate respondsToSelector:@selector(requestDidFinish:response:andData:)]) {
            [delegate requestDidFinish:operation.request response:operation.response andData:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([delegate respondsToSelector:@selector(requestDidFail:response:error:andData:)]) {
            [delegate requestDidFail:operation.request response:operation.response error:error andData:[(AFJSONRequestOperation *)operation responseJSON]];
        }
    }];
    
    return requestOperation;
}

+ (SPJSONRequestOperation *)SPJSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                            success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success 
                                                            failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    SPJSONRequestOperation *requestOperation = [[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(AFJSONRequestOperation *)operation responseJSON]);
        }
    }];
    
    return requestOperation;
}

@end
