//
//  SPResourceModel.m
//  Spire
//
//  Created by Jorge Gonzalez on 5/18/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPResourceModel.h"

@implementation SPResourceModel
@synthesize rawModel = _rawModel;

- (id)initWithRawModel:(id)rawModel
{
    self = [super init];
    if (self) {
        _rawModel = [[NSMutableDictionary dictionaryWithDictionary:rawModel] retain];
    }
    
    return self;
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_rawModel);
    [super dealloc];
}

- (id)getProperty:(NSString *)name
{
    return [_rawModel objectForKey:name];
}

- (void)setProperty:(NSString *)name value:(id)value
{
    [_rawModel setObject:value forKey:name];
}

+ (SPResourceModel *)createResourceModel:(id)rawModel
{
    return [[[self alloc] initWithRawModel:rawModel] autorelease];
}

- (SPResourceModel *)getResourceModel:(NSString *)resourceName
{
    id rawData = [self getProperty:resourceName];
    return [[self class] createResourceModel:rawData];
}

- (id)parseCollectionWithKey:(NSString *)key withParser:(id)parser andApiSchemaModel:(SPApiSchemaModel *)schema
{
    NSMutableDictionary *collection = [NSMutableDictionary dictionary];
    id rawCollection = [self getProperty:key];
    if (rawCollection) {
        for (id resourceKey in [rawCollection allKeys]) {
            id rawModel = [rawCollection objectForKey:resourceKey];
            id resource = [parser performSelector:@selector(createResourceWithRawModel:apiSchemaModel:) withObject:rawModel withObject:schema];
            [collection setObject:resource forKey:resourceKey];
        }
    }
    return collection;
}

@end

@implementation SPApiSchemaModel

- (NSString *)getMediaType:(NSString *)resource
{
    return [[[self getProperty:SP_API_VERSION] objectForKey:resource] objectForKey:@"mediaType"];
}

@end

@implementation SPApiDescriptionModel

- (id)initWithRawModel:(id)rawModel
{
    self = [super initWithRawModel:rawModel];
    if (self) {
        id rawData = [self getProperty:@"schema"];
        _schema = [[SPApiSchemaModel alloc] initWithRawModel:rawData];
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

- (SPResourceModel *)getSchema
{
    return _schema;
}

- (SPResourceModel *)getResources
{
    return _resources;
}

# pragma mark - SPHTTPResponseParser
+ (id)parseHTTPResponse:(SPHTTPResponse *)response withInfo:(id)info
{
    return [self createResourceModel:response.responseData];
}


@end



@implementation SPResourceCapabilityModel

- (NSString *)getCapabilityForType:(NSString *)type
{
    return [self getProperty:type];
}

- (NSString *)getCapabilityForRequest:(SPHTTPRequestType)type
{
    NSString *capability = nil;
    
    switch (type) {
        case SPHTTPRequestTypeGET:
            capability = [self getCapabilityForType:@"get"];
            break;
        case SPHTTPRequestTypePUT:
            capability = [self getCapabilityForType:@"update"];
            break;
        case SPHTTPRequestTypePOST:
            capability = [self getCapabilityForType:@"create"];
            break;
        case SPHTTPRequestTypeDELETE:
            capability = [self getCapabilityForType:@"delete"];
            break;
        default:
            break;
    }
    
    return capability;
}

@end
