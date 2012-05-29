//
//  Session.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPSession.h"
#import "SPOperationCreateChannels.h"

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


# pragma mark - SPOperationManager

- (void)registerOperation:(SPOperation *)operation
{
    if (operation) {
        if (_operation) { SP_RELEASE_SAFELY(_operation); }
        _operation = [operation retain];
    }
}

- (void)performNextOperation
{
    if(_operation){
        [_operation start];
    }
    // release operation??
//    SP_RELEASE_SAFELY(_operation);
}

- (BOOL)hasNextOperation
{
    NSLog(@"%i", [_operation isReady]);
//    return _operation && [_operation isReady] ? YES : NO;
    return _operation ? YES : NO;
}


# pragma mark - SPHTTPResponseParser
+ (id)parseHTTPResponse:(SPHTTPResponse *)response withInfo:(id)info
{
    return [self createResourceWithRawModel:response.responseData apiSchemaModel:info];
}

# pragma mark - wrapper methods

- (void)didFinishCreatingChannelsForSubscription:(NSDictionary *)data
{
    NSString *name = [data objectForKey:@"name"];
    NSNumber *expiration = [data objectForKey:@"expiration"];
    NSArray *channelList = [data objectForKey:@"channelList"];
//    SPChannels *channels = [data objectForKey:@"channels"];

    _subscriptions.delegate = self;
    // TODO: create channels if they don't already exist
    // ...also channels should be and array of channels url!
    NSMutableArray *listURLs = [[[NSMutableArray alloc] initWithCapacity:[channelList count]] autorelease];
    for (NSString *channelName in channelList) {
        SPChannel *channel = [_channels getChannel:channelName];
        if (channel) {
            NSString *url = [channel getUrl];
            if (url) {
                [listURLs addObject:url];
            }
        }
    }
    [_subscriptions createSubscription:name forChannels:listURLs withExpiration:expiration];
}

# pragma mark - PUBLIC API
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

- (void)retrieveSubscriptions
{
    _subscriptions.delegate = self;
    [_subscriptions doGet];
}

- (void)createSubscriptionWithName:(NSString *)name forChannels:(NSArray *)channels withExpiration:(NSNumber *)expiration
{
    id exp = expiration ? expiration : [NSNull null];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name",
                                                                    channels, @"channelList",
                                                                    exp, @"expiration",
                                                                    _channels, @"channels", nil];
    SPOperationCreateChannels *operationChannels = [[SPOperationCreateChannels alloc] initWithOperationData:data delegate:self andSelector:@selector(didFinishCreatingChannelsForSubscription:)];
    [operationChannels start];
    
//    _subscriptions.delegate = self;
//    // TODO: create channels if they don't already exist
//    // ...also channels should be and array of channels url!
//    [_subscriptions createSubscription:name forChannels:channels withExpiration:expiration];
}

- (void)createSubscriptionWithName:(NSString *)name forChannel:(NSString *)channel
{
    [self createSubscriptionWithName:name forChannels:[NSArray arrayWithObjects:channel, nil] withExpiration:-1];
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

# pragma mark - SPHTTPSubscriptionDelegate
- (void)getSubscriptionDidFinishWithResponse:(SPHTTPResponse *)response
{
    if (_delegate && [_delegate respondsToSelector:@selector(sessionRetrieveSubscriptionDidFinishWithResponse:)] ) {
        [_delegate sessionRetrieveSubscriptionDidFinishWithResponse:response];
    }
}

- (void)createSubscriptionDidFinishWithRespose:(SPHTTPResponse *)response
{
    if (_delegate && [_delegate respondsToSelector:@selector(sessionCreateSubscriptionDidFinishWithResponse:)] ) {
        [_delegate sessionCreateSubscriptionDidFinishWithResponse:response];
    }    
}


@end
