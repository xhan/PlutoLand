//
//  PLImageClient.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

//TODO: add cache function at fetch method and store method(succeeded on fetching img data)

#import "PLImageLoader.h"
#import "PLImageCache.h"
#import "PLHttpQueue.h"

NSString* const PLINFO_HC_IMAGE = @"PLINFO_HC_IMAGE";

@implementation PLImageLoader

@synthesize info = _info;

- (id)init
{
	if (self = [super init]) {
		self.delegate = self;
		_imageView = nil;
		_isCacheEnable = YES;
		_isFreshOnSucceed = YES;
	}
	return self;
}

- (void)fetchForImageView:(UIImageView*)imageView URL:(NSString*)url cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary*)info;
{	
	[self fetchForImageView:imageView URL:url freshOnSucceed:YES cacheEnable:cacheEnable userInfo:info];
}


- (void)fetchForImageView:(UIImageView *)imageView URL:(NSString *)url  freshOnSucceed:(BOOL)isFresh cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary *)info
{
	_imageView = imageView;
	_isCacheEnable = cacheEnable;
	_isFreshOnSucceed = isFresh;
	
	self.info = [NSMutableDictionary dictionaryWithDictionary:info];
	[super requestGet:url];
	
}

- (void)fetchForObject:(id<PLImageFetcherProtocol>)fetcher URL:(NSString *)url  freshOnSucceed:(BOOL)isFresh cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary *)info
{
	_imageContainer = fetcher;
	
	_isCacheEnable = cacheEnable;
	_isFreshOnSucceed = isFresh;	
	self.info = [NSMutableDictionary dictionaryWithDictionary:info];
	
	[super requestGet:url];
}

#pragma mark -
#pragma mark PLImageRequestDelegate
- (void)imageRequestFailed:(PLImageRequest*)request withError:(NSError*)error
{
	NSLog(@"error on fetch image: ",self.url);
}

- (void)imageRequestSucceeded:(PLImageRequest*)request
{
	
	UIImage* img = [UIImage imageWithData:request.imageData];
	
	
	if (_isFreshOnSucceed && _imageView) {
		_imageView.image = img;
	}
	
	//TODO: add more condition for cache
	[[PLImageCache sharedCache] storeData:request.imageData forURL:[self.url absoluteString]];
	
	[self.info setObject:img forKey:PLINFO_HC_IMAGE];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_IMAGE_LOADER_SUCCEEDED object:_imageView userInfo:self.info];
	
	
	if (_imageContainer && [_imageContainer respondsToSelector:@selector(fetchedSuccessed:userInfo:)]) {
		[_imageContainer fetchedSuccessed:img userInfo:self.info];
	}
}


- (void)dealloc {
	[_info release], _info = nil;
	[super dealloc];
}
@end



#pragma mark -
@implementation NSObject(PLHttpImageFetcher)

- (void)fetchByURL:(NSString*)urlstr userInfo:(NSDictionary*)info freshOnSucceed:(BOOL)isFresh
{
	id<PLImageFetcherProtocol> obj = self;
	UIImage* aimage = nil;
	if (aimage = [[PLImageCache sharedCache] getImageByURL:urlstr]) {
		//self.image = aimage;
		//NSLog(@"cache :%@",urlstr);
		[obj fetchedSuccessed:aimage userInfo:info];
		return;
		
	}
	PLImageLoader* loader = [[PLImageLoader alloc] init];	
	//	[loader fetchForImageView:self URL:urlstr freshOnSucceed:isFresh cacheEnable:YES userInfo:info];
	[loader fetchForObject:obj URL:urlstr freshOnSucceed:isFresh cacheEnable:YES userInfo:info];
	[[PLHttpQueue sharedQueue] addQueueItem:loader];
	[loader release];	
}

- (void)fetchByURL:(NSString*)urlstr
{
	return [self fetchByURL:urlstr userInfo:nil freshOnSucceed:YES];
}

@end
