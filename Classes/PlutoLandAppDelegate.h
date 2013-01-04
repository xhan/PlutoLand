//
//  PlutoLandAppDelegate.h
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright xu han 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface PlutoLandAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	RootViewController* rootVC;
	UINavigationController* navVC;
}

@property (nonatomic, retain) RootViewController *rootVC;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


