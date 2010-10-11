//
//  SettingTestCase.h
//  PlutoLand
//
//  Created by xhan on 10-10-11.
//  Copyright 2010 ixhan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSettings.h"

@interface SettingTestCase : PLSettings

@property(assign) NSString* name;
@property(assign) int age;
@property(assign) float score;
@property(assign) BOOL male;

+ (SettingTestCase*)singleton;

@end
