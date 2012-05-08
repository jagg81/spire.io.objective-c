//
//  SPHTTPResponse.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPHTTPResponse.h"

@implementation SPHTTPResponse


-(id) initWithDelegate:(id)delegate selector:(SEL)selector;
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _selector = selector;
    }
    
    return self;
}

-(void) dealloc{
    // TODO: release request and response objects
    [super dealloc];
}

-(void) handleResponse:(id)data
{
    if (_delegate && _selector) {
        if ([_delegate respondsToSelector:_selector]) {
            [_delegate performSelector:_selector withObject:data];
        }
    }
}

- (void)requestDidFinish:(NSURLRequest *)request response:(NSURLResponse *)response andData:(id)data{
    
    [self handleResponse:data];
}

- (void)requestDidFail:(NSURLRequest *)request response:(NSURLResponse *)response error:(NSError *)error andData:(id)data{
    
    [self handleResponse:data];
}


@end
