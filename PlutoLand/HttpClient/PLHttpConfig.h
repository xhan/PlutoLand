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
    NSString* _userAgent;
    NSString *_networkStr;
}

+ (PLHttpConfig*)s;
// provide a better user agent other than system style "Secret/1100240 CFNetwork/485.13.9 Darwin/11.0.0"
- (NSString*)userAgentFormated;

- (void)requestStarted;
- (void)requestStoped;

@end

//extern PLHttpConfig* PLHttpConfigInstance();
