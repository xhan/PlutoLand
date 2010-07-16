//
//  PLHttpClient.h
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: move PLImageRequest's content to here
@interface PLHttpClient : NSObject {

}

// return response by sync fetch
+ (NSData*)simpleSyncGet:(NSString*)urlStr;
   
@end
