//
//  SPHTTPRequestFactory.m
//  Spire
//
//  Created by Jorge Gonzalez on 5/3/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPHTTPRequestFactory.h"

@implementation SPHTTPRequestFactory


+(SPHTTPRequest *) createHTTPRequest{
    return [SPAFRequest createRequest];
}

@end
