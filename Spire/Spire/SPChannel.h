//
//  SPChannel.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPResource.h"
#import "SPEvent.h"

@interface SPChannel : SPResource{
    
}

- (void)publish:(NSString *)content;
@end


@protocol SPChannelDelegate <NSObject>
@required
- (void)publishDidFinishWithResponse:(SPHTTPResponse *)response;

@end