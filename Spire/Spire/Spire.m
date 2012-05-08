//
//  Spire.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/24/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "Spire.h"

@implementation Spire

- (id)init
{
    self = [self initWithBaseURLString:SPIRE_URL];
    if (self) {
        
    }
    
    return self;
}

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
        _api = [[SPApi alloc] initWithBaseURLString:_baseUrl];
    }
    
    return self;
}

- (id)initWithBaseURLString:(NSString *)baseStringURL version:(NSString *)apiVersion
{
    self = [self initWithBaseURLString:baseStringURL];
    if (self) {
        [_api setVersion:apiVersion];
    }
    
    return self;
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_baseUrl);
    SP_RELEASE_SAFELY(_api);
    [super dealloc];
}

- (void)discover{
    [_api discover];
}


@end
