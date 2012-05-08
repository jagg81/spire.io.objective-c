//
//  SPApi.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSession.h"

#ifndef Spire_SPGlobal_h
#import "SPGlobal.h"
#endif

static NSString* API_VERSION = @"1.0";

@interface SPApi : NSObject{
    NSString *_baseUrl;
    NSString *_version;
}

@property(nonatomic, readonly) NSString *baseUrl;
@property(nonatomic, readonly) NSString *version;

- (void) setBaseUrl:(NSString *)baseUrl;
- (void) setVersion:(NSString *)version;

// constructors
- (id)initWithBaseURL:(NSURL *)baseURL;
- (id)initWithBaseURLString:(NSString *)baseStringURL;
- (id)initWithBaseURLString:(NSString *)baseStringURL version:(NSString *)apiVersion;

// main methods
- (void)discover;
- (SPSession *)createSession:(NSString *)accountSecret;
- (SPSession *)createAccountWithEmail:(NSString *)email password:(NSString *)password andConfirmationPassword:(NSString *)confirmationPassword;
- (SPSession *)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)resetPassword;


@end
