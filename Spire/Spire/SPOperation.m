//
//  SPOperation.m
//  Spire
//
//  Created by Jorge Gonzalez on 5/14/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPOperation.h"

@implementation SPOperation


- (id)initWithOperationData:(NSDictionary *)data delegate:(id)delegate andSelector:(SEL)selector
{
    self = [super init];
    if (self) {
        _data = [data retain];
        _delegate = delegate;
        _selector = selector;
        _state = SPOperationReadyState;
    }
    
    return self;
}

- (void)dealloc{
    SP_RELEASE_SAFELY(_data);
    [super dealloc];
}

#pragma mark - NSOperation

- (BOOL)isReady {
    return _state == SPOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return _state == SPOperationExecutingState;
}

- (BOOL)isFinished {
    return _state == SPOperationFinishedState;
}

- (BOOL)isConcurrent {
    return NO;
}

- (void)main
{	
    _state = SPOperationExecutingState;
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if ([self isCancelled]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:_selector] ) {
        [_delegate performSelector:_selector withObject:_data];
    }
	
	[pool release];
    
    _state = SPOperationFinishedState;
}


@end
