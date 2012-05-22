//
//  SpireTests.m
//  SpireTests
//
//  Created by Jorge Gonzalez on 4/24/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SpireTests.h"
#import "AFHTTPRequestOperationLogger.h"

@implementation SpireTests

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (!_done);
    
    return _done;
}

- (NSString *)uniqueEmail
{
    double currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"test+objcClient+%d@spire.io", currentTime];
}

- (void)setUp
{
    [super setUp];
    // Set-up code here.
    
    // start logger
//    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];

    // setup spire object
    _email = [self uniqueEmail];
    _password = @"carlospants";
    _spire = [[Spire alloc] init];
    _spire.delegate = self;
    [_spire registerWithEmail:_email password:_password andConfirmation:_password];
    if ([self waitForCompletion:30.0]) {
        _secret = [_spire.session.account getSecret];
        SP_RELEASE_SAFELY(_response);
    }else{
        @throw [NSException exceptionWithName:@"SpireTestException" reason:@"Setup account registration failed" userInfo:nil];
    }
    
    _done = NO;
}

- (void)tearDown
{
    // Tear-down code here.
    SP_RELEASE_SAFELY(_spire);
    SP_RELEASE_SAFELY(_response);
    [super tearDown];
}

//- (void)operationDidFinishWithResponse:(SPHTTPResponse *)response
//{
//    NSLog(@"SpireTests Response complete");
//    _response = response;
//    _done = YES;
//}

- (void)handleResponse:(SPHTTPResponse *)response
{
    NSLog(@"SpireTests Response complete");
    _response = [response retain];
    _done = YES;
}

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

- (void)channelsDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];    
}


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
    STAssertTrue([self waitForCompletion:30.0], @"Failed to start session with secret key");
    STAssertNotNil(spire.session, @"Session object is missing");
    STAssertNotNil (spire.session.account, @"Account object is missing");
    STAssertTrue([_secret isEqualToString:[spire.session.account getSecret]], @"Account secret is not the same");
}

- (void)testChannels
{
    [_spire channels];
    STAssertTrue([self waitForCompletion:30.0], @"Failed to start session with secret key");
    STAssertNotNil(_spire.session.channels, @"Channels object is missing");
    STAssertNotNil([_spire.session.channels getUrl], @"Channels url is missing");
    STAssertNotNil([_spire.session.channels getCapability], @"Channels capability is missing");
}


@end
