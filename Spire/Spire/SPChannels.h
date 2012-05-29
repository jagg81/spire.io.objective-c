//
//  SPChannels.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPResource.h"
#import "SPChannel.h"

@interface SPChannels : SPResource<SPResourceCollectionProtocol>{
    NSMutableDictionary *_channelCollection;
}

- (SPChannel *)getChannel:(NSString *)name;
- (void)addChannel:(SPChannel *)channel;
- (void)createChannel:(NSString *)name;

@end

@protocol SPChannelsDelegate <NSObject>

@required
- (void)getChannelsDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)createChannelDidFinishWithResponse:(SPHTTPResponse *)response;

@end