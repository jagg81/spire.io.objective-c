//
//  SPHTTPRequestData.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPGlobal.h"

typedef enum{
    SPHTTPRequestTypeGET = 0,
    SPHTTPRequestTypePOST,
    SPHTTPRequestTypePUT,
    SPHTTPRequestTypeDELETE,
} SPHTTPRequestType;


@interface SPHTTPRequestData : NSObject{
    NSString *_url;
    NSDictionary *_queryParams;
    NSData *_body;
    SPHTTPRequestType _type;
    NSDictionary *_headers;
}

@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSDictionary *queryParams;
@property(nonatomic, retain) NSData *body;
@property(nonatomic, assign) SPHTTPRequestType type;
@property(nonatomic, retain) NSDictionary *headers;


+(SPHTTPRequestData *) createRequestData;

-(NSURLRequest *) generateHTTPRequest;



@end
