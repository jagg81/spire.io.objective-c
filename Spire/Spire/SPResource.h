//
//  SPResource.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPResourceModel.h"
#import "SPResourceDelegate.h"

@protocol SPResourceCollectionProtocol;
@interface SPResource : NSObject<SPResourceDelegate>{
    SPResourceModel *_model;
    SPApiSchemaModel *_schema;
    SPResourceCapabilityModel *_capabilities;
    id _delegate;
}

@property(nonatomic, assign) id delegate;

/*
 *  Custom initialization method to be overriden by subclasses.
 *  This method is called by constructors
 */
- (void)initialize;
- (void)updateModel:(id)rawModel;
+ (NSString *)resourceName;

/*
 *  Constructors
 */
- (id)initWithResourceModel:(SPResourceModel *)model apiSchemaModel:(SPApiSchemaModel *)schema;
- (id)initWithRawResourceModel:(id)rawModel apiSchemaModel:(SPApiSchemaModel *)schema;
- (SPResourceModel *)getResourceModel:(NSString *)resourceName;
+ (id)createResourceWithRawModel:(id)rawModel apiSchemaModel:(SPApiSchemaModel *)schema;

/*
 *  Properties
 */
- (NSString *)getUrl;
- (void)setUrl:(NSString *)url;
- (NSString *)getMediaType;
//- (void)setMediaType:(NSString *)mediaType;
// TODO: this should handle capability type objects instead of strings
- (SPResourceCapabilityModel *)getCapability;
- (void)setCapability:(NSString *)capability;
- (NSString *)getType;
- (NSString *)getName;

- (void)doGet;
- (void)doGetWithParameters:(NSDictionary *)params andHeaders:(NSDictionary *)headers;
- (void)doUpdate;
- (void)doDelete;
- (void)doPost:(NSDictionary *)content;
- (void)doPostWithContent:(NSDictionary *)content andHeaders:(NSDictionary *)headers;

@end

@protocol SPResourceCollectionProtocol <NSObject>

@required
- (void)resourceCollectionAddModel:(id)rawModel;

@end
