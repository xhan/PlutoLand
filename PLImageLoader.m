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
	_fetcherObject = fetcher;
	
	_isCacheEnable = cacheEnable;
	_isFreshOnSucceed = isFresh;	
	self.info = [NSMutableDictionary dictionaryWithDictionary:info];
	
	[super requestGet:url];
}

+ (void)fetchURL:(NSString*)url object:(id)object userInfo:(NSDictionary *)info
{
	//we don't use notification here
	UIImage* cachedImg = [[PLImageCache sharedCache] getImageByURL:url];
	if (cachedImg) {
		if ([object respondsToSelector:@selector(fetchedSuccessed:userInfo:)]) {
			[object fetchedSuccessed:cachedImg userInfo:info];
		}		
	}else {
		PLImageLoader* loader = [[PLImageLoader alloc] init];	
		[loader fetchForObject:object URL:url freshOnSucceed:NO cacheEnable:YES userInfo:info];
		[[PLHttpQueue sharedQueue] addQueueItem:loader];
		[loader release];	
	}

}

#pragma mark -
#pragma mark PLImageRequestDelegate
- (void)imageRequestFailed:(PLImageRequest*)request withError:(NSError*)error
{
	PLOGERROR(@"error on fetch image: %@, msg: %@",self.url,[error localizedDescription]);
	//we don't need clean stuffs bcz LoadInstance only works for one URL
}

- (void)imageRequestSucceeded:(PLImageRequest*)request
{
	//TODO: add request costs time
//	NSLog(@"image fetched: %@",self.url);
//	PLOG(@"fetched %@",self.url);
	UIImage* img = [UIImage imageWithData:request.imageData];
	
	
	if (_isFreshOnSucceed && _imageView) {
		_imageView.image = img;
	}
	
	//TODO: add more condition for cache
	[[PLImageCache sharedCache] storeData:request.imageData forURL:[self.url absoluteString]];
	
	[self.info setObject:img forKey:PLINFO_HC_IMAGE];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_IMAGE_LOADER_SUCCEEDED object:_imageView userInfo:self.info];
		
	if (_fetcherObject!= nil && [_fetcherObject respondsToSelector:@selector(fetchedSuccessed:userInfo:)]) {
		[_fetcherObject fetchedSuccessed:img userInfo:self.info];
	}
}


- (void)dealloc {
	[_info release], _info = nil;
	[super dealloc];
}
@end



