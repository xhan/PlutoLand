//
//  PLOG.m
//  Apollo
//
//  Created by xhan on 10-8-30.
//  Copyright 2010 ixHan.com. All rights reserved.
//

#import "PLOG.h"

const int PLOG_ENV_GLOBAL = 871015;

@implementation PLLOG

static NSMutableDictionary* _gDictionary;
static unsigned int _gFormatSetting;
static BOOL  _gEnabled;
static PLOG_STYLE _gStyle;

+ (void)initialize
{
	_gDictionary = [[NSMutableDictionary alloc] init];
	_gFormatSetting = ~0; // default outputs everything
	_gEnabled = YES;
	_gStyle = PLOG_STYLE_MIDDLE;
	[self addEnv:0 name:@"Info"];
	[self addEnv:1 name:@"Warning"];
	[self addEnv:2 name:@"Error"];
    [self addEnv:PLOG_ENV_NETWORK name:@"Net"];
}

+ (void)configForEnv:(PLOG_ENV)env key:(PLOG_FORMAT)key enable:(BOOL)isEnable
{
	return [self configFormatkey:key enable:isEnable];
}

+ (void)configFormatkey:(PLOG_FORMAT)key enable:(BOOL)isEnable
{
	
}

+ (void)configFormatByKeys:(unsigned int)keys
{
	_gFormatSetting = keys;
}

+ (void)setLogStyle:(PLOG_STYLE)style
{
	_gStyle = style;
}

+ (void)logForEnv:(PLOG_ENV)env file:(const char*)fileName line:(int)line method:(const char*)method message:(NSString *)format,...
{
	if (!_gEnabled) return;
	
	NSMutableDictionary* dic = [_gDictionary objectForKey:[NSNumber numberWithUnsignedInt:env]];
	NSAssert1(dic != nil ,@"PLOG env %d not exists",env);	
	
	BOOL enabled = [[dic objectForKey:@"enabled"] boolValue];	
	if (enabled) {
		//NSLog() or printf()
		NSString* file=[[NSString alloc] initWithBytes:fileName 
												length:strlen(fileName) 
											  encoding:NSUTF8StringEncoding];
		
		va_list ap;
		va_start(ap,format);
		NSString* message = [[NSString alloc] initWithFormat:format arguments:ap];
		va_end(ap);
		

		NSString* logStr = nil;
		if (_gStyle == PLOG_STYLE_SHORT) {
			logStr = [NSString stringWithFormat:@"[%@] %@",[dic objectForKey:@"name"],message];
		}else if (_gStyle == PLOG_STYLE_MIDDLE) {
			logStr = [NSString stringWithFormat:@"[%@] %@\n  %s",[dic objectForKey:@"name"],message,method];
		}else if (_gStyle == PLOG_STYLE_FULL) {
			logStr = [NSString stringWithFormat:@"[%@]%s:%d %s %@",[dic objectForKey:@"name"], [[file lastPathComponent] UTF8String],  line , method, message];			
		}
		
		[file release];
		[message release];
		printf("%s\n",[logStr UTF8String]);
		
	}
}



+ (void)setLog:(PLOG_ENV)env State:(BOOL)enable
{
	if (env == PLOG_ENV_GLOBAL) {
		_gEnabled = enable;
		return;
	}
	
	NSMutableDictionary* dic = [_gDictionary objectForKey:[NSNumber numberWithUnsignedInt:env]];
	NSAssert1(dic != nil ,@"PLOG env %d not exists",env);
	
	[dic setObject:[NSNumber numberWithBool:enable] forKey:@"enabled"];
}

+ (void)addEnv:(PLOG_ENV)env name:(NSString*)name
{
	NSNumber* key = [NSNumber numberWithUnsignedInt:env];
	NSNumber* enabled = [NSNumber numberWithBool:YES];
	NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjects:
								[NSArray arrayWithObjects:name,enabled,nil] 
																  forKeys:
								[NSArray arrayWithObjects:@"name",@"enabled",nil]];
	[_gDictionary setObject:dic forKey:key];
}

@end
