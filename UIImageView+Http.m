//
//  UIImageView+Http.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "UIImageView+Http.h"
#import "PLHttpQueue.h"
#import "PLImageLoader.h"
#import "PLImageCache.h"



@implementation UIImageView(Http)

- (void) fetchImageFromURL:(NSString*)urlstr userInfo:(NSDictionary*)info
{
	UIImage* aimage = nil;
	if (aimage = [[PLImageCache sharedCache] getImageByURL:urlstr]) {
		self.image = aimage;
		NSLog(@"load from cache");
		return;
		
	}
	PLImageLoader* loader = [[PLImageLoader alloc] init];
	[loader fetchForImageView:self URL:urlstr cacheEnable:NO userInfo:info];
	[[PLHttpQueue sharedQueue] addQueueItem:loader];
	[loader release];
}

@end
