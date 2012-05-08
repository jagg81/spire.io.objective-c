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
#import "SPHTTPResponseOperationDelegate.h"

@interface SPJSONRequestOperation : AFJSONRequestOperation{
    id<SPHTTPResponseOperationDelegate> _responseDelegate;
}

+ (SPJSONRequestOperation *)SPJSONRequestOperationWithRequest:(NSURLRequest *)urlRequest delegate:(id<SPHTTPResponseOperationDelegate>)delegate;

@end
