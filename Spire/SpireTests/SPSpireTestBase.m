//
//  SPSpireTestBase.m
//  Spire
//
//  Created by Jorge Gonzalez on 5/29/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPSpireTestBase.h"
#import "AFHTTPRequestOperationLogger.h"

@implementation SPSpireTestBase


# pragma mark - Helpers
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

- (void)handleResponse:(SPHTTPResponse *)response
{
    NSLog(@"SpireTests Response complete");
    _response = [response retain];
    _done = YES;
}

# pragma mark - SenTestingKit
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


# pragma mark - SpireDelegate 
// (this delegate method is needed in [self setUp])
- (void)registerAccountDidFinishWithResponse:(SPHTTPResponse *)response
{
    [self handleResponse:response];
}


@end
