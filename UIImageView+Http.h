//
//  UIImageView+Http.h
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImageView(Http)

- (void) fetchImageFromURL:(NSString*)urlstr userInfo:(NSDictionary*)info;

@end
