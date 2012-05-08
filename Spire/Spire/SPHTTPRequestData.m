//
//  SPHTTPRequestData.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPHTTPRequestData.h"

@implementation SPHTTPRequestData

@synthesize url = _url,
            queryParams = _queryParams,
            body = _body,
            type = _type,
            headers = _headers;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void) dealloc{
    SP_RELEASE_SAFELY(_url);
    SP_RELEASE_SAFELY(_queryParams);
    SP_RELEASE_SAFELY(_body);
    SP_RELEASE_SAFELY(_headers);
    [super dealloc];
}

+(SPHTTPRequestData *) createRequestData{
    return [[[SPHTTPRequestData alloc] init] autorelease];
}

-(NSURLRequest *)generateHTTPRequest{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    for (id key in [_headers allKeys]) {
        id value = [_headers valueForKey:key];
        [request addValue:value forHTTPHeaderField:key];
    }
    
    switch (_type) {
        case SPHTTPRequestTypeGET:
            [request setHTTPMethod:@"GET"];
            break;
        case SPHTTPRequestTypePUT:
            [request setHTTPMethod:@"PUT"];
            break;
        default:
            break;
    }
    
    return request;
}


@end
