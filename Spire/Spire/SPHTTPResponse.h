//
//  SPHTTPResponse.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHTTPResponseOperationDelegate.h"

@interface SPHTTPResponse : NSObject<SPHTTPResponseOperationDelegate>{
    NSURLRequest *_request;
    NSURLResponse *_response;
    
    id _delegate;
    SEL _selector;
}

-(id) initWithDelegate:(id)delegate selector:(SEL)selector;

-(void) handleResponse:(id)data;

@end
