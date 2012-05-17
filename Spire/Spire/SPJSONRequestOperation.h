//
//  SPJSONRequestOperation.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/30/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFJSONRequestOperation.h"
#import "JSONKit.h"
#import "SPHTTPRequestOperationDelegate.h"

@interface SPJSONRequestOperation : AFJSONRequestOperation{
    id<SPHTTPRequestOperationDelegate> _responseDelegate;
}

+ (SPJSONRequestOperation *)SPJSONRequestOperationWithRequest:(NSURLRequest *)urlRequest delegate:(id<SPHTTPRequestOperationDelegate>)delegate;

+ (SPJSONRequestOperation *)SPJSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success 
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
