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

# pragma mark - SPHTTPResponseParser
//+ (id)parseHTTPResponse:(SPHTTPResponse *)response withInfo:(id)info
//{
//    return [self createResourceWithRawModel:response.responseData apiSchemaModel:info];
//}

@end
