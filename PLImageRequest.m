//
//  PLImageRequest.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "PLImageRequest.h"

#define PL_DEBUG 1

#if PL_DEBUG 
#define PLLOG_STR(_obj_,_str_) NSLog(@"%@ %@",_obj_,_str_)
#else
#define PLLOG_STR(_obj_,_str_)
#endif

@implementation PLImageRequest

@synthesize url = _url;
@synthesize didFailSelector = _didFailSelector;
@synthesize didFinishSelector = _didFinishSelector;
@synthesize delegate = _delegate;
@synthesize response = _response;
@synthesize isCancelled , isFinished , isStarted;
@dynamic imageData;

static const int timeOutSec = 30;

#pragma mark -
#pragma mark NSObject

- (id)init
{
	if (self = [super init]) {
		_receivedData = [[NSMutableData alloc] init];
		_delegate = nil;
		isStarted =	isFinished = isCancelled = NO;	
		_didFailSelector = @selector(imageRequestFailed:withError:);
		_didFinishSelector = @selector(imageRequestSucceeded:);		
	}
	return self;
}

- (id)initWithURL:(NSString*)urlStr
{
	if (self = [self init]) {
		[self requestGet:urlStr];		
	}
	return self;
}

- (void)requestGet:(NSString*)urlStr
{
	_url = [[NSURL URLWithString:urlStr] retain];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:_url];
	[request setTimeoutInterval:timeOutSec];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
	[request release];	
}

- (void)dealloc {
	[_url release], _url = nil;
	[_response release], _response = nil;
	[_connection release], _connection =nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Public

- (void)start
{
	[_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_connection start];
	isStarted = YES;
}

- (void)cancel;
{
	[_connection cancel];
	isCancelled = YES;
}

- (NSData*)imageData
{
	if (!isFinished || [_receivedData length] == 0) {
		return nil;
	}
	return _receivedData;
}


#pragma mark -
#pragma mark Delegate for NSURLRequest

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

	if ([self.delegate respondsToSelector:self.didFailSelector] ) {
		[self.delegate performSelector:self.didFailSelector withObject:self withObject:error];
	}
	PLLOG_STR(@"failed",nil);
	isFinished = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	if ([self.delegate respondsToSelector:self.didFinishSelector] ) {
		[self.delegate performSelector:self.didFinishSelector withObject:self];
	}	
	PLLOG_STR(@"finished",nil);
	
	isFinished = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aresponse {
	self.response = (NSHTTPURLResponse*)aresponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_receivedData appendData:data];
}

@end








