//
//  SPAccount.m
//  Spire
//
//  Created by Jorge Gonzalez on 4/27/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPAccount.h"

@implementation SPAccount


- (NSString *)getSecret
{
    NSString *secret = [_model getProperty:@"secret"];
    if (secret) {
        return [NSString stringWithString:secret];
    }
    return secret;
}

@end
