//
//  PLActionSheet.h
//  QiuBai
//
//  Created by xu xhan on 1/5/12.
//  Copyright (c) 2012 Less Everything. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 use it as normal UIActionSheet
 */
@interface PLActionSheet : UIActionSheet<UIActionSheetDelegate>
{
@private
    void (^_blockDelegate)(int,BOOL);
}
- (void)setCallBack:(void (^)(int index,BOOL isCancel))block;
@end
