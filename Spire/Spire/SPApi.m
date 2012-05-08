//
//  SPApi.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPApi.h"
#import "SPHTTPRequestFactory.h"

@implementation SPApi
@synthesize baseUrl = _baseUrl,
            version = _version;


- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [self initWithBaseURLString:[baseURL absoluteString]];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithBaseURLString:(NSString *)baseStringURL
{
    self = [super init];
    if (self) {
        _baseUrl = [baseStringURL copy];
        _version = API_VERSION;
    }
    
    return self;
}

- (id)initWithBaseURLString:(NSString *)baseStringURL version:(NSString *)apiVersion
{
    self = [self initWithBaseURLString:baseStringURL];
    if (self) {
        _version = [apiVersion copy];
    }
    
    return self;
}


- (void)dealloc{
    SP_RELEASE_SAFELY(_baseUrl);
    SP_RELEASE_SAFELY(_version);
    [super dealloc];
}

- (void) setBaseUrl:(NSString *)baseUrl{
    if(_baseUrl){
        SP_RELEASE_SAFELY(_baseUrl);
    }
    _baseUrl = [baseUrl retain];
}

- (void) setVersion:(NSString *)version{
    if(_version){
        SP_RELEASE_SAFELY(_version);
    }
    _version = [version retain];
}

- (void)handleDiscover:(id)data{
    NSLog(@"Response is back, fool");
    NSLog(@"%@", data);
}

- (void)discover{
    SPHTTPRequestData *data = [SPHTTPRequestData createRequestData];
    data.type = SPHTTPRequestTypeGET;
    data.url = _baseUrl;
    data.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"Accept", @"application/json", nil];

    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:self selector:@selector(handleResponse:)] autorelease];
    [request send:data response:response];
}

@end
