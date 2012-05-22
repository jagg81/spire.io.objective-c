//
//  SPHTTPRequestData.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPHTTPRequestData.h"
#import "AFJSONUtilities.h"

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
        _queryParams = [[NSMutableDictionary alloc] init];
        _headers = [[NSMutableDictionary alloc] init];
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

static NSString * SPJSONStringFromParameters(NSDictionary *parameters) {
    NSError *error = nil;
    NSData *JSONData = AFJSONEncode(parameters, &error);
    
    if (!error) {
        return [[[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding] autorelease];
    } else {
        return nil;
    }
}

+ (NSString *)prepareAuthorizationHeaderForCapability:(NSString *)capability
{
    return [NSString stringWithFormat:@"Capability %@", capability];
}


-(NSURLRequest *)generateHTTPRequest{
    NSURL *url = [NSURL URLWithString:self.url];
    NSError *error = nil;
    [url setResourceValues:_queryParams error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
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
        case SPHTTPRequestTypePOST:
            [request setHTTPMethod:@"POST"];
            break;
        case SPHTTPRequestTypeDELETE:
            [request setHTTPMethod:@"DELETE"];
            break;
        default:
            break;
    }
    
    if (_body) {
        [request setHTTPBody:[SPJSONStringFromParameters(_body) dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return request;
}

- (void)setHTTPHeaders:(NSDictionary *)headers
{
    if (_headers && [_headers isKindOfClass:[NSMutableDictionary class]]) {
        [_headers setValuesForKeysWithDictionary:headers];
    }
}

- (void)setHTTPHeaderValue:(NSString *)value forKey:(NSString *)key
{
    if (_headers) {
        [_headers setValue:value forKey:key];
    }
}

- (void)setHTTPAcceptHeader:(NSString *)value
{
    [self setHTTPHeaderValue:value forKey:@"Accept"];
}

- (void)setHTTPContentTypeHeader:(NSString *)value
{
    [self setHTTPHeaderValue:value forKey:@"Content-Type"];    
}

- (void)setHTTPAuthorizationHeader:(NSString *)value
{
    [self setHTTPHeaderValue:value forKey:@"Authorization"];    
}


@end
