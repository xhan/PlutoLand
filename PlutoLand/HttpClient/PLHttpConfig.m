//
//  PLHttpConfig.m
//  PlutoLand
//
//  Created by xu xhan on 7/25/11.
//  Copyright 2011 ixHan.com. All rights reserved.
//

#import "PLHttpConfig.h"
#import "ReachabilityO.h"
#import "QBAppDelegate.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
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
#if TARGET_OS_IPHONE
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#endif        
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
#if TARGET_OS_IPHONE        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#endif        
    }
    pthread_mutex_unlock(&_connectionMutex);    
}

- (NSString*)userAgentFormated
{
    // modified from ASIHTTPRequest class
    //    "Secret/1100240 CFNetwork/485.13.9 Darwin/11.0.0"
    //Secret/1.05 rv:1111 (Macintosh; Mac OS X 10.5.7; en_GB)"
    
    // more on User Agent format : http://en.wikipedia.org/wiki/User_agent
    if (!_userAgent) {
        NSBundle* bundle =  [NSBundle mainBundle];
        //not using CFBundleName because it might be non ascii characters
        NSString *app = [bundle objectForInfoDictionaryKey:@"CFBundleExecutable"];
        if (!app) return nil;
        
        //app version
        NSString *appVersion = nil;
        NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
        if (marketingVersionNumber && developmentVersionNumber) {
            if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
                appVersion = marketingVersionNumber;
            } else {
                appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
            }
        } else {
            appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
        }
        
        NSString *deviceName;
        NSString *OSName;
        NSString *OSVersion;
        
        NSString *locale = [[NSLocale currentLocale] localeIdentifier];
        
#if TARGET_OS_IPHONE
        UIDevice *device = [UIDevice currentDevice];
        deviceName = [device model];
        OSName = [device systemName];
        OSVersion = [device systemVersion];
#else
        deviceName = @"Macintosh";
        OSName = @"Mac OS X";
        // From http://www.cocoadev.com/index.pl?DeterminingOSVersion
        // We won't bother to check for systems prior to 10.4, since ASIHTTPRequest only works on 10.5+
        OSErr err;
        SInt32 versionMajor, versionMinor, versionBugFix;
        err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
        if (err != noErr) return nil;
        err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
        if (err != noErr) return nil;
        err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
        if (err != noErr) return nil;
        OSVersion = [NSString stringWithFormat:@"%u.%u.%u", versionMajor, versionMinor, versionBugFix];
        
#endif
        _userAgent = [[NSString stringWithFormat:@"%@/%@ (%@; %@ %@; %@) PLHttpClient/1", app, appVersion, deviceName, OSName, OSVersion, locale] copy];

    }
    if (!_networkStr)
    {
        _networkStr = @"_WIFI";
        if ([[QBAppDelegate s].reacher isReachableViaWWAN])
        {
            _networkStr = @"_WAN";
        }
    }
    NSString *relAgent = [_userAgent stringByAppendingString:_networkStr];
    return relAgent;
}

- (void)reachabilityChanged:(NSNotification*)notification
{
    if([[QBAppDelegate s].reacher currentReachabilityStatus] == ReachableViaWiFi)
    {
        _networkStr = @"_WIFI";
    }
    else if([[QBAppDelegate s].reacher currentReachabilityStatus] == ReachableViaWWAN)
    {
        _networkStr = @"_WAN";
    }
}

@end

/*
PLHttpConfig* PLHttpConfigInstance()
{
    return [PLHttpConfig s];
}
*/
