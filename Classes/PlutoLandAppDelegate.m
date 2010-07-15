//
//  PlutoLandAppDelegate.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright xu han 2010. All rights reserved.
//

#import "PlutoLandAppDelegate.h"
#import "PLImageRequest.h"

@implementation PlutoLandAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
	[self performSelector:@selector(testHttpRequest)];
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


- (void)testHttpRequest
{
	PLImageRequest* client = [[PLImageRequest alloc] initWithURL:@"http://douban.fm/j/mine/playlist"];
	[client start];
	
}

@end
