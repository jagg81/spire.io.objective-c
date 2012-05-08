//
//  SPHTTPRequest.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPHTTPRequest.h"

@implementation SPHTTPRequest


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void) setRequestData:(SPHTTPRequestData *)data{
    if (_requestData) {
        SP_RELEASE_SAFELY(_requestData);
    }
    _requestData = [data retain];
}

-(void) setResponse:(SPHTTPResponse *)response{
    if (_response) {
        SP_RELEASE_SAFELY(_response);
    }
    _response = [_response retain];
}


-(void) dealloc{
    SP_RELEASE_SAFELY(_requestData);
    [super dealloc];
}

-(void) send:(SPHTTPRequestData *)data response:(SPHTTPResponse *)response
{
    
}

+(SPHTTPRequest *) createRequest{
    return [[[SPHTTPRequest alloc] init] autorelease];
}

@end
