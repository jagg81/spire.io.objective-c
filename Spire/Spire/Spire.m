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
//- (void)performSelector:(SEL)selector withCallback:(SEL)callback
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

- (void)handleRegisterAccount:(SPHTTPResponse *)response
{
    //    NSLog(@"%@", response.responseData);
    if (![response isSuccessStatusCode]) {
        // throw an exception handle by caller
        @throw [NSException exceptionWithName:@"SpireException" reason:@"Register account failed" userInfo:nil];
    }
    
    response.parser = [SPSession class];
    _session = [response parseResponse];
}


# pragma mark - PUBLIC methods - wrappers

- (void)startWithData:(id)data
{
    NSString *secretKey = [data objectForKey:@"secret_key"];
//    _api.delegate = self;
//    [_api createSession:secretKey];
    
    NSLog(@"start Operation with secretKey => %@", secretKey);
//    [self responseOperationDidFinishWithResponse:nil];
}

- (void)registerWithData:(id)data
{
//    NSString *email = [data objectForKey:@"email"];
//    NSString *password = [data objectForKey:@"password"];
//    NSString *confirmationPassword = [data objectForKey:@"confirmation_password"];
//    _api.delegate = self;
    [_api createAccountWithData:data delegate:self andSelector:@selector(handleRegisterAccount:)];
    
    NSLog(@"start Operation with secretKey => %@", nil);
    //    [self responseOperationDidFinishWithResponse:nil];
}

# pragma mark - PUBLIC methods - API

- (void)discover
{
    _api.delegate = self;
    [_api discover];
}

- (void)start:(NSString *)secretKey
{
//    [self setSecretKey:secretKey];
//    [self initializeApiWithCallback:@selector(start)];
    NSDictionary *data = [NSDictionary dictionaryWithObject:secretKey forKey:@"secret_key"];
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


# pragma mark - SPHTTPResponseOperationDelegate

- (void)responseOperationDidFinishWithResponse:(SPHTTPResponse *)response
{
    if ([self hasNextOperation]) {
        [self performNextOperation];
        return;
    }
    
    // do any custom initialization here
    NSLog(@"Spire Response delegate");
    if (_delegate && [_delegate respondsToSelector:@selector(responseOperationDidFinishWithResponse:)] ) {
        [_delegate responseOperationDidFinishWithResponse:response];
    }
}

@end
