//
//  SPResource.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPResource.h"

@implementation SPResourceModel

- (id)initWithRawModel:(id)rawModel
{
    self = [super init];
    if (self) {
        _rawModel = [rawModel retain];
    }
    
    return self;
}

- (id)getProperty:(NSString *)name
{
    return [_rawModel objectForKey:name];
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_rawModel);
    [super dealloc];
}

+ (SPResourceModel *)createResourceModel:(id)rawModel
{
    return [[[self alloc] initWithRawModel:rawModel] autorelease];
}

@end

@implementation SPResource

- (id)init
{
    self = [super init];
    if (self) {
        id rawModel = [[[NSMutableDictionary alloc] init] autorelease];
        _model = [[SPResourceModel alloc] initWithRawModel:rawModel];
    }
    
    return self;
}

- (id)initWithResourceModel:(SPResourceModel *)model
{
    self = [super init];
    if (self) {
        _model = [model retain];
    }
    
    return self;
}

- (id)initWithRawResourceModel:(id)rawModel
{
    SPResourceModel *model = [SPResourceModel createResourceModel:rawModel];
    self = [self initWithResourceModel:model];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_model);
    [super dealloc];
}

+ (SPResource *)createResourceWithRawModel:(id)rawModel
{
    return [[[SPResource alloc] initWithRawResourceModel:rawModel] autorelease];
}

# pragma mark - SPHTTPResponseParser
+ (id)parseHTTPResponse:(SPHTTPResponse *)response
{
    return [self createResourceWithRawModel:response.responseData];
}

@end



