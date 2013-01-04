//
//  PLImageRequest.h
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLImageRequestDelegate;
@interface PLImageRequest : NSObject {
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
	NSHTTPURLResponse* _response;
	
	NSURL* _url;
	//delegate
	SEL _didFinishSelector;
	SEL _didFailSelector;
	id<PLImageRequestDelegate> _delegate;
	
	BOOL isStarted;	
	BOOL isCancelled;
	// value will be true no matter failed or succeeded
	BOOL isFinished;
	
	int statusCode;
}

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, assign) SEL didFailSelector;
@property (nonatomic, assign) SEL didFinishSelector;
@property (nonatomic, assign) id<PLImageRequestDelegate> delegate;
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, assign) BOOL isCancelled;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, readonly) BOOL isStarted;


@property (nonatomic, readonly) NSData* imageData;

- (id)initWithURL:(NSString*)url;

- (void)requestGet:(NSString*)urlStr;

- (void)start;

- (void)cancel;


@end


@protocol PLImageRequestDelegate <NSObject>

- (void)imageRequestFailed:(PLImageRequest*)request withError:(NSError*)error;
- (void)imageRequestSucceeded:(PLImageRequest*)request;

@end






