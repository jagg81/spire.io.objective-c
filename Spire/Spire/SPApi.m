//
//  SPApi.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPApi.h"

NSString* SP_API_VERSION = @"1.0";

@implementation SPApi
@synthesize baseUrl = _baseUrl,
            version = _version,
            delegate = _delegate,
            apiDescription = _apiDescription;


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
        _version = SP_API_VERSION;
    }
    
    return self;
}

- (id)initWithBaseURLString:(NSString *)baseStringURL version:(NSString *)apiVersion
{
    self = [self initWithBaseURLString:baseStringURL];
    if (self) {
        _version = [apiVersion copy];
    }
    
    return self;
}


- (void)dealloc{
    SP_RELEASE_SAFELY(_baseUrl);
    SP_RELEASE_SAFELY(_version);
    SP_RELEASE_SAFELY(_version);
    [super dealloc];
}

- (SPResourceModel *)getResourceModel:(NSString *)resourceName
{
    SPResourceModel *resources = [_apiDescription getResources];
    return [resources getResourceModel:resourceName];
}

- (void) setBaseUrl:(NSString *)baseUrl{
    if(_baseUrl){ SP_RELEASE_SAFELY(_baseUrl); }
    _baseUrl = [baseUrl retain];
}

- (void) setVersion:(NSString *)version{
    if(_version){ SP_RELEASE_SAFELY(_version); }
    _version = [version retain];
}

- (void) setApiDescriptionModel:(id)model{
    if(_apiDescription){ SP_RELEASE_SAFELY(_apiDescription); }
    _apiDescription = [model retain];
}





# pragma mark - SPHTTPResponseOperationDelegate
- (void)operationDidFinishWithResponse:(SPHTTPResponse *)response;
{
    // do any custom initialization here
    NSLog(@"API Response delegate");
    if (_delegate && [_delegate respondsToSelector:@selector(operationDidFinishWithResponse:)] ) {
        [_delegate operationDidFinishWithResponse:response];
    }
}

- (void)handleDiscover:(SPHTTPResponse *)response
{
    if (![response isSuccessStatusCode]) {
        // throw an exception handle by caller
        @throw [NSException exceptionWithName:@"SpireException" reason:@"discover failed" userInfo:nil];
    }
        
    SPResourceModel *apiDescription = [response parseResponseWithInfo:nil];
    [self setApiDescriptionModel:apiDescription];
    
    if (_delegate && [_delegate respondsToSelector:@selector(discoverApiDidFinishWithResponse:)] ) {
        [_delegate discoverApiDidFinishWithResponse:response];
    }
}

- (void)discover{
    SPHTTPRequestData *data = [SPHTTPRequestData createRequestData];
    data.type = SPHTTPRequestTypeGET;
    data.url = _baseUrl;
    data.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"Accept", nil];

    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:self selector:@selector(handleDiscover:)] autorelease];
    response.parser = [SPApiDescriptionModel class];
    [request send:data response:response];
}

- (void)createAccountWithData:(NSDictionary *)data
{
    SPHTTPRequestData *requestData = [SPHTTPRequestData createRequestData];
    requestData.type = SPHTTPRequestTypePOST;
    requestData.url = [[self getResourceModel:@"accounts"] getProperty:@"url"];    
    NSString *contentType = [[_apiDescription getSchema] getMediaType:@"account"];
    NSString *accept = [[_apiDescription getSchema] getMediaType:@"session"];
    requestData.headers = [NSDictionary dictionaryWithObjectsAndKeys:   accept, @"Accept", 
                                                                        contentType, @"Content-Type", nil];
    requestData.body = data;
    
    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:_delegate selector:@selector(createAccountDidFinishWithResponse:)] autorelease];
    response.parser = [SPSession class];
    [request send:requestData response:response];
}

- (void)createAccountWithEmail:(NSString *)email password:(NSString *)password andConfirmationPassword:(NSString *)confirmationPassword
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:  email, @"email",
                                                                      password, @"password",
                                                                      confirmationPassword, @"password_confirmation", nil];
    [self createAccountWithData:data];
}

- (void)createSessionWithData:(NSDictionary *)data delegate:(id)delegate andSelector:(SEL)selector
{
    SPHTTPRequestData *requestData = [SPHTTPRequestData createRequestData];
    requestData.type = SPHTTPRequestTypePOST;
    requestData.url = [[[_apiDescription getResources] getResourceModel:@"sessions"] getProperty:@"url"];    
    NSString *contentType = [[_apiDescription getSchema] getMediaType:@"account"];
    NSString *accept = [[_apiDescription getSchema] getMediaType:@"session"];
    requestData.headers = [NSDictionary dictionaryWithObjectsAndKeys:   accept, @"Accept", 
                           contentType, @"Content-Type", nil];
    requestData.body = data;
    
    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:delegate selector:selector] autorelease];
    response.parser = [SPSession class];
    [request send:requestData response:response];    
}

- (void)createSessionWithData:(NSDictionary *)data
{
    [self createSessionWithData:data delegate:_delegate andSelector:@selector(createSessionDidFinishWithResponse:)];
}

- (void)createSession:(NSString *)accountSecret
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: accountSecret, @"secret", nil];
    [self createSessionWithData:data];
}

- (void)loginWithData:(NSDictionary *)data
{
    [self createSessionWithData:data delegate:_delegate andSelector:@selector(loginApiDidFinishWithResponse:)];
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:    email, @"email",
                                                                        password, @"password", nil];
    [self loginWithData:data];
}


@end
