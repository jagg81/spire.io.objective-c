//
//  SPAFRequest.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/30/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPHTTPRequest.h"
#import "SPJSONRequestOperation.h"

@interface SPAFRequest : SPHTTPRequest{
    NSOperationQueue *_queue;
}

+(SPHTTPRequest *) createRequest;

@end
