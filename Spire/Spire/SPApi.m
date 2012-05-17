//
//  SPApi.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPApi.h"

@implementation SPApiDescriptionModel

- (id)initWithRawModel:(id)rawModel
{
    self = [super initWithRawModel:rawModel];
    if (self) {
        id rawData = [self getProperty:@"schema"];
        _schema = [[SPResourceModel alloc] initWithRawModel:rawData];
        rawData = [self getProperty:@"resources"];
        _resources = [[SPResourceModel alloc] initWithRawModel:rawData];
    }
    
    return self;
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_schema);
    SP_RELEASE_SAFELY(_resources);
    [super dealloc];
}

- (NSString *)getMediaType:(NSString *)resource
{
    return [[[_schema getProperty:API_VERSION] objectForKey:resource] objectForKey:@"mediaType"];
}

- (SPResourceModel *)getResource:(NSString *)type
{
    id rawData = [_resources getProperty:type];
    return [SPResourceModel createResourceModel:rawData];
}


@end


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
        _version = API_VERSION;
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

- (void)responseOperationDidFinishWithResponse:(SPHTTPResponse *)response
{
    // do any custom initialization here
    NSLog(@"API Response delegate");
    if (_delegate && [_delegate respondsToSelector:@selector(responseOperationDidFinishWithResponse:)] ) {
        [_delegate responseOperationDidFinishWithResponse:response];
    }
}

- (void)handleDiscover:(SPHTTPResponse *)response
{
//    NSLog(@"Response is back, fool");
//    NSLog(@"Status Code => %i", [response.response statusCode]);
//    NSLog(@"%@", response.responseData);
    
    if (![response isSuccessStatusCode]) {
        // throw an exception handle by caller
        @throw [NSException exceptionWithName:@"SpireException" reason:@"discover failed" userInfo:nil];
    }
        
    SPResourceModel *apiDescription = [SPApiDescriptionModel createResourceModel:response.responseData];
    [self setApiDescriptionModel:apiDescription];
    
//    NSLog(@"%@", [_apiDescription getProperty:@"schema"] );
//    NSLog(@"%@", [response.responseData objectForKey:@"schema"]);

}

- (void)discover{
    SPHTTPRequestData *data = [SPHTTPRequestData createRequestData];
    data.type = SPHTTPRequestTypeGET;
    data.url = _baseUrl;
    data.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"Accept", nil];

    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:self selector:@selector(handleDiscover:)] autorelease];
//    response.responseDelegate = _delegate;
    [request send:data response:response];
}

- (void)createAccountWithData:(NSDictionary *)data delegate:(id)delegate andSelector:(SEL)selector
{
    SPHTTPRequestData *requestData = [SPHTTPRequestData createRequestData];
    requestData.type = SPHTTPRequestTypePOST;
    requestData.url = [[_apiDescription getResource:@"accounts"] getProperty:@"url"];
    
    NSString *contentType = [_apiDescription getMediaType:@"account"];
    NSString *accept = [_apiDescription getMediaType:@"session"];
    requestData.headers = [NSDictionary dictionaryWithObjectsAndKeys:   accept, @"Accept", 
                                                                        contentType, @"Content-Type", nil];
    requestData.body = data;
    
    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:delegate selector:selector] autorelease];
//    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:self] autorelease];
//    response.parser = [SPSession class];
    //    response.responseDelegate = _delegate;
    [request send:requestData response:response];    
}

- (void)createAccountWithEmail:(NSString *)email password:(NSString *)password andConfirmationPassword:(NSString *)confirmationPassword
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:    email, @"email",
                          password, @"password",
                          confirmationPassword, @"password_confirmation", nil];
    [self createAccountWithData:data delegate:self andSelector:nil];
}


@end
