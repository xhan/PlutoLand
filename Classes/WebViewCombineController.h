//
//  WebViewCombineController.h
//  PlutoLand
//
//  Created by xhan on 10-8-11.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewCombineController : UIViewController<UIWebViewDelegate> {
	UIWebView* webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end

