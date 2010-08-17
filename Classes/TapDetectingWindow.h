//
//  TapDetectingWindow.h
//  PlutoLand
//
//  Created by xhan on 10-8-11.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TapDetectingWindowDelegate <NSObject>

- (void)userDidTapWebView:(id)tapPoint;
@end

@interface TapDetectingWindow : UIWindow {
    UIView *viewToObserve;
    id <TapDetectingWindowDelegate> controllerThatObserves;
}

@property (nonatomic, retain) UIView *viewToObserve;
@property (nonatomic, assign) id <TapDetectingWindowDelegate> controllerThatObserves;

@end
