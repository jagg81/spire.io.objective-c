//
//  Session.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPSession.h"

@implementation SPSession


# pragma mark - SPHTTPResponseParser
+ (id)parseHTTPResponse:(SPHTTPResponse *)response
{
    return [self createResourceWithRawModel:response.responseData];
}

@end
