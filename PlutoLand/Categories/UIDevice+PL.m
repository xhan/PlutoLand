//
//  UIDevice+PL.m
//  Apollo
//
//  Created by xhan on 10-10-22.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import "UIDevice+PL.h"
#import "PLGlobal.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice(PL)


+ (long long)getTotalDiskSpaceInBytes 
{
    long long totalSpace = 0;
    NSError *error = nil;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error: &error];
	
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes longLongValue];
    } else {
        PLOG(@"Error Obtaining File System Info: Domain = %@, Code = %@", [error domain], [error code]);
    }
	
    return totalSpace;
}  

+ (long long)getFreeDiskSpaceInBytes
{
    long long totalSpace = 0;
    NSError *error = nil;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error: &error];
	
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes longLongValue];
    } else {
        PLOG(@"Error Obtaining File System Info: Domain = %@, Code = %@", [error domain], [error code]);
    }
	
    return totalSpace;	
}


- (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return platform;
}

- (BOOL)isIOS5
{
    return (int)([[self systemVersion] floatValue]) == 5; 
}

- (NSString*)currentBuild
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; 
}

- (NSString*)currentVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; 
}


@end
