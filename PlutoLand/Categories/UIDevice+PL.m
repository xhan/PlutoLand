//
//  UIDevice+PL.m
//  Apollo
//
//  Created by xhan on 10-10-22.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import "UIDevice+PL.h"
#import "PLCore.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#import <AdSupport/AdSupport.h>

@implementation UIDevice(PL)


+ (long long)getTotalDiskSpaceInBytes 
{
    long long totalSpace = 0;
    NSError *error = nil;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error: &error];
	
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = dictionary[NSFileSystemSize];
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
        NSNumber *fileSystemSizeInBytes = dictionary[NSFileSystemFreeSize];
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
    NSString *platform = @(machine);
    free(machine);
    return platform;
}

// get updates from
// https://gist.github.com/Jaybles/1323251
- (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (GSM)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

- (BOOL)isIOS5
{
    return self.isIOS5above;
}

- (BOOL)isIOS5above
{
    static int __isIOS5above = -1;
    if (__isIOS5above == -1) {
        __isIOS5above = (int)([[self systemVersion] floatValue]) >= 5;
    }
    return __isIOS5above ;
}

- (BOOL)isIOS6above
{
    static int __isIOS6above = -1;
    if (__isIOS6above == -1) {
        __isIOS6above = (int)([[self systemVersion] floatValue]) >= 6;
    }
    return __isIOS6above ;
}

- (BOOL)isIOS7AndAbove
{
    static int __isIOS7above = -1;
    if (__isIOS7above == -1) {
        __isIOS7above = (int)([[self systemVersion] floatValue]) >= 7;
    }
    return __isIOS7above ;
}

- (BOOL)isIOS8AndAbove
{
    static int __isIOS8above = -1;
    if (__isIOS8above == -1) {
        __isIOS8above = (int)([[self systemVersion] floatValue]) >= 8;
    }
    return __isIOS8above ;
}

- (NSString*)currentBuild
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]; 
}

- (NSString*)currentVersion
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]; 
}


- (BOOL) isJailbreak
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    NSString *filePath = @"/Applications/Cydia.app";
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
#endif
    
}


- (BOOL) isIAPcrack
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    
//    越狱软件对这个方法做了hook
    
//    BOOL ret = NO;
//    for (NSString*hack in @[@"IAPFreeService",@"LocalIAPStore"]) {
//        ret = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/Library/MobileSubstrate/DynamicLibraries/%@.dylib",hack]];
//        if (ret) {
//            PLOGERROR(@"found bad hacks %@",hack);
//            break;
//        }
//    }
    
    NSString *path = @"/Library/MobileSubstrate/DynamicLibraries";
    NSFileManager*a = [NSFileManager defaultManager];
    NSArray* files = [a contentsOfDirectoryAtPath:path error:nil];
    for (NSString*hack in @[@"IAPFreeService",@"LocalIAPStore"]) {
        for (NSString*file in files) {
            if ([file rangeOfString:hack].location != NSNotFound) {
                PLOGERROR(@"found bad hacks %@",hack);
//                ret = YES;
                return YES;
            }
        }

    }
//    PLOG_OBJ([a contentsOfDirectoryAtPath:path error:nil]);
    
    return NO;
#endif
}

@end


#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "NSString+Addition.h"
@interface UIDevice(Private)

- (NSString *) macaddress;

@end

@implementation UIDevice (IdentifierAddition)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *udid = [stringToHash md5];
    
    return udid;
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *udid = [macaddress md5];
    
    return udid;
}

@end


////////////////////////////////////////////////////////////////////////////////
@implementation UIDevice(Process)

+ (NSArray *)runningProcesses {
    return [self runningProcesses:YES];
}
+ (NSArray *)runningProcesses:(BOOL)isMoreInfo{
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                
                for (int i = nprocess - 1; i >= 0; i--){
                    
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    if (isMoreInfo) {
                        NSDictionary * dict = @{@"id":processID, @"name":processName};
                        [array addObject:dict];
                    }else{
                        [array addObject:processName];
                    }

                    [processID release];
                    [processName release];

                }
                
                free(process);
                return [array autorelease];
            }
        }
    }
    
    return nil;
    

}

@end




@implementation UIDevice (NetDetect)

- (int) dataNetworkTypeFromStatusBar
{
    /*
     Make sure that the Status bar is not hidden in your application. if it's not visible it will always return No wifi or cellular because your code reads the text in the Status bar thats all.
     
     
     0 = No wifi or cellular  - gprs return 0
     1 = 2G and earlier? (not confirmed)
     2 = 3G? (not yet confirmed)
     3 = 4G
     4 = LTE
     5 = Wifi
     
     */
    static int networkType = 0;
    UIApplication *app = [UIApplication sharedApplication];
    if (!app.statusBarHidden) {
        NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"]    subviews];
        NSNumber *dataNetworkItemView = nil;
        
        for (id subview in subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                dataNetworkItemView = subview;
                break;
            }
        }
        int value =  [[dataNetworkItemView valueForKey:@"dataNetworkType"] intValue];
        networkType = value;
    }
    return networkType;

}

@end



// ios7 and later
@implementation UIDevice (UUID)
- (NSString *) adUUID
{
    NSString* uuid = nil;
    if (NSClassFromString(@"ASIdentifierManager")) {
        uuid = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];;
    }
    return uuid;
}

@end


UIDevice* MyDevice()
{
    return [UIDevice currentDevice];
}