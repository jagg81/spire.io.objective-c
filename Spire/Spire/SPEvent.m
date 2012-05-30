//
//  SPEvent.m
//  Spire
//
//  Created by Jorge Gonzalez on 5/29/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPEvent.h"

@implementation SPEvent
@synthesize type = _type;

- (id)initWithResourceModel:(SPResourceModel *)model apiSchemaModel:(SPApiSchemaModel *)schema type:(SPResourceEventType)eventType
{
    self = [super initWithResourceModel:model apiSchemaModel:schema];
    if (self) {
        self.type = eventType;
    }
    
    return self;
}

- (id)getContent
{
    return [_model getProperty:@"content"];
}

- (NSString *)getTimestamp
{
    return [_model getProperty:@"timestamp"];
}

- (NSString *)getChannelName
{
    return [_model getProperty:@"channel"];    
}


@end


@implementation SPMessage

- (id)initWithResourceModel:(SPResourceModel *)model apiSchemaModel:(SPApiSchemaModel *)schema
{
    self = [super initWithResourceModel:model apiSchemaModel:schema type:SPResourceEventMessage];
    if (self) {
        
    }
    
    return self;
}

+ (NSString *)resourceName
{
    return [NSString stringWithString:@"message"];
}

@end

@implementation SPJoin

- (id)initWithResourceModel:(SPResourceModel *)model apiSchemaModel:(SPApiSchemaModel *)schema
{
    self = [super initWithResourceModel:model apiSchemaModel:schema type:SPResourceEventJoin];
    if (self) {
        
    }
    
    return self;
}

+ (NSString *)resourceName
{
    return [NSString stringWithString:@"join"];
}

@end

@implementation SPPart

- (id)initWithResourceModel:(SPResourceModel *)model apiSchemaModel:(SPApiSchemaModel *)schema
{
    self = [super initWithResourceModel:model apiSchemaModel:schema type:SPResourceEventPart];
    if (self) {
        
    }
    
    return self;
}

+ (NSString *)resourceName
{
    return [NSString stringWithString:@"part"];
}

@end
