//
//  PLOG.h
//  Apollo
//
//  Created by xhan on 10-8-30.
//  Copyright 2010 ixHan.com. All rights reserved.
//

/*
 some codes & ideas borrowed from  http://borkware.com/rants/agentm/mlog/
 */


#import <Foundation/Foundation.h>

#define ENABLE_PLOG
#ifdef ENABLE_PLOG

#define PLOGENV(_env_, _s_, ...) \
[PLLOG logForEnv:_env_ file:__FILE__ line:__LINE__ \
method:__PRETTY_FUNCTION__ message:_s_, ##__VA_ARGS__] 

#else

#define PLOGENV(_env_,_s_,...) ((void)0)

#endif


#define PLOG(_s_,...) PLOGENV(0, _s_, ##__VA_ARGS__)

#define PLOGWARNING(_s_,...) PLOGENV(1, _s_, ##__VA_ARGS__)

#define PLOGERROR(_s_,...) PLOGENV(2, _s_, ##__VA_ARGS__)

//TODO: add debug object, rect, position


typedef enum{
	PLOG_FORMAT_DATE = 1<<0,
	PLOG_FORMAT_TIME = 1<<1,
	PLOG_FORMAT_FILE = 1<<2,
	PLOG_FORMAT_FUNCTION = 1<<3,
	PLOG_FORMAT_LINE = 1<<4,
	PLOG_FORMAT_ENV = 1<<5
}PLOG_FORMAT;

enum {
	PLOG_ENV_INFO = 0,
	PLOG_ENV_WARNING = 1,
	PLOG_ENV_ERROR = 2
};

typedef enum  {
	PLOG_STYLE_SHORT,  // message
	PLOG_STYLE_MIDDLE, //[env] message \n  method
	PLOG_STYLE_FULL	// [env] fileName:line [class method] message
}PLOG_STYLE;

typedef unsigned int PLOG_ENV ;

extern const int PLOG_ENV_GLOBAL; 

@interface PLLOG : NSObject 

//not works at first version
+ (void)configForEnv:(PLOG_ENV)env key:(PLOG_FORMAT)key enable:(BOOL)isEnable;

// not works too.
+ (void)configFormatkey:(PLOG_FORMAT)key enable:(BOOL)isEnable;

//currently date & time not works.
//+ (void)configFormatByKeys:(unsigned int)keys;

+ (void)setLogStyle:(PLOG_STYLE)style;

+ (void)logForEnv:(PLOG_ENV)env file:(const char*)fileName line:(int)line method:(const char*)method message:(NSString *)format, ...; 


+ (void)setLog:(PLOG_ENV)env State:(BOOL)enable;

+ (void)addEnv:(PLOG_ENV)env name:(NSString*)name;

@end
