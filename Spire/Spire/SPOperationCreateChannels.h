//
//  SPOperationCreateChannels.h
//  Spire
//
//  Created by Jorge Gonzalez on 5/25/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPOperation.h"
#import "SPChannels.h"

@interface SPOperationCreateChannels : SPOperation<SPChannelsDelegate>{
    NSOperationQueue *_queue;
    NSInteger _channelCount;
}

@end

@interface SPOperationCreateChannel : SPOperation<SPChannelsDelegate>{
}
@end

@interface SPOperationGetChannels : SPOperation<SPChannelsDelegate>{
}
@end
