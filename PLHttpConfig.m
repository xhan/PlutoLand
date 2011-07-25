//
//  PLHttpConfig.m
//  PlutoLand
//
//  Created by xu xhan on 7/25/11.
//  Copyright 2011 ixHan.com. All rights reserved.
//

#import "PLHttpConfig.h"

@implementation PLHttpConfig

static PLHttpConfig* _gSharedInstance;
static pthread_mutex_t  _connectionMutex = PTHREAD_MUTEX_INITIALIZER;
- (id)init
{
    self = [super init];
    if (self) {
        _connections = 0;
    //_connectionMutex = PTHREAD_MUTEX_INITIALIZER;
//        pthread_mutex_t
    }
    
    return self;
}

+ (PLHttpConfig*)s
{
    if (!_gSharedInstance) {
        _gSharedInstance = [[self alloc] init];
    }
    return _gSharedInstance;
}

- (void)requestStarted
{
    pthread_mutex_lock(&_connectionMutex);
    if (_connections ==0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    _connections += 1;
    pthread_mutex_unlock(&_connectionMutex);
}
- (void)requestStoped
{
    pthread_mutex_lock(&_connectionMutex);
    _connections -= 1;
    _connections = MAX(0, _connections);
    if (_connections == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    pthread_mutex_unlock(&_connectionMutex);    
}

@end

/*
PLHttpConfig* PLHttpConfigInstance()
{
    return [PLHttpConfig s];
}
*/