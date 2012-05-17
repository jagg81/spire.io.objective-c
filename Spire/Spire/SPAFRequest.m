//
//  SPAFRequest.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/30/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPAFRequest.h"
#import "AFHTTPRequestOperationLogger.h"

@implementation SPAFRequest


- (id)init
{
    self = [super init];
    if (self) {
//        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

-(void) dealloc{
    [super dealloc];
}

-(void) send:(SPHTTPRequestData *)data response:(SPHTTPResponse *)response
{
    [super send:data response:response];

#if SP_LOGGER_ON
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
#endif
        
    NSURLRequest *request = [data generateHTTPRequest];
    SPJSONRequestOperation *operation = [SPJSONRequestOperation SPJSONRequestOperationWithRequest:request delegate:response];
//    [_queue setMaxConcurrentOperationCount:1];
    [operation start];
}


+(SPHTTPRequest *) createRequest{
    return [[[SPAFRequest alloc] init] autorelease];
}


@end

