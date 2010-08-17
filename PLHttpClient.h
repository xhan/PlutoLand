//
//  PLHttpClient.h
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLHttpClientDelegate;
@interface PLHttpClient : NSObject {
@private
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
	NSHTTPURLResponse* _response;
	
	NSURL* _url;
	
	SEL _didFinishSelector;
	SEL _didFailSelector;
	id<PLHttpClientDelegate> _delegate;	
	BOOL _startImmediately;
}

@property (nonatomic, assign) BOOL startImmediately;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, assign) SEL didFailSelector;
@property (nonatomic, assign) SEL didFinishSelector;
@property (nonatomic, assign) id<PLHttpClientDelegate> delegate;


// (deprecated) return response by sync fetch  
+ (NSData*)simpleSyncGet:(NSString*)urlStr;

// return response string by sync fetch
+ (NSString*)syncGet:(NSURL*)url;


- (void)get:(NSURL*)url;

- (void)cancel;

// works if set startImmediately to false
- (void)start;

- (void)clean;

@end


@protocol PLHttpClientDelegate <NSObject>

- (void)httpClient:(PLHttpClient*)hc failed:(NSError*)error;
- (void)httpClient:(PLHttpClient*)hc successed:(NSData*)data;

@end

