//
//  SPOperation.h
//  Spire
//
//  Created by Jorge Gonzalez on 5/14/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Spire_SPGlobal_h
#import "SPGlobal.h"
#endif

typedef enum {
    SPOperationReadyState       = 1,
    SPOperationExecutingState   = 2,
    SPOperationFinishedState    = 3,
} _SPOperationState;

typedef unsigned short SPOperationState;

@class SPHTTPResponse;

@interface SPOperation : NSOperation{
    NSDictionary *_data;
    id _delegate;
    SEL _selector;
    
    SPOperationState _state;
}

- (id)initWithOperationData:(NSDictionary *)data delegate:(id)delegate andSelector:(SEL)selector;

@end


@protocol SPOperationManager <NSObject>

@required
- (void)operationDidFinishWithResponse:(SPHTTPResponse *)response;
- (void)registerOperation:(SPOperation *)operation;
- (void)performNextOperation;
- (BOOL)hasNextOperation;

@end