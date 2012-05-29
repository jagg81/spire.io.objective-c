//
//  SPResource.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPResource.h"

@implementation SPResource
@synthesize delegate = _delegate;

# pragma mark - To be overriden by subclasses (optional)
- (void)initialize
{
    id rawCaps = [_model getProperty:@"capabilities"];
    _capabilities = [[SPResourceCapabilityModel alloc] initWithRawModel:rawCaps];
}

- (void)updateModel:(id)rawModel
{
//    [_model setProperty:@"resources" value:rawModel];     // this is for collections....
    SPResourceModel *updatedModel = [SPResourceModel createResourceModel:rawModel];
    if (_model) {
        SP_RELEASE_SAFELY(_model);
    }
    _model = [updatedModel retain];
    [self initialize];
}

+ (NSString *)resourceName
{
    return nil;
}

# pragma mark - Constructors
- (id)init
{
    self = [super init];
    if (self) {
        id rawModel = [[[NSMutableDictionary alloc] init] autorelease];
        _model = [[SPResourceModel alloc] initWithRawModel:rawModel];
    }
    
    return self;
}

- (id)initWithResourceModel:(SPResourceModel *)model apiSchemaModel:(SPApiSchemaModel *)schema
{
    self = [super init];
    if (self) {
        _model = [model retain];
        _schema = [schema retain];
        [self initialize];
    }
    
    return self;
}

- (id)initWithRawResourceModel:(id)rawModel apiSchemaModel:(SPApiSchemaModel *)schema
{
    SPResourceModel *model = [SPResourceModel createResourceModel:rawModel];
    self = [self initWithResourceModel:model apiSchemaModel:schema];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_model);
    SP_RELEASE_SAFELY(_capabilities);
    [super dealloc];
}

# pragma mark - class Properties
- (NSString *)getUrl
{
    return [_model getProperty:@"url"];
}

- (void)setUrl:(NSString *)url
{
    [_model setProperty:@"url" value:url];
}

- (NSString *)getMediaType
{
    NSString *resourceName = [[self class] resourceName];
    return [_schema getMediaType:resourceName];
}

// TODO: this should handle capability type objects instead of strings
- (SPResourceCapabilityModel *)getCapability
{
    return _capabilities;
}

//- (void)setCapability:(NSString *)capability;
- (NSString *)getType
{
    return [_model getProperty:@"type"];
}

- (NSString *)getName
{
    return [_model getProperty:@"name"];
}

# pragma mark - SPHTTPResponseParser
+ (id)parseHTTPResponse:(SPHTTPResponse *)response withInfo:(id)info
{
    return [self createResourceWithRawModel:response.responseData apiSchemaModel:info];
}

# pragma mark - Public API
+ (id)createResourceWithRawModel:(id)rawModel apiSchemaModel:(SPApiSchemaModel *)schema
{
    return [[[self alloc] initWithRawResourceModel:rawModel apiSchemaModel:schema] autorelease];
}

- (SPResourceModel *)getResourceModel:(NSString *)resourceName
{
    return [_model getResourceModel:resourceName];
}

# pragma mark - SPResourceDelegate - HTTP callback handlers
- (void)getResourceDidFinishWithResponse:(id)response
{
    NSLog(@"GET Resource");
    SPHTTPResponse *httpResponse = response;
    if (!httpResponse || ![httpResponse isSuccessStatusCode]) {
        NSLog(@"Error GETing Resource");
        return;
    }
    [self updateModel:httpResponse.responseData];
}

- (void)updateResourceDidFinishWithResponse:(id)response
{
    NSLog(@"UPDATE Resource");
    SPHTTPResponse *httpResponse = response;
    if (!httpResponse || ![httpResponse isSuccessStatusCode]) {
        NSLog(@"Error UPDATing Resource");
        return;
    }
    [self updateModel:httpResponse.responseData];
}

- (void)deleteResourceDidFinishWithResponse:(id)response
{
    NSLog(@"DELETE Resource");
    SPHTTPResponse *httpResponse = response;
    if (!httpResponse || ![httpResponse isSuccessStatusCode]) {
        NSLog(@"Error DELETing Resource");
        return;
    }
}

- (void)postResourceDidFinishWithResponse:(id)response
{
    NSLog(@"POST Resource");
    SPHTTPResponse *httpResponse = response;
    if (!httpResponse || ![httpResponse isSuccessStatusCode]) {
        NSLog(@"Error POSTing Resource \t statusCode: %i", [httpResponse statusCode]);
        return;
    }
    
    if ([[self class] conformsToProtocol:@protocol(SPResourceCollectionProtocol)] &&
        [self respondsToSelector:@selector(resourceCollectionAddModel:)]) {
        [self performSelector:@selector(resourceCollectionAddModel:) withObject:httpResponse.responseData];
    }
}

# pragma mark - HTTP wrappers
- (SPHTTPRequestData *)createRequestDataWithQueryParams:(NSDictionary *)params content:(NSDictionary  *)content headers:(NSDictionary *)headers andType:(SPHTTPRequestType)type
{
    SPHTTPRequestData *data = [SPHTTPRequestData createRequestData];
    data.type = type;
    data.queryParams = params;
    data.body = content;
    NSString *accept = [self getMediaType];
    [data setHTTPAcceptHeader:accept];
    // this might not be needed for GET, but for reusability we included since every other method type should needed
    [data setHTTPContentTypeHeader:[self getMediaType]];
    NSString *capability = [SPHTTPRequestData prepareAuthorizationHeaderForCapability:[_capabilities getCapabilityForRequest:data.type]];
    [data setHTTPAuthorizationHeader:capability];
    [data setHTTPHeaders:headers];
    return data;
}

- (void)doGetWithParameters:(NSDictionary *)params andHeaders:(NSDictionary *)headers
{
    SPHTTPRequestData *data = [self createRequestDataWithQueryParams:params content:nil headers:headers andType:SPHTTPRequestTypeGET];
    data.url = [self getUrl];
    
    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:self selector:@selector(getResourceDidFinishWithResponse:)] autorelease];
    response.parser = [self class];
    [request send:data response:response];
}

- (void)doGet
{
    [self doGetWithParameters:nil andHeaders:nil];
}

- (void)doUpdate
{
    SPHTTPRequestData *data = [self createRequestDataWithQueryParams:nil content:_model.rawModel headers:nil andType:SPHTTPRequestTypePUT];
    data.url = [self getUrl];
    
    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:self selector:@selector(updateResourceDidFinishWithResponse:)] autorelease];
    response.parser = [self class];
    [request send:data response:response];
}

- (void)doDelete
{
    SPHTTPRequestData *data = [self createRequestDataWithQueryParams:nil content:nil headers:nil andType:SPHTTPRequestTypeDELETE];
    data.url = [self getUrl];
    
    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:self selector:@selector(deleteResourceDidFinishWithResponse:)] autorelease];
    response.parser = [self class];
    [request send:data response:response];
}

- (void)doPostWithContent:(NSDictionary *)content andHeaders:(NSDictionary *)headers
{
    SPHTTPRequestData *data = [self createRequestDataWithQueryParams:nil content:content headers:headers andType:SPHTTPRequestTypePOST];
    data.url = [self getUrl];
    
    SPHTTPRequest *request = [SPHTTPRequestFactory createHTTPRequest];
    SPHTTPResponse *response = [[[SPHTTPResponse alloc] initWithDelegate:self selector:@selector(postResourceDidFinishWithResponse:)] autorelease];
    response.parser = [self class];
    [request send:data response:response];
}

- (void)doPost:(NSDictionary *)content
{
    [self doGetWithParameters:content andHeaders:nil];
}



@end



