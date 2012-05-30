//
//  SpireTests.m
//  SpireTests
//
//  Created by Jorge Gonzalez on 4/24/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SpireTests.h"

@implementation SpireTests

- (void)setUp
{
    [super setUp];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    
    [super tearDown];
}

//- (void)operationDidFinishWithResponse:(SPHTTPResponse *)response
//{
//    NSLog(@"SpireTests Response complete");
//    _response = response;
//    _done = YES;
//}


# pragma mark - SpireDelegate

- (void)discoverDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

- (void)startDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];    
}

- (void)loginDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

- (void)registerAccountDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

- (void)deleteAccountDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

- (void)spireChannelsDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

- (void)spireCreateChannelDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

- (void)spireSubscriptionsDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

- (void)spireSubscribeDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}

# pragma mark - Spire TEST

- (void)testDiscover
{
    //STFail(@"Unit tests are not implemented yet in SpireTests");
    [_spire discover];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to do API discover process");
    STAssertNotNil(_spire.api.apiDescription, @"Api description object is missing");
}

- (void)testRegister
{
    Spire *spire = [[Spire alloc] init];
    spire.delegate = self;
    NSString *email = [self uniqueEmail];
    NSString *password = @"somepassword";

    [spire registerWithEmail:email password:password andConfirmation:password];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to register new account");
    STAssertNotNil(spire.session, @"Session object is missing");
    STAssertNotNil(spire.session.account, @"Account object is missing");
    STAssertNotNil([spire.session.account getSecret], @"Account secret key is missing");
}

- (void)testStart
{
    [_spire start:_secret];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to start session with secret key");
    STAssertNotNil(_spire.session, @"Session object is missing");
}

- (void)testLogin
{
    Spire *spire = [[Spire alloc] init];
    spire.delegate = self;
    [spire loginWithEmail:_email andPassword:_password];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to login with email and password");
    STAssertNotNil(spire.session, @"Session object is missing");
    STAssertNotNil (spire.session.account, @"Account object is missing");
    STAssertTrue([_secret isEqualToString:[spire.session.account getSecret]], @"Account secret is not the same");
}

- (void)testChannels
{
    [_spire channels];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to get Channels");
    STAssertNotNil(_spire.session.channels, @"Channels object is missing");
    STAssertNotNil([_spire.session.channels getUrl], @"Channels url is missing");
    STAssertNotNil([_spire.session.channels getCapability], @"Channels capability is missing");
}

- (void)testCreateChannel
{
    NSString *channelName = @"someFooChannel";
    SPChannel *channel;
    
    [_spire createChannelWithName:channelName];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to create channel");
    channel = [_spire.session.channels getChannel:channelName];
    STAssertNotNil(channel, @"Channel object is missing");
    STAssertTrue([channelName isEqualToString:[channel getName]], @"Channel name is not the same");
}

- (void)testSubscriptions
{
    [_spire subscriptions];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to get Subscriptions");
    STAssertNotNil(_spire.session.subscriptions, @"Subscriptions object is missing");
    STAssertNotNil([_spire.session.subscriptions getUrl], @"Subscriptions url is missing");
    STAssertNotNil([_spire.session.subscriptions getCapability], @"Subscriptions capability is missing");
}

- (void)testSubscribe
{
    NSString *subscriptionName = @"someFooSubscription";
    NSArray *channels = [NSArray arrayWithObjects:@"barChannel1", @"barChannel2", @"barChannel3", nil];
    SPSubscription *subscription;
    
    [_spire subscribe:subscriptionName channels:channels];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to create subscription");
    subscription = [_spire.session.subscriptions getSubscription:subscriptionName];
    STAssertNotNil(subscription, @"Channel object is missing");
    STAssertTrue([subscriptionName isEqualToString:[subscription getName]], @"Subscription name is not the same");
}

@end
