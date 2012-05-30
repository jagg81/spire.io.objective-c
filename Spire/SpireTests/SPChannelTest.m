//
//  SPChannelTest.m
//  Spire
//
//  Created by Jorge Gonzalez on 5/29/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPChannelTest.h"

@implementation SPChannelTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    NSString *channelName = @"fooChannel";
    [_spire createChannelWithName:channelName];
    
    if ([self waitForCompletion:30.0]) {
        _channel = [_spire.session.channels getChannel:channelName];
        SP_RELEASE_SAFELY(_response);
    }else{
        @throw [NSException exceptionWithName:@"SPChannelTestException" reason:@"Setup channel failed" userInfo:nil];
    }
    
    _done = NO;
    
}

- (void)tearDown
{
    // Tear-down code here.
    SP_RELEASE_SAFELY(_channel);
    
    [super tearDown];
}

# pragma mark - SpireDelegate
- (void)spireCreateChannelDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

# pragma mark - SPChannelDelegate
- (void)publishDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];    
}


- (void)testPublish
{
    STAssertNotNil(_channel, @"Channel object is missing");
    
    _channel.delegate = self;
    [_channel publish:@"the great message"];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to publish message");
    STAssertTrue([_response isSuccessStatusCode], @"HTTP Response code not OK");
}

@end
