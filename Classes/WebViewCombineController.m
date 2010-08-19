    //
//  WebViewCombineController.m
//  PlutoLand
//
//  Created by xhan on 10-8-11.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import "WebViewCombineController.h"
#import "TapDetectingWindow.h"

@implementation WebViewCombineController

@synthesize webView;


- (void)loadView {
	[super loadView];
	webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:webView];
	webView.delegate = self;

	TapDetectingWindow* mWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
//    mWindow.viewToObserve = webView;
//    mWindow.controllerThatObserves = self;

	
	
	NSString* path = [[NSBundle mainBundle] pathForResource:@"webViewCombine" ofType:@"html"];
	/*

	NSURL* url = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	 */
	NSString* htmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	NSString *mpath = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:mpath];
	
	
	[webView loadHTMLString:htmlStr baseURL:baseURL];
	
	

}

- (void)viewDidLoad{

//	[self debugSubViewAtIndex:1 view:webView];
}

- (void)debugSubViewAtIndex:(int)index view:(UIView*)aview{
	for (UIView* v in [aview subviews]) {
		NSLog(@"%d:%@",index, NSStringFromClass([v class])); 
		[self debugSubViewAtIndex:index+1 view:v];
	}
}


- (void)dealloc {
    [webView release], webView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark webView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *url = [[request URL] absoluteString];
	NSLog(@"%@",url);
//	NSArray *seperatedStr = [url componentsSeparatedByString:@":"];
//	if ([seperatedStr count] >0 && [[seperatedStr objectAtIndex:0] isEqualToString:@"plurl"]) {
//		return NO;
//	}
	return YES;
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"loading");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSLog(@"finished");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"failed with error:%@",[error localizedDescription]);
}


#pragma mark -

- (void)userDidTapWebView:(id)tapPoint
{
//	NSLog(@"tapped!");
}

@end

