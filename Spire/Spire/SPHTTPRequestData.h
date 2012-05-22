//
//  SPHTTPRequestData.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPGlobal.h"

typedef enum{
    SPHTTPRequestTypeGET = 0,
    SPHTTPRequestTypePOST,
    SPHTTPRequestTypePUT,
    SPHTTPRequestTypeDELETE,
} SPHTTPRequestType;


@interface SPHTTPRequestData : NSObject{
    NSString *_url;
    NSMutableDictionary *_queryParams;
    id _body;
    SPHTTPRequestType _type;
    NSMutableDictionary *_headers;
}

@property(nonatomic, retain) NSString *url;
@property(readwrite, nonatomic, retain) NSDictionary *queryParams;
@property(nonatomic, retain) id body;
@property(nonatomic, assign) SPHTTPRequestType type;
@property(readwrite, nonatomic, retain) NSDictionary *headers;


+ (SPHTTPRequestData *)createRequestData;
- (NSURLRequest *)generateHTTPRequest;
+ (NSString *)prepareAuthorizationHeaderForCapability:(NSString *)capability;

- (void)setHTTPHeaderValue:(NSString *)value forKey:(NSString *)key;
- (void)setHTTPHeaders:(NSDictionary *)headers;
- (void)setHTTPAcceptHeader:(NSString *)value;
- (void)setHTTPContentTypeHeader:(NSString *)value;
- (void)setHTTPAuthorizationHeader:(NSString *)value;
@end
