//
//  PLHttpClient.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "PLHttpClient.h"


@implementation PLHttpClient


+ (NSData*)simpleSyncGet:(NSString*)urlStr
{
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
	return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

@end
