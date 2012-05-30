//
//  SPSpireTestBase.h
//  Spire
//
//  Created by Jorge Gonzalez on 5/29/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.

#import <SenTestingKit/SenTestingKit.h>
#import "SpireClient.h"

@interface SPSpireTestBase : SenTestCase{
    Spire *_spire;
    BOOL _done;
    NSString *_email;
    NSString *_password;
    
    NSString *_secret;
    
    SPHTTPResponse *_response;
}


- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs;
- (NSString *)uniqueEmail;
- (void)handleResponse:(SPHTTPResponse *)response;

@end
