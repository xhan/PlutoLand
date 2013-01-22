//
//  PLActionSheet.m
//  QiuBai
//
//  Created by xu xhan on 1/5/12.
//  Copyright (c) 2012 Less Everything. All rights reserved.
//

#import "PLActionSheet.h"

@implementation PLActionSheet


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
