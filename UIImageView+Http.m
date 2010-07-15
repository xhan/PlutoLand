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

@implementation UIImageView(Http)

- (void) fetchImageFromURL:(NSString*)urlstr userInfo:(NSDictionary*)info
{
	PLImageLoader* loader = [[PLImageLoader alloc] init];
	[loader fetchForImageView:self URL:urlstr cacheEnable:NO userInfo:info];
	[[PLHttpQueue sharedQueue] addQueueItem:loader];
	[loader release];
}

@end
