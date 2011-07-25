//
//  PLHttpConfig.h
//  PlutoLand
//
//  Created by xu xhan on 7/25/11.
//  Copyright 2011 ixHan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>

@interface PLHttpConfig : NSObject
{
    //TODO: make this workable
    BOOL isGzipSupport;
    BOOL isForceHandleStatusCode;
    NSStringEncoding encoding;
    NSTimeInterval timeout;
    
    int _connections;
    
}

+ (PLHttpConfig*)s;


- (void)requestStarted;
- (void)requestStoped;

@end

//extern PLHttpConfig* PLHttpConfigInstance();