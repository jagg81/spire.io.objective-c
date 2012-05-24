//
//  SPChannels.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPChannels.h"

@implementation SPChannels

# pragma mark - Overriden methods from super class [SPResource]
- (void)initialize
{
    [super initialize];
    if (_channelCollection) {
        SP_RELEASE_SAFELY(_channelCollection);
    }
    _channelCollection = [_model parseCollectionWithKey:@"resources" withParser:[SPChannel class] andApiSchemaModel:_schema];
    [_channelCollection retain];
}

- (void)updateModel:(id)rawModel
{
    [_model setProperty:@"resources" value:rawModel];
    [self initialize];
}

+ (NSString *)resourceName
{
    return [NSString stringWithString:@"channels"];
}

- (void)doGet
{
    NSString *capability = [SPHTTPRequestData prepareAuthorizationHeaderForCapability:[_capabilities getCapabilityForType:@"all"]];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:capability, @"Authorization", nil];
    [super doGetWithParameters:nil andHeaders:headers];
}

# pragma mark - Additional Public methods

- (SPChannel *)getChannel:(NSString *)name
{
    return [_channelCollection objectForKey:name];
}

- (void)createChannel:(NSString *)name
{
    NSDictionary *content = [NSDictionary dictionaryWithObjectsAndKeys: name, @"name", nil];
    NSString *mediaType = [_schema getMediaType:[SPChannel resourceName]];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys: mediaType, @"Accept", 
                                                                        mediaType, @"Content-Type", nil];
    [super doPostWithContent:content andHeaders:headers];
}

- (void)addChannel:(SPChannel *)channel
{
    [_channelCollection setObject:channel forKey:[channel getName]];
}

# pragma mark - SPResourceDelegate - HTTP callback handlers
- (void)getResourceDidFinishWithResponse:(id)response
{
    [super getResourceDidFinishWithResponse:response];
    
    if (_delegate && [_delegate respondsToSelector:@selector(getChannelsDidFinishWithResponse:)] ) {
        [_delegate getChannelsDidFinishWithResponse:response];
    }
}

- (void)postResourceDidFinishWithResponse:(id)response
{
    [super postResourceDidFinishWithResponse:response];
    
    if (_delegate && [_delegate respondsToSelector:@selector(createChannelDidFinishWithResponse:)] ) {
        [_delegate createChannelDidFinishWithResponse:response];
    }
}

# pragma mark - SPResourceCollectionProtocol
- (void)resourceCollectionAddModel:(id)rawModel
{
    SPChannel *channel = [SPChannel createResourceWithRawModel:rawModel apiSchemaModel:_schema];
    [self addChannel:channel];
}


@end
