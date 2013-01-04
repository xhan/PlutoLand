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
    if (self.class != PLLOG.class) return;
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
	
	NSMutableDictionary* dic = _gDictionary[@(env)];
	NSAssert1(dic != nil ,@"PLOG env %d not exists",env);	
	
	BOOL enabled = [dic[@"enabled"] boolValue];	
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
			logStr = [NSString stringWithFormat:@"[%@] %@",dic[@"name"],message];
		}else if (_gStyle == PLOG_STYLE_MIDDLE) {
			logStr = [NSString stringWithFormat:@"[%@] %@\n  %s",dic[@"name"],message,method];
		}else if (_gStyle == PLOG_STYLE_FULL) {
			logStr = [NSString stringWithFormat:@"[%@]%s:%d %s %@",dic[@"name"], [[file lastPathComponent] UTF8String],  line , method, message];			
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
	
	NSMutableDictionary* dic = _gDictionary[@(env)];
	NSAssert1(dic != nil ,@"PLOG env %d not exists",env);
	
	dic[@"enabled"] = @(enable);
}

+ (void)addEnv:(PLOG_ENV)env name:(NSString*)name
{
	NSNumber* key = @(env);
	NSNumber* enabled = @(YES);
	NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjects:
								@[name,enabled] 
																  forKeys:
								@[@"name",@"enabled"]];
	_gDictionary[key] = dic;
}

@end



static PLLOG_File* _defaultFileLogger;
@implementation PLLOG_File
{
    NSFileHandle* fileHandler;
    BOOL isConsoleVisible;
}

+ (PLLOG_File*)createDefaultLogger:(NSString*)path
{
    PLLOG_File*logger = [self fileLog:path];
    [self setDefaultLogger:logger];
    return logger;
}

+ (void)setDefaultLogger:(PLLOG_File*)logger
{
    _defaultFileLogger = logger;
}
+ (PLLOG_File*)defaultLogger
{
    return _defaultFileLogger;
}

- (id)fileLog:(NSString *)path
{
    self = [super init];
    isConsoleVisible = YES;
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    fileHandler = [[NSFileHandle fileHandleForWritingAtPath:path] retain];
    [fileHandler seekToEndOfFile];
    if (fileHandler) {
        return self;
    }else{
        PLOGERROR(@"Can't created file handle on path %@",path);
        [self release];
        return nil;
    }
    
}
- (void)setConsoleVisible:(BOOL)value
{
    isConsoleVisible = value;
}

- (void)dealloc
{
    [fileHandler closeFile];
    PLSafeRelease(fileHandler);
    [super dealloc];
}

+ (id)fileLog:(NSString*)path
{
    PLLOG_File* logger = [[self alloc] fileLog:path];
    return [logger autorelease];
}

- (void)logForEnv:(PLOG_ENV)env file:(const char*)fileName line:(int)line method:(const char*)method message:(NSString *)format, ...
{
    if (!_gEnabled) return;
	
	NSMutableDictionary* dic = _gDictionary[@(env)];
	NSAssert1(dic != nil ,@"PLOG env %d not exists",env);
	
	BOOL enabled = [dic[@"enabled"] boolValue];
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
			logStr = [NSString stringWithFormat:@"[%@] %@",dic[@"name"],message];
		}else if (_gStyle == PLOG_STYLE_MIDDLE) {
			logStr = [NSString stringWithFormat:@"[%@] %@\n  %s",dic[@"name"],message,method];
		}else if (_gStyle == PLOG_STYLE_FULL) {
			logStr = [NSString stringWithFormat:@"[%@]%s:%d %s %@\n",dic[@"name"], [[file lastPathComponent] UTF8String],  line , method, message];
		}
		
		[file release];
		[message release];
        
        if (isConsoleVisible) {
            printf("%s",[logStr UTF8String]);
        }
		
		[fileHandler writeData: [logStr dataUsingEncoding:NSUTF8StringEncoding]];
	}
}


@end

