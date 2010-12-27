//
//  UIDevice+PL.h
//  Apollo
//
//  Created by xhan on 10-10-22.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice(PL)

#define KByte 1024
#define MByte (KByte * KByte)
#define GByte (MByte * KByte)


+ (long long)getTotalDiskSpaceInBytes ;

+ (long long)getFreeDiskSpaceInBytes ;

@end
