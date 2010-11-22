//
//  PLHttpClient.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "PLHttpClient.h"
#import "PLGlobal.h"

@implementation PLHttpClient

@synthesize userInfo = _userInfo;
@synthesize enableGzipEncoding = _enableGzipEncoding;
@synthesize startImmediately = _startImmediately;



static const int timeOutSec = 30;
static NSStringEncoding _gEncoding;

#pragma mark -
#pragma mark CLass methods

+ (void)initialize
{
	_gEncoding = NSUTF8StringEncoding;
}

+ (void)setGlobalEncoding:(NSStringEncoding)encoding
{
	_gEncoding = encoding;
}

+ (NSData*)simpleSyncGet:(NSString*)urlStr
{
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
	return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

+ (NSString*)syncGet:(NSURL*)url
{
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	return [[[NSString alloc] initWithData:responseData encoding:_gEncoding] autorelease]; 
}

#pragma mark -
#pragma mark life cycle

@synthesize url = _url;
@synthesize didFailSelector = _didFailSelector;
@synthesize didFinishSelector = _didFinishSelector;
@synthesize delegate = _delegate;

- (id)init
{
	if (self = [super init]) {
		_receivedData = [[NSMutableData alloc] init];
		_delegate = nil;
		//		isStarted =	isFinished = isCancelled = NO;	
		_didFailSelector = @selector(httpClient:failed:);
		_didFinishSelector = @selector(httpClient:successed:);
		_startImmediately = YES;
		_enableGzipEncoding = NO;
	}
	return self;
}

- (void)dealloc {
	[self cancel];
	[_userInfo release], _userInfo = nil;
	PLSafeRelease(_url);
	PLSafeRelease(_response);
	PLSafeRelease(_connection);
	PLSafeRelease(_receivedData);
	[super dealloc];
}

- (void)clean{
	[self cancel];
	PLSafeRelease(_url);
	PLSafeRelease(_response);
	PLSafeRelease(_connection);
	PLSafeRelease(_receivedData);		
	_receivedData = [[NSMutableData alloc] init];
	self.userInfo = nil;
}

#pragma mark -
#pragma mark public

- (void)get:(NSURL *)url{
	[self get:url userInfo:nil];
}

- (void)get:(NSURL *)url userInfo:(NSDictionary*)info;
{
	[self clean];
	self.userInfo = info;
	if(_url != url ){
		PLSafeRelease(_url);
		_url = [url retain];
	}
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:_url];	
	[request setTimeoutInterval:timeOutSec];
	if (_enableGzipEncoding) {
		[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	}
	
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:_startImmediately];
	[request release];	
}

- (void)post:(NSURL*)url body:(NSString*)body
{
	[self clean];
	self.userInfo = nil;
	if(_url != url ){
		PLSafeRelease(_url);
		_url = [url retain];
	}
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:_url];	
	[request setTimeoutInterval:timeOutSec];
	[request setHTTPMethod:@"POST"];
	if (body) {
		[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:_startImmediately];
	[request release];	
}

- (void)cancel
{
	[_connection cancel];	
}

- (void)start
{
	if(_connection && _startImmediately == NO){
		[_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[_connection start];		
	}
}

- (NSString*)stringValue
{
	if (_receivedData) {
		return [[[NSString alloc] initWithData:_receivedData encoding:_gEncoding] autorelease];
	}
	return nil;
}

#pragma mark -
#pragma mark Delegate for NSURLRequest

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	if ([self.delegate respondsToSelector:self.didFailSelector] ) {
		[self.delegate performSelector:self.didFailSelector withObject:self withObject:error];
	}
	//	PLLOG_STR(@"failed",nil);
	//	isFinished = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	if ([self.delegate respondsToSelector:self.didFinishSelector] ) {
		[self.delegate performSelector:self.didFinishSelector withObject:self withObject:_receivedData];
	}	
	//	PLLOG_STR(@"finished",nil);
	
	//	self.isFinished = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aresponse {
	_response = [(NSHTTPURLResponse*)aresponse retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_receivedData appendData:data];
}

@end



