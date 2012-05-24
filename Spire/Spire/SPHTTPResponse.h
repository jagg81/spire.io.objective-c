//
//  SPHTTPResponse.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHTTPRequestOperationDelegate.h"

#ifndef Spire_SPGlobal_h
#import "SPGlobal.h"
#endif

//@protocol SPHTTPResponseOperationDelegate;
@protocol SPHTTPResponseParser;

@interface SPHTTPResponse : NSObject<SPHTTPRequestOperationDelegate>{
    NSURLRequest *_request;
    NSHTTPURLResponse *_response;
    NSError *_error;
    id _responseData;
    
    id _delegate;
    SEL _selector;
//    id<SPHTTPResponseOperationDelegate> _responseDelegate;
    Class _parser;
}

@property(nonatomic, readonly) NSURLRequest *request;
@property(nonatomic, readonly) NSHTTPURLResponse *response;
@property(nonatomic, readonly) NSError *error;
@property(nonatomic, readonly) id responseData;
//@property(nonatomic, assign) id responseDelegate;
@property(nonatomic, assign) Class parser;

- (id)initWithDelegate:(id)delegate;
- (id)initWithDelegate:(id)delegate selector:(SEL)selector;

/* This method handles methods from SPHTTPRequestOperationDelegate
 * this could be overriden by subclasses
 */
- (void)handleResponse:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error andResponseData:(id)data;
- (id)parseResponseWithParser:(Class)parser andInfo:(id)info;
- (id)parseResponseWithInfo:(id)info;
- (BOOL)isSuccessStatusCode;
- (NSInteger)statusCode;

@end

//@protocol SPHTTPResponseOperationDelegate <NSObject>
//
//@optional
//- (void)responseOperationDidFinishWithResponse:(SPHTTPResponse *)response;
//
//@end

@protocol SPHTTPResponseParser <NSObject>

@required
+ (id)parseHTTPResponse:(SPHTTPResponse *)response withInfo:(id)info;

@end