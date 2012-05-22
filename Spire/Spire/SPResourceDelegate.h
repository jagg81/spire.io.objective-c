//
//  SPResourceDelegate.h
//  Spire
//
//  Created by Jorge Gonzalez on 5/22/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPResourceDelegate <NSObject>

@required
- (void)getResourceDidFinishWithResponse:(id)response;
- (void)updateResourceDidFinishWithResponse:(id)response;
- (void)deleteResourceDidFinishWithResponse:(id)response;
- (void)postResourceDidFinishWithResponse:(id)response;

@end
