//
//  SPHTTPRequest.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHTTPRequestData.h"
#import "SPHTTPResponse.h"

@interface SPHTTPRequest : NSObject{
    NSInteger _connectionTimeout;
    SPHTTPRequestData *_requestData;
    SPHTTPResponse *_response;
}

-(void) setRequestData:(SPHTTPRequestData *)data;
-(void) setResponse:(SPHTTPResponse *)response;

-(void) send:(SPHTTPRequestData *)data response:(SPHTTPResponse *)response;

+(SPHTTPRequest *) createRequest;

@end
