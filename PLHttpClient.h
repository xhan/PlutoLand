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

// (deprecated) return response by sync fetch  
+ (NSData*)simpleSyncGet:(NSString*)urlStr;
   
// return response string by sync fetch
+ (NSString*)syncGet:(NSURL*)url;

@end
