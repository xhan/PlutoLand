//
//  PLAlertView.h
//  QiuBai
//
//  Created by xu xhan on 12/17/11.
//  Copyright (c) 2011 Less Everything. All rights reserved.
//

#import <UIKit/UIKit.h>



extern void PLAlert(NSString*title,NSString*body,void (^block)(int index,BOOL isCancel),NSString*cancel,NSString*button);



/* This is a private class, use *PLAlert* instead */
@interface _PLAlertView : UIAlertView<UIAlertViewDelegate>{
@private
    void (^_blockDelegate)(int,BOOL);
}
- (void)setBlock:(void (^)(int,BOOL))block;
@end




