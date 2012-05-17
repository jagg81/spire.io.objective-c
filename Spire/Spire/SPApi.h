//
//  SPApi.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSession.h"
#import "SPHTTPRequestFactory.h"

#ifndef Spire_SPGlobal_h
#import "SPGlobal.h"
#endif

static NSString* API_VERSION = @"1.0";

@interface SPApiDescriptionModel : SPResourceModel{
    SPResourceModel *_schema;
    SPResourceModel *_resources;
}

- (SPResourceModel *)getSchema;
- (SPResourceModel *)getResources;

- (NSString *)getMediaType:(NSString *)resource;
@end


@interface SPApi : NSObject{
    NSString *_baseUrl;
    NSString *_version;
    SPApiDescriptionModel *_apiDescription;
    id _delegate;
}

@property(nonatomic, readonly) NSString *baseUrl;
@property(nonatomic, readonly) NSString *version;
@property(nonatomic, assign) id delegate;
@property(nonatomic, readonly) SPApiDescriptionModel *apiDescription;

- (void)setBaseUrl:(NSString *)baseUrl;
- (void)setVersion:(NSString *)version;

// constructors
- (id)initWithBaseURL:(NSURL *)baseURL;
- (id)initWithBaseURLString:(NSString *)baseStringURL;
- (id)initWithBaseURLString:(NSString *)baseStringURL version:(NSString *)apiVersion;

// main methods
- (void)discover;
- (void)createSession:(NSString *)accountSecret;
- (void)createAccountWithEmail:(NSString *)email password:(NSString *)password andConfirmationPassword:(NSString *)confirmationPassword;
- (void)createAccountWithData:(NSDictionary *)data delegate:(id)delegate andSelector:(SEL)selector;
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)resetPassword;


@end
