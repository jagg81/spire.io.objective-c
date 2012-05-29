//
//  SPOperation.m
//  Spire
//
//  Created by Jorge Gonzalez on 5/14/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPOperation.h"

static inline NSString * SPKeyPathFromOperationState(SPOperationState state) {
    switch (state) {
        case SPOperationReadyState:
            return @"isReady";
        case SPOperationExecutingState:
            return @"isExecuting";
        case SPOperationFinishedState:
            return @"isFinished";
        default:
            return @"state";
    }
}

@implementation SPOperation
@synthesize delegate = _delegate;


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

- (void)setState:(SPOperationState)state {
    NSString *oldStateKey = SPKeyPathFromOperationState(_state);
    NSString *newStateKey = SPKeyPathFromOperationState(state);
    
    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];        
}

- (void)finish {
    [self setState:SPOperationFinishedState];
}

- (void)cancel {
    if (![self isFinished] && ![self isCancelled]) {
        [self willChangeValueForKey:@"isCancelled"];
        [super cancel];
        [self didChangeValueForKey:@"isCancelled"];        
    }
}


- (void)main
{	
    _state = SPOperationExecutingState;
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:_selector] ) {
        [_delegate performSelector:_selector withObject:_data];
    }
	
	[pool release];
    
//    _state = SPOperationFinishedState;
}


@end
