//
//  PLSettings.m
//  
//
//  Created by xhan on 10-10-8.
//  Copyright 2010 ixHan.com. All rights reserved.
//

#import "PLSettings.h"
#import <objc/runtime.h>

////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark PLSettingProperty

@interface PLSettingProperty : NSObject
{
	NSString* _getter;
	NSString* _setter;
	NSString* _key;
	PLSettingType _type;
}

@property (nonatomic, assign) PLSettingType type;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *setter;
@property (nonatomic, copy) NSString *getter;

+ (id)propertyByName:(NSString*)name key:(NSString*)key type:(PLSettingType)type;
//- (id)initWithPropertyByName:(NSString*)name key:(NSString*)key type:(PLSettingType)type;

+ (NSString*)setterNameSEL:(NSString*)sel;
- (NSMethodSignature*)signatureForGetter;
- (NSMethodSignature*)signatureForSetter;
@end

@implementation PLSettingProperty

@synthesize type = _type;
@synthesize getter = _getter;
@synthesize setter = _setter;
@synthesize key = _key;

- (void)dealloc
{
	[_key release];
	[_getter release];
	[_setter release];
	[super dealloc];
}

+ (id)propertyByName:(NSString*)name key:(NSString*)key type:(PLSettingType)type
{
	PLSettingProperty* p = [PLSettingProperty new];
	p.getter = name;
	p.setter = [PLSettingProperty setterNameSEL:name];
	p.key = key;
	p.type = type;
	return [p autorelease];
}


+ (NSString*)setterNameSEL:(NSString*)sel
{
	unichar upcaseCapitalized = [[sel capitalizedString] characterAtIndex:0];
	return [NSString stringWithFormat:@"set%c%@:",upcaseCapitalized,
			[sel substringFromIndex:1]];
}

- (NSMethodSignature*)signatureForGetter
{
	// 	"i^v^c^c" means int(RETURN tyle), void* (CLASS), char* (SEL), char* (ARGS)
	// http://developer.apple.com/library/mac/#DOCUMENTATION/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
	char p[]= "ifc@";
	char types[] = "_^v^c^@";
	types[0] = p[_type];
	return [NSMethodSignature signatureWithObjCTypes:types];
}

- (NSMethodSignature*)signatureForSetter
{
	//	(void) void*(class) char* sel, char* args, id value
	// new version => (void) void*(class) char* sel, id , argu string
	char p[]= "ifc@";
//	char* types = "v^v^c_^c";
	char types[] = "v^v^c_@";
	types[5] = p[_type];
	return [NSMethodSignature signatureWithObjCTypes:types];
}

@end

////////////////////////////////////////////////////////////////////////////////


#pragma mark -
#pragma mark PLSettings

////////////////////////////////////////////////////////////////////////////////
@interface PLSettings(Private)

- (NSString*)stringForFirstLoadCheck;
- (BOOL)checkIfDataAvailable;
- (BOOL)isSetterProperty:(SEL)selector;
- (void)markAsLoaded;
- (void)versionCheck;
- (void)loadDefaults;
@end

////////////////////////////////////////////////////////////////////////////////

@implementation PLSettings

NSMutableArray* _gPropertiesList;

- (NSString*)stringForFirstLoadCheck{
	//implement by subclass
	return @"PLSettings";
}

- (void)setupDefaults
{
	//implement by subclass, this method will only be invoked once
}

+ (void)setupRoutes
{
	//implement by subclass
}

- (int)version
{
	return 1;
}

- (void)migrateFromOldVersion:(int)oldVersion
{
	// implemented by subclass
	// you also need to handle oldVersion might is greater than current version. (happens uninstall and reinstall an older version apps)

}


+ (void)setupProperty:(NSString*)property forKey:(NSString*)key withType:(PLSettingType)type
{
	[_gPropertiesList addObject:[PLSettingProperty propertyByName:property key:key type:type]];
}

+ (void)setupProperty:(NSString *)property withType:(PLSettingType)type
{
	[self setupProperty:property forKey:property withType:type];
}

+ (void)initialize{
	_gPropertiesList = [[NSMutableArray alloc] init];
	[self setupRoutes];
}



#pragma mark -
#pragma mark public

- (void)synchronize
{
	[_defaults synchronize];
}

- (void)reset
{
	[NSUserDefaults resetStandardUserDefaults];
	[self setupDefaults];
	[self markAsLoaded];
	
}

- (id)init{
	self = [super init];
	_defaults = [[NSUserDefaults standardUserDefaults] retain];
	
	[self loadDefaults];
	
	return self;
}

- (void)dealloc{
	[_defaults release]; _defaults = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark private

- (void)loadDefaults
{
	if (![self checkIfDataAvailable]) {
		[self setupDefaults];		
	}else {
		//[self versionCheck];
		int oldVersion = [_defaults integerForKey:[self stringForFirstLoadCheck]];
		int currentVersion = [self version];
		if (oldVersion != currentVersion) {
			[self migrateFromOldVersion:oldVersion];
		}
	}
	[self markAsLoaded];
}

- (void)markAsLoaded
{
	[_defaults setObject:[NSNumber numberWithInt:[self version]] forKey:[self stringForFirstLoadCheck]];
#ifndef DEBUG_MODE	
	[self synchronize];
#endif
}

- (BOOL)checkIfDataAvailable
{
	return ([_defaults objectForKey:[self stringForFirstLoadCheck]]) != nil;
}


- (BOOL)isSetterProperty:(SEL)selector
{
	// a setter selector is similar as 'set_____:'
	// simple check if last character is equal to ':'
	const char* selectorName = sel_getName(selector);
	int lastIndex = strlen(selectorName) - 1;
	return selectorName[lastIndex] == ':';
}

#pragma mark -
#pragma mark method forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{	
	
	NSString* selName = [NSString stringWithFormat:@"%s",sel_getName(selector)];
	for (PLSettingProperty* property in _gPropertiesList) {
		if([property.getter isEqualToString:selName]){
			return [property signatureForGetter];
		}else if([property.setter isEqualToString:selName])  {
			return [property signatureForSetter];
		}
	}
	return nil;
	
	// or by using [self MethodSignature-> SEL]
}

- (void)forwardInvocation:(NSInvocation *)invocation{
	SEL selector = [invocation selector];
	NSString* selName = [NSString stringWithFormat:@"%s",sel_getName(selector)];	
	// maybe here can set a global variable to mark specify PLSettingProperty that being processed
	BOOL isForward = NO;
	for (PLSettingProperty* property in _gPropertiesList) {
		if([property.getter isEqualToString:selName]){
			SEL selectors[4] = {
				@selector(getIntValueFor:),
				@selector(getFloatValueFor:),
				@selector(getBOOLValueFor:),
				@selector(getObjectValueFor:)
			};
			[invocation setSelector:selectors[property.type]];
			//argus goes with (id , SEL, custom argu)
//			[invocation setArgument:&selector atIndex:2];
			[invocation setArgument:&selName atIndex:2];
			isForward = YES;
		}else if([property.setter isEqualToString:selName])  {
//			SEL selectors[4] = {
//				@selector(setValueFor:intValue:),
//				@selector(setValueFor:floatValue:),
//				@selector(setValueFor:boolValue:),
//				@selector(setValueFor:objectValue:)
//			};
			
//			[invocation setArgument:&selector atIndex:2];
//			[invocation setSelector:selectors[property.type]];
//			if(property.type == PLSettingTypeObject){
//				id argus;
//				[invocation getArgument:&argus atIndex:2];
//				[invocation setSelector:selectors[property.type]];
//				[invocation setArgument:&selector atIndex:2];
//				[invocation setArgument:argus atIndex:3];
//			}else {
//				
//			}
			SEL selectors[4] = {
				@selector(setIntValue:setter:),
				@selector(setFloatValue:setter:),
				@selector(setBoolValue:setter:),
				@selector(setObjectValue:setter:)
			};
			[invocation setSelector:selectors[property.type]];
			//argument at index 2 is defulat argument passed through default selector
			[invocation setArgument:&selName atIndex:3];
			isForward = YES;
		}
	}
	
	if(isForward){
		[invocation setTarget:self];
		[invocation invoke];
	}		
	else
		[super forwardInvocation:invocation];

}


////////////////////////////////////////////////////////////////////////////////
// setter forward methods

/*
- (void)setValueFor:(NSString*)setter intValue:(int)value{
	
}

- (void)setValueFor:(NSString*)setter floatValue:(float)value{
	
}

- (void)setValueFor:(NSString*)setter boolValue:(BOOL)value{
	
}

- (void)setValueFor:(NSString*)setter objectValue:(id)value{
	
}
*/
- (PLSettingProperty*)propertyForSetter:(NSString*)setter{
	for (PLSettingProperty* property in _gPropertiesList) {
		if ([property.setter isEqualToString:setter]) {
			return property;
		}
	}
	return nil;
}

- (PLSettingProperty*)propertyForGetter:(NSString*)getter{
	for (PLSettingProperty* property in _gPropertiesList) {
		if ([property.getter isEqualToString:getter]) {
			return property;
		}
	}
	return nil;	
}


// new version , so need't to fetch defaults arguments and reorder it.
- (void)setIntValue:(int)value setter:(NSString*)setter{
	PLSettingProperty* property = [self propertyForSetter:setter];
	[_defaults setInteger:value forKey:property.key];
}
- (void)setFloatValue:(float)value setter:(NSString*)setter{
	PLSettingProperty* property = [self propertyForSetter:setter];
	[_defaults setFloat:value forKey:property.key];
}
- (void)setBoolValue:(BOOL)value setter:(NSString*)setter{
	PLSettingProperty* property = [self propertyForSetter:setter];
	[_defaults setBool:value forKey:property.key];
}
- (void)setObjectValue:(id)value setter:(NSString*)setter{
	PLSettingProperty* property = [self propertyForSetter:setter];
	[_defaults setObject:value forKey:property.key];
}


////////////////////////////////////////////////////////////////////////////////
// getter forward methods

- (int)getIntValueFor:(NSString*)getter{
	PLSettingProperty* property = [self propertyForGetter:getter];	
	return [_defaults integerForKey:property.key];
}

- (float)getFloatValueFor:(NSString*)getter{
	PLSettingProperty* property = [self propertyForGetter:getter];	
	return [_defaults floatForKey:property.key];
}

- (BOOL)getBOOLValueFor:(NSString*)getter{
	PLSettingProperty* property = [self propertyForGetter:getter];	
	return [_defaults boolForKey:property.key];
}

- (id)getObjectValueFor:(NSString*)getter{
	PLSettingProperty* property = [self propertyForGetter:getter];	
	return [_defaults objectForKey:property.key];
}

@end


