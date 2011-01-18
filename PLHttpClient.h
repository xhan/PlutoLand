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
//@private
	@protected
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
	NSHTTPURLResponse* _response;
	
	NSURL* _url;
	
	SEL _didFinishSelector;
	SEL _didFailSelector;
	id<PLHttpClientDelegate> _delegate;	
	BOOL _startImmediately;
	
	BOOL _enableGzipEncoding;
	NSDictionary* _userInfo;
	int statusCode;
	
}

@property (nonatomic, assign,readonly) int statusCode;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, assign) BOOL enableGzipEncoding; //default value is NO. set value to YES to enable Gzip decoding of http contents

@property (nonatomic, assign) BOOL startImmediately;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, assign) SEL didFailSelector;
@property (nonatomic, assign) SEL didFinishSelector;
@property (nonatomic, assign) id<PLHttpClientDelegate> delegate;
@property (nonatomic, readonly) NSHTTPURLResponse* response;
+ (void)setGlobalEncoding:(NSStringEncoding)encoding;

// (deprecated) return response by sync fetch  
+ (NSData*)simpleSyncGet:(NSString*)urlStr;

// return response string by sync fetch
+ (NSString*)syncGet:(NSURL*)url;


- (void)get:(NSURL*)url;
- (void)get:(NSURL *)url userInfo:(NSDictionary*)info;
- (void)post:(NSURL*)url body:(NSString*)body;

- (void)cancel;

// works if set startImmediately to false
- (void)start;

- (void)clean;

//return string value with default encoding
- (NSString*)stringValue;
- (id)responseHeaderForKey:(NSString*)key;


- (id)initWithDelegate:(id<PLHttpClientDelegate>) delegate;

@end


@protocol PLHttpClientDelegate <NSObject>

- (void)httpClient:(PLHttpClient*)hc failed:(NSError*)error;
- (void)httpClient:(PLHttpClient*)hc successed:(NSData*)data;

@end




