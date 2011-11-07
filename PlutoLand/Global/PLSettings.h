//
//  PLSettings.h
//  
//
//  Created by xhan on 10-10-8.
//  Copyright 2010 ixHan.com. All rights reserved.
//

#import <Foundation/Foundation.h>


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
 
 - (void)setupDefaults{
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
}PLSettingType;

@interface PLSettings : NSObject {
	NSUserDefaults* _defaults;
    BOOL _isDynamicProperties;
    BOOL _isFirstLaunched;
}
@property(nonatomic,assign)BOOL isDynamicProperties;
@property(nonatomic,readonly) BOOL isFirstLaunched;

- (void)synchronize;

- (void)reset;

+ (void)setupProperty:(NSString*)property forKey:(NSString*)key withType:(PLSettingType)type archive2Data:(BOOL)archived;

+ (void)setupProperty:(NSString *)property withType:(PLSettingType)type;

// for custom object with transformer(conformed to PLSettingTransformerProtocal protocol)
// this method only works on isDynamicProperties set to NO
+ (void)setupProperty:(NSString *)property withTransformer:(Class)transformer;

// the property should only be object that conforms to protocol <nscoding>
+ (void)setupPropertyWithArchivedType:(NSString *)property;

+ (void)setupRoutes;
- (void)setupDefaults;

- (NSString*)stringForFirstLoadCheck;

/** 
 migration support, default version is 1 
 */
- (int)version;

/**
 method will be invoked if version is not matched
 */
- (void)migrateFromOldVersion:(int)oldVersion;

- (void)_readPropertiesFromDefaults;
- (void)_writePropertiesToDefaults;


@end



@protocol PLSettingTransformerProtocol <NSObject>
@required
+ (id)transformedValue:(id)sender;
+ (id)reverseTransformedValue:(id)sender;
@end

