//
//  SPOperationCreateChannels.m
//  Spire
//
//  Created by Jorge Gonzalez on 5/25/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPOperationCreateChannels.h"

@implementation SPOperationCreateChannels

- (id)initWithOperationData:(NSDictionary *)data delegate:(id)delegate andSelector:(SEL)selector
{
    self = [super initWithOperationData:data delegate:delegate andSelector:selector];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
        _channelCount = 0;
    }
    
    return self;
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_queue);
    [super dealloc];
}

- (void)main
{	
    [self setState:SPOperationExecutingState];
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    
    NSArray *channelList = [_data objectForKey:@"channelList"];
    SPChannels *channels = [_data objectForKey:@"channels"];
    
    if (channels && [channelList count] > 0) {
        for (NSString *channelName in channelList) {
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:    channelName, @"channel",
                                                                                channels, @"channels", nil];
            SPOperationCreateChannel *nextOperation = [[SPOperationCreateChannel alloc] initWithOperationData:data delegate:self andSelector:@selector(createChannelDidFinishWithResponse:)];
            [_queue addOperation:nextOperation];
            [nextOperation release];
        }
    }
    
	[pool release];
}

# pragma mark - SPHTTPChannelsDelegate
- (void)getChannelsDidFinishWithResponse:(SPHTTPResponse *)response
{
//    NSLog(@"Done getting channels");
    [self finish];
    // notify delegate
    if (_delegate && [_delegate respondsToSelector:_selector] ) {
        [_delegate performSelector:_selector withObject:_data];
    }
}

- (void)createChannelDidFinishWithResponse:(SPHTTPResponse *)response
{
//    NSLog(@"Operation count %i", [_queue operationCount]);
    _channelCount++;
    NSArray *channelList = [_data objectForKey:@"channelList"];
    
    if (_channelCount == [channelList count]) {
        NSLog(@"Done creating channels");
        SPChannels *channels = [_data objectForKey:@"channels"];
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: channels, @"channels", nil];
        SPOperationGetChannels *nextOperation = [[SPOperationGetChannels alloc] initWithOperationData:data delegate:self andSelector:@selector(getChannelsDidFinishWithResponse:)];
        [_queue addOperation:nextOperation];
        [nextOperation release];
    }
}

@end


@implementation SPOperationCreateChannel
- (void)main
{	
    [self setState:SPOperationExecutingState];
    
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    
    NSString *channel = [_data objectForKey:@"channel"];
    SPChannels *channels = [_data objectForKey:@"channels"];
    channels.delegate = self;
    [channels createChannel:channel];
}

# pragma mark - SPHTTPChannelsDelegate
- (void)getChannelsDidFinishWithResponse:(SPHTTPResponse *)response
{
    NSLog(@"get all channels");
}

- (void)createChannelDidFinishWithResponse:(SPHTTPResponse *)response
{
//    NSLog(@"channel response %i", [response statusCode]);
//    NSLog(@"create next channel");
    if (_delegate && [_delegate respondsToSelector:_selector] ) {
        [_delegate performSelector:_selector withObject:response];
    }
    [self finish];
}

@end

@implementation SPOperationGetChannels
- (void)main
{	
    [self setState:SPOperationExecutingState];
    
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    
    SPChannels *channels = [_data objectForKey:@"channels"];
    channels.delegate = self;
    [channels doGet];
}

# pragma mark - SPHTTPChannelsDelegate
- (void)getChannelsDidFinishWithResponse:(SPHTTPResponse *)response
{
//    NSLog(@"channel response %i", [response statusCode]);
//    NSLog(@"get all channels");
    if (_delegate && [_delegate respondsToSelector:_selector] ) {
        [_delegate performSelector:_selector withObject:response];
    }
    [self finish];
}

- (void)createChannelDidFinishWithResponse:(SPHTTPResponse *)response
{
    NSLog(@"create next channel");
}

@end