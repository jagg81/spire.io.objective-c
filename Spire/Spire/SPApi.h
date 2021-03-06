//
//  SPApi.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSession.h"


extern NSString* SP_API_VERSION;

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
- (void)createSessionWithData:(NSDictionary *)data;
- (void)createAccountWithEmail:(NSString *)email password:(NSString *)password andConfirmationPassword:(NSString *)confirmationPassword;
- (void)createAccountWithData:(NSDictionary *)data;
- (void)loginWithData:(NSDictionary *)data;
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)resetPassword;


@end


@protocol SPSpireApiDelegate <NSObject>

@optional
- (void)discoverApiDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)createSessionDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)createAccountDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)loginApiDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)resetPasswordDidFinishWithResponse:(SPHTTPResponse *)response;
@end
