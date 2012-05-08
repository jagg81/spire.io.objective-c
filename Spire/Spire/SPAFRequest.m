//
//  SPAFRequest.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/30/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPAFRequest.h"

@implementation SPAFRequest


- (id)init
{
    self = [super init];
    if (self) {
//        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

-(void) dealloc{
    [super dealloc];
}


-(void) send:(SPHTTPRequestData *)data response:(SPHTTPResponse *)response
{
    
    NSURL *url = [NSURL URLWithString:@"https://gowalla.com/users/mattt.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Name: %@ %@", [JSON valueForKeyPath:@"first_name"], [JSON valueForKeyPath:@"last_name"]);
    } failure:nil];
    
    
//    NSURLRequest *request = [data generateHTTPRequest];
//    SPJSONRequestOperation *operation = [SPJSONRequestOperation SPJSONRequestOperationWithRequest:request delegate:response];
//    [_queue setMaxConcurrentOperationCount:1];
    [operation start];
}


+(SPHTTPRequest *) createRequest{
    return [[[SPAFRequest alloc] init] autorelease];
}


@end

