//
//  PlutoLandAppDelegate.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright xu han 2010. All rights reserved.
//

#import "PlutoLandAppDelegate.h"

@implementation PlutoLandAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
