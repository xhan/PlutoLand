//
//  PLAlertView.m
//  QiuBai
//
//  Created by xu xhan on 12/17/11.
//  Copyright (c) 2011 Less Everything. All rights reserved.
//

#import "PLAlertView.h"

@implementation _PLAlertView

- (void)setBlock:(void (^)(int,BOOL))block;
{
    _blockDelegate = Block_copy(block);
    self.delegate = self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _blockDelegate(buttonIndex,alertView.cancelButtonIndex == buttonIndex);
}

- (void)dealloc
{
    Block_release(_blockDelegate);
    [super dealloc];
}
@end


extern void PLAlert(NSString*title,NSString*body,NSString*cancel,NSString*button,void (^block)(int index,BOOL isCancel))
{
    _PLAlertView*v= [[_PLAlertView alloc] initWithTitle:title
                                                        message:body
                                                       delegate:nil
                                              cancelButtonTitle:cancel
                                              otherButtonTitles:button,nil];
    [v setBlock:block];
    
    //    va_list args;
    //    va_start(args, buttons);
    //    NSString* button = NULL;
    //    while (YES) {
    //        button = va_arg(args, NSString*);
    //        if (!button) {
    //            break;
    //        }
    //        [v addButtonWithTitle:button];
    //    }
    //    va_end(args);
    [v show];
    [v release];
    
}