//
//  UIDevice+PL.h
//  Apollo
//
//  Created by xhan on 10-10-22.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice(PL)

+ (long long)getTotalDiskSpaceInBytes ;

+ (long long)getFreeDiskSpaceInBytes ;

- (NSString *) platform;
- (NSString *) platformString;

@property(nonatomic,readonly) BOOL isIOS5;

@property(readonly) NSString* currentVersion;
@property(readonly) NSString* currentBuild;

@end
