//
//  SPSubscriptions.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPResource.h"
#import "SPSubscription.h"

@interface SPSubscriptions : SPResource<SPResourceCollectionProtocol>{
    NSMutableDictionary *_subscriptionCollection;
}

- (SPSubscription *)getSubscription:(NSString *)name;
- (void)addSubscription:(SPSubscription *)subscription;

- (void)createSubscription:(NSString *)name forChannel:(NSString *)channel;
- (void)createSubscription:(NSString *)name forChannels:(NSArray *)channels withExpiration:(NSNumber *)expiration;

@end

@protocol SPSubscritionDelegate <NSObject>

@required
- (void)getSubscriptionDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)createSubscriptionDidFinishWithRespose:(SPHTTPResponse *)response;

@end
