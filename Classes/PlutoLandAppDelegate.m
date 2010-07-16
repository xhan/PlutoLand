//
//  PlutoLandAppDelegate.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright xu han 2010. All rights reserved.
//

#import "PlutoLandAppDelegate.h"
#import "RootViewController.h"


#import "PLImageCache.h"

@implementation PlutoLandAppDelegate

@synthesize rootVC;
@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	[[PLImageCache sharedCache] removeAll:YES];
	
	rootVC = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
	

	[window addSubview:navVC.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)dealloc {
    [rootVC release], rootVC = nil;
	[navVC release] , navVC = nil;
    [window release];
    [super dealloc];
}




@end

