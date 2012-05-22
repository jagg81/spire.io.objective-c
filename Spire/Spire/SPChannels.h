//
//  SPChannels.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPResource.h"
#import "SPChannel.h"

@interface SPChannels : SPResource{
    NSMutableDictionary *_channelCollection;
}

@end

@protocol SPChannelsDelegate <NSObject>

@optional
- (void)getChannelsDidFinishWithResponse:(SPHTTPResponse *)response;

@end