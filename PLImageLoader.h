//
//  PLImageClient.h
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLImageRequest.h"

#define NOTICE_IMAGE_LOADER_SUCCEEDED @"NOTICE_IMAGE_LOADER_SUCCEEDED"
extern NSString * const PLINFO_HC_IMAGE;

@protocol PLImageFetcherProtocol;
@interface PLImageLoader : PLImageRequest<PLImageRequestDelegate> {
	
	UIImage* _image;
	
	UIImageView* _imageView;
	UIButton* _storeButton;
	UIControlState _buttonState;
	BOOL _buttonUseBackground;	//tell if use background image
	
	BOOL _isCacheEnable;
	BOOL _isFreshOnSucceed;
	
	NSMutableDictionary* _info;
	
	id _fetcherObject;
}

@property (nonatomic, retain) NSMutableDictionary *info;


//this will be deprecated soon if new api finished
- (void)fetchForImageView:(UIImageView*)imageView URL:(NSString*)url cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary*)info;

- (void)fetchForImageView:(UIImageView *)imageView URL:(NSString *)url  freshOnSucceed:(BOOL)isFresh cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary *)info;


- (void)fetchForObject:(id<PLImageFetcherProtocol>)fetcher URL:(NSString *)url  freshOnSucceed:(BOOL)isFresh cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary *)info;


//Public method, the object mush implement the PLImageFetcherProtocol delegate
//default cache
+ (void)fetchURL:(NSString*)url object:(id)object userInfo:(NSDictionary *)info;

@end





@protocol PLImageFetcherProtocol <NSObject>
@optional

// @property(nonatomic,readwrite) UIImage *image;

- (void)fetchedSuccessed:(UIImage*)image userInfo:(NSDictionary*)info;
- (void)fetchedFailed:(UIImage*)image userInfo:(NSDictionary*)info;

@end

