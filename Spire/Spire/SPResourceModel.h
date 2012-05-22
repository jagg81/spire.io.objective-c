//
//  SPResourceModel.h
//  Spire
//
//  Created by Jorge Gonzalez on 5/18/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHTTPRequestFactory.h"

#ifndef Spire_SPGlobal_h
#import "SPGlobal.h"
#endif

extern NSString* SP_API_VERSION;
@class SPApiSchemaModel;

@interface SPResourceModel : NSObject{
    id _rawModel;
}

@property (nonatomic, readonly) id rawModel;

- (id)initWithRawModel:(id)rawModel;
- (id)getProperty:(NSString *)name;
- (void)setProperty:(NSString *)name value:(id)value;
- (SPResourceModel *)getResourceModel:(NSString *)resourceName;
+ (SPResourceModel *)createResourceModel:(id)rawModel;
- (id)parseCollectionWithKey:(NSString *)key withParser:(Class)parser andApiSchemaModel:(SPApiSchemaModel *)schema;
@end

@interface SPApiSchemaModel : SPResourceModel{
}

- (NSString *)getMediaType:(NSString *)resource;
@end


@interface SPApiDescriptionModel : SPResourceModel<SPHTTPResponseParser>{
    SPApiSchemaModel *_schema;
    SPResourceModel *_resources;
}

- (SPApiSchemaModel *)getSchema;
- (SPResourceModel *)getResources;
@end

@interface SPResourceCapabilityModel : SPResourceModel{
}

- (NSString *)getCapabilityForType:(NSString *)type;
- (NSString *)getCapabilityForRequest:(SPHTTPRequestType)type;
@end

