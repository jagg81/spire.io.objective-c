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

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
    _spire = [[Spire alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in SpireTests");
    [_spire discover];
}

@end
