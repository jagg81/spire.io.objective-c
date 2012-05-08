//
//  SPJSONRequestOperation.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/30/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPJSONRequestOperation.h"

@implementation SPJSONRequestOperation

-(void) dealloc{
    [super dealloc];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    // In the parent class, this method checks the file extension and mime type. AFJSONRequestOperation seems to
    // make it difficult to customize the accepted mime types on the fly (instead using a bunch of class methods to
    // handle it) so for v0.1 I'm going with this kludge.
    return YES;
}

- (BOOL)hasAcceptableContentType {
    // In the parent class, this checks against a static variable, see canProcessRequest
    return YES;
}

+ (SPJSONRequestOperation *)SPJSONRequestOperationWithRequest:(NSURLRequest *)urlRequest delegate:(id<SPHTTPResponseOperationDelegate>)delegate{
    SPJSONRequestOperation *requestOperation = [[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([delegate respondsToSelector:@selector(requestDidFinish:::)]) {
            [delegate requestDidFinish:operation.request response:operation.response andData:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([delegate respondsToSelector:@selector(requestDidFail::::)]) {
            [delegate requestDidFail:operation.request response:operation.response error:error andData:[(AFJSONRequestOperation *)operation responseJSON]];
        }
    }];
    
    return requestOperation;
}

@end
