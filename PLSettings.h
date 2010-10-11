//
//  PLSettings.h
//  
//
//  Created by xhan on 10-10-8.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


//TODO: add version and migration support (is that necessary?)
//TODO: namespace support ?

// umcomment following line to stop persisent data into disk
//
//#define DEBUG_MODE

/* 
 PLSettings is an abstract class to be convenient to load and store tiny
 user datas. Main functions are provided by NSUserDefaults.
 
 USAGE
 =====
 * Subclass PLSettings
 * add your own properties and configure specify keys for them.
 * use your class instance as simple as NSObject
 * by calling -synchronize to persist datas into db.
 
 EXAMPLE
 =======
 
 ////////////////////////////////////////////
 // interface
 
 @interface TestSetting : PLSettings
 
 @property(assign) NSString* name;
 @property(assign) int age;
 @property(assign) float score;
 @property(assign) BOOL male;
 
 @end
 
 ////////////////////////////////////////////
 // implement
 @implementation TestSetting
 
 @dynamic name, age, score, male;
 
 - (void)loadDefaults{
 //implement by subclass, this method will only invoked once
 self.name = @"xhan";
 self.age = 23;
 self.score = 87.5;
 self.male = YES;
 }
 
 + (void)setupRoutes{
 [self setupProperty:@"name" withType:PLSettingTypeObject];
 [self setupProperty:@"age" withType:PLSettingTypeInt];
 [self setupProperty:@"score" withType:PLSettingTypeFloat];
 [self setupProperty:@"male" withType:PLSettingTypeBool];
 }
 
 @end
 
 
 */


typedef enum {
	PLSettingTypeInt = 0,
	PLSettingTypeFloat,
	PLSettingTypeBool,
	PLSettingTypeObject
//	PLSettingTypeString,
//	PLSettingTypeArray
}PLSettingType;

@interface PLSettings : NSObject {
	NSUserDefaults* _defaults;
}


- (void)synchronize;

- (void)reset;

+ (void)setupProperty:(NSString*)property forKey:(NSString*)key withType:(PLSettingType)type;

+ (void)setupProperty:(NSString *)property withType:(PLSettingType)type;


+ (void)setupRoutes;
- (void)loadDefaults;
- (NSString*)stringForFirstLoadCheck;

@end
