//
//  Session.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPResource.h"
#import "SPAccount.h"
#import "SPChannels.h"
#import "SPSubscriptions.h"

@interface SPSession : SPResource<SPHTTPResponseParser>{
    SPAccount *_account;
    SPChannels *_channels;
    SPSubscriptions *_subscriptions;
}

@property(nonatomic, readonly) SPAccount *account;
@property(nonatomic, readonly) SPChannels *channels;
@property(nonatomic, readonly) SPSubscriptions *subscriptions;

@end
