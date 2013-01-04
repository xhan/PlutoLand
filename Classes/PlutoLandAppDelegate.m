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
#import "PLOG.h"

@implementation PlutoLandAppDelegate

@synthesize rootVC;
@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	[[PLImageCache sharedCache] removeAll:YES];
	
	rootVC = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
	

	[window addSubview:navVC.view];
    [window makeKeyAndVisible];

//	printf("%d,%d",PLOG_FORMAT_DATE,PLOG_FORMAT_FILE);
	
//	[PLOG_ setLog:0 State:NO];
//	[PLOG env:0 log:@"hello,%d",5];
//	[PLOG env:1 log:@"env 1 hello,%d",5];
//	[PLOG env:4 log:@"aaa"];
	PLOG(@"hello %d",56);
	
	return YES;
}


- (void)dealloc {
    [rootVC release], rootVC = nil;
	[navVC release] , navVC = nil;
    [window release];
    [super dealloc];
}




@end

