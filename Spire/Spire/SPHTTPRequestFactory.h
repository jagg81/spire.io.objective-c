//
//  SPHTTPRequestFactory.h
//  Spire
//
//  Created by Jorge Gonzalez on 5/3/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAFRequest.h"
#import "SPAFResponse.h"

@interface SPHTTPRequestFactory : NSObject{
    
}

+(SPHTTPRequest *) createHTTPRequest;

@end
