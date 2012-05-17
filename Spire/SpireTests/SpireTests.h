//
//  SpireTests.h
//  SpireTests
//
//  Created by Jorge Gonzalez on 4/24/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SpireClient.h"

@interface SpireTests : SenTestCase<SPHTTPResponseOperationDelegate>{
    Spire *_spire;
    BOOL _done;
    NSString *_email;
    NSString *_password;
    
    NSString *_secret;
    
    SPHTTPResponse *_response;
}

@end
