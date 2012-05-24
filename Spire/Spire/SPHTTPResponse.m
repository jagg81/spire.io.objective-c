//
//  SPHTTPResponse.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPHTTPResponse.h"

@implementation SPHTTPResponse
@synthesize request = _request,
            response = _response,
            error = _error,
            responseData = _responseData,
            parser = _parser;
//            responseDelegate = _responseDelegate;

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}

-(id) initWithDelegate:(id)delegate selector:(SEL)selector
{
    self = [self initWithDelegate:delegate];
    if (self) {
        _selector = selector;
    }
    
    return self;
}

- (void)dealloc
{
    SP_RELEASE_SAFELY(_request);
    SP_RELEASE_SAFELY(_response);
    SP_RELEASE_SAFELY(_error);
    SP_RELEASE_SAFELY(_responseData);
    [super dealloc];
}

- (void)sendResponse
{
    // invoke response parser selector
    if (_delegate && _selector) {
        if ([_delegate respondsToSelector:_selector]) {
            [_delegate performSelector:_selector withObject:self];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(operationDidFinishWithResponse:)] ) {
        [_delegate performSelector:@selector(operationDidFinishWithResponse:) withObject:self];
    }
    
    // notifiy response delegate
    //    if (_responseDelegate && [_responseDelegate respondsToSelector:@selector(responseOperationDidFinishWithResponse:)] ) {
    //        [_responseDelegate responseOperationDidFinishWithResponse:self];
    //    }
}

- (void)handleResponse:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error andResponseData:(id)data
{
    if (_request) { SP_RELEASE_SAFELY(_request); }
    _request = [request retain];
    
    if (_response) { SP_RELEASE_SAFELY(_response); }
    _response = [response retain];
    
    if (error) {
        if (_error) { SP_RELEASE_SAFELY(_error); }
        _error = [error retain];
    }
    if (data) {
        if (_responseData) { SP_RELEASE_SAFELY(_responseData); }
        _responseData = [data retain];
    }
    
    [self sendResponse];
}

- (id)parseResponseWithParser:(Class)parser andInfo:(id)info
{
    if (parser && [parser conformsToProtocol:@protocol(SPHTTPResponseParser)]) {
        return [parser parseHTTPResponse:self withInfo:info];
    }
    return nil;
}

- (id)parseResponseWithInfo:(id)info
{
    return [self parseResponseWithParser:_parser andInfo:info];
}

# pragma mark - SPHTTPResponseOperationDelegate

- (void)requestDidFinish:(NSURLRequest *)request response:(NSHTTPURLResponse *)response andData:(id)data
{    
    [self handleResponse:request response:response error:nil andResponseData:data];
}

- (void)requestDidFail:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error andData:(id)data
{    
    [self handleResponse:request response:response error:error andResponseData:data];
}

# pragma mark - Helpers
- (BOOL)isSuccessStatusCode
{
    // FIXME: this is pretty generic, successful response not necessarily have to be 200...
    if (_response && ([_response statusCode] >= 200 && [_response statusCode] <= 206)) {
        return YES;
    }
    return NO;
}

- (NSInteger)statusCode
{
    if (_response) {
        return [_response statusCode];
    }
    return -1;
}

@end
