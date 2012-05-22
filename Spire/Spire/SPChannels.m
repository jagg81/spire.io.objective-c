//
//  SPChannels.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPChannels.h"

@implementation SPChannels


- (void)initialize
{
    [super initialize];
    _channelCollection = [_model parseCollectionWithKey:@"resources" withParser:[SPChannel class] andApiSchemaModel:_schema];
}

- (void)updateModel:(id)rawModel
{
    [_model setProperty:@"resources" value:rawModel];
    [self initialize];
}

- (NSString *)getResourceName
{
    return [NSString stringWithString:@"channels"];
}

- (void)doGet
{
    NSString *capability = [SPHTTPRequestData prepareAuthorizationHeaderForCapability:[_capabilities getCapabilityForType:@"all"]];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:capability, @"Authorization", nil];
    [super doGetWithParameters:nil andHeaders:headers];
}

# pragma mark - SPResourceDelegate - HTTP callback handlers
- (void)getResourceDidFinishWithResponse:(id)response
{
    [super getResourceDidFinishWithResponse:response];
    
    if (_delegate && [_delegate respondsToSelector:@selector(getChannelsDidFinishWithResponse:)] ) {
        [_delegate getChannelsDidFinishWithResponse:response];
    }
}


@end
