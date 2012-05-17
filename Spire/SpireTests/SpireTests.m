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
    time_t currentTime = (time_t)[[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"test+objcClient+%d@spire.io", currentTime];
}

- (void)setUp
{
    [super setUp];
    // Set-up code here.
    
    _email = [self uniqueEmail];
    _password = @"carlospants";
    
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
    _spire = [[Spire alloc] init];
    _spire.delegate = self;
    
    // register
    
    // get secretKey (or application key??)
    _secret = @"Ac-18298923iu23e";
    _done = NO;
}

- (void)tearDown
{
    // Tear-down code here.
    [_spire release];
    [super tearDown];
}

- (void)responseOperationDidFinishWithResponse:(SPHTTPResponse *)response
{
    NSLog(@"SpireTests Response complete");
    _response = response;
    _done = YES;
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
    //    STAssertNotNil(_spire.session, @"Api description object is missing");
    
}

- (void)testStart
{
//    [_spire start:_secret];
//    STAssertTrue([self waitForCompletion:30.0], @"Failed to do API discover process");
//    STAssertNotNil(_spire.session, @"Api description object is missing");
    
//    [_spire start:_secret];
//    STAssertTrue([self waitForCompletion:30.0], @"Failed to do Start");
}

- (void)testLogin
{
    //    [_spire start:_secret];
    //    STAssertTrue([self waitForCompletion:30.0], @"Failed to do API discover process");
    //    STAssertNotNil(_spire.session, @"Api description object is missing");
}


@end
