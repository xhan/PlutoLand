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

@property(nonatomic,readonly) BOOL isIOS5;  //deprecate
@property(nonatomic,readonly) BOOL isIOS5above;
@property(nonatomic,readonly) BOOL isIOS6above;

@property(readonly) NSString* currentVersion;
@property(readonly) NSString* currentBuild;

@property(readonly) BOOL isJailbreak;
@end

@interface UIDevice (IdentifierAddition)

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;

@end





@interface UIDevice (Process)
+ (NSArray *)runningProcesses;
+ (NSArray *)runningProcesses:(BOOL)isMoreInfo; //default is true -> dict with process name and PID
@end