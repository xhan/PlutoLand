//
//  PLImageClient.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

//TODO: add cache function at fetch method and store method(succeeded on fetching img data)

#import "PLImageLoader.h"


@implementation PLImageLoader

@synthesize info = _info;

- (id)init
{
	if (self = [super init]) {
		self.delegate = self;
		_imageView = nil;
	}
	return self;
}

- (void)fetchForImageView:(UIImageView*)imageView URL:(NSString*)url cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary*)info;
{
	_imageView = imageView;
	_isCacheEnable = cacheEnable;
//	_typeID = typeID;
//	_uID = uid;
	self.info = info;
	[super requestGet:url];
}


#pragma mark -
#pragma mark PLImageRequestDelegate
- (void)imageRequestFailed:(PLImageRequest*)request withError:(NSError*)error
{
//	PLLOG_STR(@"error on fetch image: ",self.url);
}

- (void)imageRequestSucceeded:(PLImageRequest*)request
{
//	NSLog(@"image getted");
	UIImage* img = [UIImage imageWithData:request.imageData];
	if (_imageView) {
		_imageView.image = img;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_IMAGE_LOADER_SUCCEEDED object:_imageView userInfo:_info];
}


- (void)dealloc {
	[_info release], _info = nil;
	[super dealloc];
}
@end

