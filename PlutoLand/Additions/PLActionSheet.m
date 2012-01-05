//
//  PLActionSheet.m
//  QiuBai
//
//  Created by xu xhan on 1/5/12.
//  Copyright (c) 2012 Less Everything. All rights reserved.
//

#import "PLActionSheet.h"

@implementation PLActionSheet

//- (void)showFromToolbar:(UIToolbar *)view{
//    self.delegate = self;
//    [super showFromToolbar:view];
//}
//- (void)showFromTabBar:(UITabBar *)view
//{
//    self.delegate = self;
//    [super showFromTabBar:view];
//}
//- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated 
//{
//    self.delegate = self;
//    [super showFromBarButtonItem:item animated:animated];
//}
//
//- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
//{
//    self.delegate = self;
//    [super showFromRect:rect inView:view animated:animated];
//}
//- (void)showInView:(UIView *)view
//{
//    self.delegate = self;
//    [super showInView:view];
//}

- (void)setCallBack:(void (^)(int index,BOOL isCancel))block
{
    self.delegate = self;
    _blockDelegate = Block_copy(block);
}

- (void)dealloc
{
    if (_blockDelegate) {
        Block_release(_blockDelegate);
    }
    [super dealloc];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _blockDelegate(buttonIndex,actionSheet.cancelButtonIndex == buttonIndex);
}
@end
