//
//  Spire.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/24/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "Spire.h"

@implementation Spire
@synthesize api = _api,
            session = _session,
            delegate = _delegate;

- (id)init
{
    self = [self initWithBaseURLString:SPIRE_URL];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [self initWithBaseURLString:[baseURL absoluteString]];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithBaseURLString:(NSString *)baseStringURL
{
    self = [super init];
    if (self) {
        _baseUrl = [baseStringURL copy];
        _api = [[SPApi alloc] initWithBaseURLString:_baseUrl];
    }
    
    return self;
}

- (id)initWithBaseURLString:(NSString *)baseStringURL version:(NSString *)apiVersion
{
    self = [self initWithBaseURLString:baseStringURL];
    if (self) {
        [_api setVersion:apiVersion];
    }
    
    return self;
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_baseUrl);
    SP_RELEASE_SAFELY(_api);
    SP_RELEASE_SAFELY(_session);
    [super dealloc];
}

# pragma mark - SPOperationManager

- (void)registerOperation:(SPOperation *)operation
{
    if (operation) {
        if (_operation) { SP_RELEASE_SAFELY(_operation); }
        _operation = [operation retain];
    }
}

- (void)performNextOperation
{
    if(_operation){
        [_operation start];
    }
    // release operation??
    SP_RELEASE_SAFELY(_operation);
}

- (BOOL)hasNextOperation
{
    NSLog(@"%i", [_operation isReady]);
    return _operation && [_operation isReady] ? YES : NO;
}

# pragma mark - PRIVATE methods

- (void)initializeApiWithNextOperation:(SPOperation *)operation
{
    [self registerOperation:operation];
    
    if (!_api.apiDescription) {
        [self discover];
    }else{
        [self performNextOperation];
    }
}

- (void)setSecretKey:(NSString *)secretKey
{
    if (_secretKey) {
        SP_RELEASE_SAFELY(_secretKey);
    }
    _secretKey = [secretKey copy];
}

//- (void)handleRegisterAccount:(SPHTTPResponse *)response
//{
//    if (![response isSuccessStatusCode]) {
//        // throw an exception handle by caller
//        @throw [NSException exceptionWithName:@"SpireException" reason:@"Register account failed" userInfo:nil];
//    }
//    
//    response.parser = [SPSession class];
//    _session = [response parseResponse];
//}


# pragma mark - PUBLIC methods - wrappers
- (void)discoverWithDelegate:(id)delegate
{
    _api.delegate = delegate;
    [_api discover];
}

- (void)startWithData:(id)data
{
    _api.delegate = self;
    [_api createSessionWithData:data];
    
    NSLog(@"Start Session Operation with data => %@", data);
}

- (void)registerWithData:(id)data
{
    _api.delegate = self;
    [_api createAccountWithData:data];
    
    NSLog(@"Register Account Operation with data => %@", data);
}

- (void)loginWithData:(id)data
{
    _api.delegate = self;
    [_api loginWithData:data];
    
    NSLog(@"Login Operation with data => %@", data);
}

# pragma mark - PUBLIC methods - API

- (void)discover
{
    [self discoverWithDelegate:self];
}

- (void)start:(NSString *)secretKey
{
    NSDictionary *data = [NSDictionary dictionaryWithObject:secretKey forKey:@"secret"];
    SPOperation *nextOperation = [[SPOperation alloc] initWithOperationData:data delegate:self andSelector:@selector(startWithData:)];
    [self initializeApiWithNextOperation:nextOperation];
}

- (void)registerWithEmail:(NSString *)email password:(NSString *)password andConfirmation:(NSString *)confirmationPassword
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:    email, @"email",
                                                                        password, @"password",
                                                                        confirmationPassword, @"password_confirmation", nil];
    SPOperation *nextOperation = [[SPOperation alloc] initWithOperationData:data delegate:self andSelector:@selector(registerWithData:)];
    [self initializeApiWithNextOperation:nextOperation];
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:    email, @"email",
                                                                        password, @"password", nil];
    SPOperation *nextOperation = [[SPOperation alloc] initWithOperationData:data delegate:self andSelector:@selector(loginWithData:)];
    [self initializeApiWithNextOperation:nextOperation];
}

- (void)channels
{
    _session.delegate = self;
    [_session retrieveChannels];
}


# pragma mark - SPHTTPResponseOperationDelegate
- (void)operationDidFinishWithResponse:(SPHTTPResponse *)response;
{
    if ([self hasNextOperation]) {
        if ([response isSuccessStatusCode]) {
            [self performNextOperation];
        }else{
            // throw an exception handle by caller
            @throw [NSException exceptionWithName:@"SpireException" reason:@"Register account failed" userInfo:nil];
        }
        return;
    }
    
    // do any custom initialization here
    NSLog(@"Spire Response delegate");
    if (_delegate && [_delegate respondsToSelector:@selector(operationDidFinishWithResponse:)] ) {
        [_delegate operationDidFinishWithResponse:response];
    }
}

# pragma mark - SPSpireApiDelegate
- (void)discoverApiDidFinishWithResponse:(SPHTTPResponse *)response
{
    if ([self hasNextOperation]) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(discoverDidFinishWithResponse:)]) {
        [_delegate discoverDidFinishWithResponse:response];
    }
}

- (void)createSessionDidFinishWithResponse:(SPHTTPResponse *)response
{
    _session = [[response parseResponseWithInfo:[_api.apiDescription getSchema]] retain];
    
    if ([self hasNextOperation]) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(startDidFinishWithResponse:)]) {
        [_delegate startDidFinishWithResponse:response];
    }
}

- (void)createAccountDidFinishWithResponse:(SPHTTPResponse *)response
{
    _session = [[response parseResponseWithInfo:[_api.apiDescription getSchema]] retain];
    
    if ([self hasNextOperation]) { return; }
        
    if (_delegate && [_delegate respondsToSelector:@selector(registerAccountDidFinishWithResponse:)]) {
        [_delegate registerAccountDidFinishWithResponse:response];
    }
}

- (void)loginApiDidFinishWithResponse:(SPHTTPResponse *)response
{
    _session = [[response parseResponseWithInfo:[_api.apiDescription getSchema]] retain];
    
    if ([self hasNextOperation]) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(loginDidFinishWithResponse:)]) {
        [_delegate loginDidFinishWithResponse:response];
    }
}

- (void)resetPasswordDidFinishWithResponse:(SPHTTPResponse *)response
{
    if ([self hasNextOperation]) { return; }
}

# pragma mark - SPSessionDelegate
- (void)retrieveChannelsDidFinishWithResponse:(SPHTTPResponse *)response
{
    if (_delegate && [_delegate respondsToSelector:@selector(channelsDidFinishWithResponse:)] ) {
        [_delegate channelsDidFinishWithResponse:response];
    }
}

@end
