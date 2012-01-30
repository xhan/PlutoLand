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
#define kSettingInitCountKey @"PLSettingInitCount"
#pragma mark -
#pragma mark PLSettingProperty

@interface PLSettingProperty : NSObject
{
	NSString* _getter;
	NSString* _setter;
	NSString* _key;
    BOOL _archiveToData;
    BOOL _isNeedTransform;
    Class _transformClass;
	PLSettingType _type;
}

@property (nonatomic, assign) PLSettingType type;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *setter;
@property (nonatomic, copy) NSString *getter;
// archive object into data structure
@property (nonatomic, assign) BOOL archiveToData;
@property (nonatomic, assign) BOOL isNeedTransform;

+ (id)propertyByName:(NSString*)name key:(NSString*)key type:(PLSettingType)type archive2Data:(BOOL)archived;
- (id)initWithTransformClass:(Class)class;
+ (id)propertyByName:(NSString*)name key:(NSString*)key transformClass:(Class)transformClass;

+ (NSString*)setterNameSEL:(NSString*)sel;
- (NSMethodSignature*)signatureForGetter;
- (NSMethodSignature*)signatureForSetter;

- (id)transformedValue:(id)origin;
- (id)reverseTransformedValue:(id)transformed;
@end

@implementation PLSettingProperty

@synthesize type = _type;
@synthesize getter = _getter;
@synthesize setter = _setter;
@synthesize key = _key;
@synthesize archiveToData = _archiveToData;
@synthesize isNeedTransform = _isNeedTransform;
- (void)dealloc
{
	[_key release];
	[_getter release];
	[_setter release];
	[super dealloc];
}

+ (id)propertyByName:(NSString*)name key:(NSString*)key type:(PLSettingType)type archive2Data:(BOOL)archived
{
	PLSettingProperty* p = [PLSettingProperty new];
	p.getter = name;
	p.setter = [PLSettingProperty setterNameSEL:name];
	p.key = key;
	p.type = type;
    p.archiveToData = archived;
	return [p autorelease];
}

+ (id)propertyByName:(NSString*)name key:(NSString*)key transformClass:(Class)transformClass
{
	PLSettingProperty* p = [[PLSettingProperty alloc] initWithTransformClass:transformClass];
	p.getter = name;
	p.setter = [PLSettingProperty setterNameSEL:name];
	p.key = key;
	p.type = PLSettingTypeObject;
    p.archiveToData = NO;
    p.isNeedTransform = YES;
	return [p autorelease];    
}

- (id)initWithTransformClass:(Class)class
{
    self = [super init];
    _transformClass = class;
    if (![_transformClass conformsToProtocol:@protocol(PLSettingTransformerProtocol)]) {
        [NSException raise:@"Transformer Class have to conforms to Protocol PLSettingTransformerProtocol" format:nil];
    }
    return self;
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

- (id)transformedValue:(id)origin
{
    return [_transformClass transformedValue:origin];
}
- (id)reverseTransformedValue:(id)transformed
{
    return [_transformClass reverseTransformedValue:transformed];
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
@synthesize isDynamicProperties = _isDynamicProperties, isFirstLaunched = _isFirstLaunched;
#pragma mark - methods need be implemented by subclass

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
    
    //TODO: need a better way to handle it
    //Note: have to call this if  isNonDynamicProperties
//    [self _writePropertiesToDefaults];
    
}

#pragma mark - private

+ (void)setupProperty:(NSString*)property forKey:(NSString*)key withType:(PLSettingType)type archive2Data:(BOOL)archived
{
	[_gPropertiesList addObject:[PLSettingProperty propertyByName:property key:key type:type archive2Data:archived]];
}

+ (void)setupProperty:(NSString *)property withType:(PLSettingType)type
{
	[self setupProperty:property forKey:property withType:type archive2Data:NO];
}

+ (void)setupPropertyWithArchivedType:(NSString *)property
{
	[self setupProperty:property forKey:property withType:PLSettingTypeObject archive2Data:YES];
}

+ (void)setupProperty:(NSString *)property withTransformer:(Class)transformer
{
    [_gPropertiesList addObject:[PLSettingProperty propertyByName:property
                                                              key:property
                                                   transformClass:transformer]];
}

+ (void)initialize{
	_gPropertiesList = [[NSMutableArray alloc] init];
	[self setupRoutes];
}



#pragma mark -
#pragma mark public

- (int)initedCount
{
    return (int)[_defaults integerForKey:kSettingInitCountKey];
}

- (void)synchronize
{
    if (!_isDynamicProperties) {
        [self _writePropertiesToDefaults];
    }
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
	_isDynamicProperties = YES;
	[self loadDefaults];
	[_defaults setInteger:self.initedCount+1 forKey:kSettingInitCountKey];
	return self;
}

- (void)dealloc{
	[_defaults release]; _defaults = nil;
	[super dealloc];
}

- (void)setIsDynamicProperties:(BOOL)isDynamicProperties
{
    _isDynamicProperties = isDynamicProperties;
    if (!_isDynamicProperties) {
        if (_isFirstLaunched) {
            //first launch, values already readed from setDefaults
            [self _writePropertiesToDefaults];
        }else{
             [self _readPropertiesFromDefaults];   
        }
    }
}

#pragma mark -
#pragma mark private

- (void)_readPropertiesFromDefaults
{
    for (PLSettingProperty* property in _gPropertiesList){
        
        id value;
        if (property.archiveToData) {
            NSData* data = [_defaults dataForKey:property.key];
            
            value =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else if(property.isNeedTransform){
            id obj = [_defaults objectForKey:property.key];
            value = [property reverseTransformedValue:obj];
        }else{            
            value = [_defaults valueForKey:property.key];
        }
        
        //seems set nil vaue will cause error
        if (value) {
            [self setValue:value forKey:property.getter];
        }
    }
}

- (void)_writePropertiesToDefaults
{
    for (PLSettingProperty* property in _gPropertiesList){
        if (property.archiveToData) {
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:[self valueForKey:property.getter]];
            [_defaults setValue:data forKey:property.key];
        }else if(property.isNeedTransform){
            id obj = [property transformedValue:[self valueForKey:property.getter]];
            [_defaults setValue:obj forKey:property.key];
        }else{
            [_defaults setValue:[self valueForKey:property.getter] forKey:property.key];
        }        
    }    
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSString* selName = [NSString stringWithFormat:@"%s",sel_getName(aSelector)];
	for (PLSettingProperty* property in _gPropertiesList) {
		if([property.getter isEqualToString:selName]){
			return YES;
		}else if([property.setter isEqualToString:selName])  {
			return YES;
		}
	}
	return NO;	
}

- (void)loadDefaults
{
	if (![self checkIfDataAvailable]) {
        _isFirstLaunched = YES;
		[self setupDefaults];		
	}else {
		//[self versionCheck];
        _isFirstLaunched = NO;
		NSUInteger oldVersion = [_defaults integerForKey:[self stringForFirstLoadCheck]];
		int currentVersion = [self version];
		if (oldVersion != currentVersion) {
			[self migrateFromOldVersion:(int)oldVersion];
		}
        
	}
	[self markAsLoaded];

}

- (void)markAsLoaded
{
	[_defaults setObject:[NSNumber numberWithInt:[self version]] forKey:[self stringForFirstLoadCheck]];	
	//[self synchronize];
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
	int lastIndex = (int)strlen(selectorName) - 1;
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
    if (property.archiveToData) {
        NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:value];
        [_defaults setObject:theData forKey:property.key];   
    }else{
        [_defaults setObject:value forKey:property.key];   
    }
	
}


////////////////////////////////////////////////////////////////////////////////
// getter forward methods

- (int)getIntValueFor:(NSString*)getter{
	PLSettingProperty* property = [self propertyForGetter:getter];	
	return (int)[_defaults integerForKey:property.key];
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
    
	if (property.archiveToData) {
        NSData* data = [_defaults dataForKey:property.key];
        if (data) {
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else
            return nil;
    }
	return [_defaults objectForKey:property.key];
}

@end


