//
//  SPResource.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHTTPRequestFactory.h"

#ifndef Spire_SPGlobal_h
#import "SPGlobal.h"
#endif

@interface SPResourceModel : NSObject<SPHTTPResponseParser>{
    id _rawModel;
}

- (id)initWithRawModel:(id)rawModel;

- (id)getProperty:(NSString *)name;
- (id)setProperty:(NSString *)name value:(id)value;
- (SPResourceModel *)getResourceModel:(NSString *)resourceName;
+ (SPResourceModel *)createResourceModel:(id)rawModel;

@end


@interface SPResource : NSObject{
    SPResourceModel *_model;
}

- (id)initWithResourceModel:(SPResourceModel *)model;
- (id)initWithRawResourceModel:(id)rawModel;

- (SPResourceModel *)getResourceModel:(NSString *)resourceName;

+ (SPResource *)createResourceWithRawModel:(id)rawModel;

@end
