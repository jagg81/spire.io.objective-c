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

- (id)initWithResourceModel:(SPResourceModel *)model
{
    self = [super initWithResourceModel:model];
    if (self) {
        id resourceModel = [self getResourceModel:@"account"];
        _account = [[SPAccount alloc] initWithResourceModel:resourceModel];
        resourceModel = [self getResourceModel:@"channels"];
        _channels = [[SPChannels alloc] initWithResourceModel:resourceModel];
        resourceModel = [self getResourceModel:@"subscriptions"];
        _subscriptions = [[SPSubscriptions alloc] initWithResourceModel:resourceModel];
    }
    
    return self;
}

- (SPResourceModel *)getResourceModel:(NSString *)resourceName
{
    SPResourceModel *resources = [_model getResourceModel:@"resources"];
    return [resources getResourceModel:resourceName];
}


# pragma mark - SPHTTPResponseParser
+ (id)parseHTTPResponse:(SPHTTPResponse *)response
{
    return [self createResourceWithRawModel:response.responseData];
}

@end
