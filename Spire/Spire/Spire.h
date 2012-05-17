//
//  Spire.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/24/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPOperation.h"
#import "SPApi.h"

#ifndef Spire_SPGlobal_h
#import "SPGlobal.h"
#endif

//static NSString* SPIRE_URL = @"https://api.spire.io";
static NSString* SPIRE_URL = @"http://localhost:1337";

@interface Spire : NSObject<SPOperationManager, SPSpireApiDelegate>{
    NSString *_baseUrl;
    SPApi *_api;
    SPSession *_session;
    id _delegate;
    SPOperation *_operation;
    
    NSString *_secretKey;
}

@property(nonatomic, readonly) SPApi *api;
@property(nonatomic, readonly) SPSession *session;
@property(nonatomic, assign) id delegate;

// constructors
- (id)initWithBaseURL:(NSURL *)baseURL;
- (id)initWithBaseURLString:(NSString *)baseStringURL;
- (id)initWithBaseURLString:(NSString *)baseStringURL version:(NSString *)apiVersion;

// main methods
- (void)discover;
- (void)discoverWithDelegate:(id)delegate;
- (void)start:(NSString *)secretKey;
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)registerWithEmail:(NSString *)email password:(NSString *)password andConfirmation:(NSString *)confirmationPassword;
- (void)deleteAccount;

// wrapper for resources
- (SPChannels *)channels;
- (SPChannel *)createChannel;
- (SPSubscriptions *)subscriptions;
- (SPSubscription *)subscribe:(NSString *)subscriptionName channels:(NSArray *)channels;
- (SPSubscription *)subscribe:(NSString *)subscriptionName, ...;

@end


@protocol SPSpireDelegate <NSObject>

@optional
- (void)discoverDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)startDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)loginDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)registerAccountDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)deleteAccountDidFinishWithResponse:(SPHTTPResponse *)response;
@end
