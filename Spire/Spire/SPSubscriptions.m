//
//  SPSubscriptions.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPSubscriptions.h"

@implementation SPSubscriptions

# pragma mark - Overriden methods from super class [SPResource]
- (void)initialize
{
    [super initialize];
    if (_subscriptionCollection) {
        SP_RELEASE_SAFELY(_subscriptionCollection);
    }
    _subscriptionCollection = [_model parseCollectionWithKey:@"resources" withParser:[SPSubscription class] andApiSchemaModel:_schema];
    [_subscriptionCollection retain];
}

- (void)updateModel:(id)rawModel
{
    [_model setProperty:@"resources" value:rawModel];
    [self initialize];
}

+ (NSString *)resourceName
{
    return [NSString stringWithString:@"subscriptions"];
}

- (void)doGet
{
    NSString *capability = [SPHTTPRequestData prepareAuthorizationHeaderForCapability:[_capabilities getCapabilityForType:@"all"]];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:capability, @"Authorization", nil];
    [super doGetWithParameters:nil andHeaders:headers];
}

# pragma mark - Additional Public methods

- (void)createSubscription:(NSString *)name forChannels:(NSArray *)channels withExpiration:(NSNumber *)expiration
{
    id exp = expiration ? expiration : [NSNull null];
    
    NSDictionary *content = [NSDictionary dictionaryWithObjectsAndKeys: name, @"name", 
                                                                        channels, @"channels",
                                                                        exp, @"expiration", nil];
    NSString *mediaType = [_schema getMediaType:[SPSubscription resourceName]];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys: mediaType, @"Accept", 
                                                                        mediaType, @"Content-Type", nil];
    [super doPostWithContent:content andHeaders:headers];
}

- (void)createSubscription:(NSString *)name forChannel:(NSString *)channel
{
    [self createSubscription:name forChannels:[NSArray arrayWithObjects:channel, nil] withExpiration:nil];
}

- (void)addSubscription:(SPSubscription *)subscription
{
    [_subscriptionCollection setObject:subscription forKey:[subscription getName]];
}

- (SPSubscription *)getSubscription:(NSString *)name;
{
    return [_subscriptionCollection objectForKey:name];
}

# pragma mark - SPResourceDelegate - HTTP callback handlers
- (void)getResourceDidFinishWithResponse:(id)response
{
    [super getResourceDidFinishWithResponse:response];
    
    if (_delegate && [_delegate respondsToSelector:@selector(getSubscriptionDidFinishWithResponse:)] ) {
        [_delegate getSubscriptionDidFinishWithResponse:response];
    }
}

- (void)postResourceDidFinishWithResponse:(id)response
{
    [super postResourceDidFinishWithResponse:response];
    
    if (_delegate && [_delegate respondsToSelector:@selector(createSubscriptionDidFinishWithRespose:)] ) {
        [_delegate createSubscriptionDidFinishWithRespose:response];
    }
}

# pragma mark - SPResourceCollectionProtocol
- (void)resourceCollectionAddModel:(id)rawModel
{
    SPSubscription *subscription = [SPSubscription createResourceWithRawModel:rawModel apiSchemaModel:_schema];
    [self addSubscription:subscription];
}

@end
