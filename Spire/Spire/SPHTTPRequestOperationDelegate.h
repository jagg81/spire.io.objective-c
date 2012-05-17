//
//  SPHTTPRequestOperationDelegate.h
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPHTTPRequestOperationDelegate <NSObject>
@required
- (void)requestDidFinish:(NSURLRequest *)request response:(NSHTTPURLResponse *)response andData:(id)data;
- (void)requestDidFail:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error andData:(id)data;

@end
