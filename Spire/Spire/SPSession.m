//
//  Session.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPSession.h"

@implementation SPSession
@synthesize account = _account,
            channels = _channels,
            subscriptions = _subscriptions;

- (id)initWithResourceModel:(SPResourceModel *)model apiSchemaModel:(SPApiSchemaModel *)schema
{
    self = [super initWithResourceModel:model apiSchemaModel:schema];
    if (self) {
        id resourceModel = [self getResourceModel:@"account"];
        _account = [[SPAccount alloc] initWithResourceModel:resourceModel apiSchemaModel:schema];
        _account.delegate = self;
        
        resourceModel = [self getResourceModel:@"channels"];
        _channels = [[SPChannels alloc] initWithResourceModel:resourceModel apiSchemaModel:schema];
        _channels.delegate = self;
        
        resourceModel = [self getResourceModel:@"subscriptions"];
        _subscriptions = [[SPSubscriptions alloc] initWithResourceModel:resourceModel apiSchemaModel:schema];
        _subscriptions.delegate = self;
    }
    
    return self;
}

- (SPResourceModel *)getResourceModel:(NSString *)resourceName
{
    SPResourceModel *resources = [_model getResourceModel:@"resources"];
    return [resources getResourceModel:resourceName];
}


# pragma mark - SPHTTPResponseParser
+ (id)parseHTTPResponse:(SPHTTPResponse *)response withInfo:(id)info
{
    return [self createResourceWithRawModel:response.responseData apiSchemaModel:info];
}

- (void)retrieveChannels
{
    _channels.delegate = self;
    [_channels doGet];
}

- (void)createChannelWithName:(NSString *)name
{
    _channels.delegate = self;
    [_channels createChannel:name];
}

# pragma mark - SPHTTPChannelsDelegate
- (void)getChannelsDidFinishWithResponse:(SPHTTPResponse *)response
{
    if (_delegate && [_delegate respondsToSelector:@selector(sessionRetrieveChannelsDidFinishWithResponse:)] ) {
        [_delegate sessionRetrieveChannelsDidFinishWithResponse:response];
    }
}

- (void)createChannelDidFinishWithResponse:(SPHTTPResponse *)response
{
    if (_delegate && [_delegate respondsToSelector:@selector(sessionCreateChannelDidFinishWithResponse:)] ) {
        [_delegate sessionCreateChannelDidFinishWithResponse:response];
    }
}


@end
