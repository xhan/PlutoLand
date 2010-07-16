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


- (void)fetchByURL:(NSString*)urlstr userInfo:(NSDictionary*)info freshOnSucceed:(BOOL)isFresh
{
	UIImage* aimage = nil;
	if (aimage = [[PLImageCache sharedCache] getImageByURL:urlstr]) {
		self.image = aimage;
		NSLog(@"cache :%@",urlstr);
		return;
		
	}
	PLImageLoader* loader = [[PLImageLoader alloc] init];	
	[loader fetchForImageView:self URL:urlstr freshOnSucceed:isFresh cacheEnable:YES userInfo:info];
	[[PLHttpQueue sharedQueue] addQueueItem:loader];
	[loader release];	
}

- (void)fetchByURL:(NSString*)urlstr
{
	return [self fetchByURL:urlstr userInfo:nil freshOnSucceed:YES];
}

@end
