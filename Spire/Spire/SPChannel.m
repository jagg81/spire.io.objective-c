//
//  Channel.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPChannel.h"

@implementation SPChannel

# pragma mark - Overriden methods from super class [SPResource]

+ (NSString *)resourceName
{
    return [NSString stringWithString:@"channel"];
}

# pragma mark - Public API
- (void)publish:(NSString *)content
{
    NSDictionary *messageContent = [NSDictionary dictionaryWithObjectsAndKeys: content, @"content", nil];
    NSString *capability = [SPHTTPRequestData prepareAuthorizationHeaderForCapability:[_capabilities getCapabilityForType:@"publish"]];
    NSString *mediaType = [_schema getMediaType:[SPMessage resourceName]];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys: capability, @"Authorization", 
                                                                        mediaType, @"Accept", 
                                                                        mediaType, @"Content-Type", nil];
    [super doPostWithContent:messageContent andHeaders:headers];
}


# pragma mark - SPResourceDelegate - HTTP callback handlers
//- (void)getResourceDidFinishWithResponse:(id)response
//{
//    [super getResourceDidFinishWithResponse:response];
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(getChannelsDidFinishWithResponse:)] ) {
//        [_delegate getChannelsDidFinishWithResponse:response];
//    }
//}

- (void)postResourceDidFinishWithResponse:(id)response
{
    [super postResourceDidFinishWithResponse:response];
    
    if (_delegate && [_delegate respondsToSelector:@selector(publishDidFinishWithResponse:)] ) {
        [_delegate publishDidFinishWithResponse:response];
    }
}

@end
