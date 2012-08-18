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


#ifdef DEBUG

#define PLOGENV(_env_, _s_, ...) \
[PLLOG logForEnv:_env_ file:__FILE__ line:__LINE__ \
method:__PRETTY_FUNCTION__ message:_s_, ##__VA_ARGS__] 

#define PLLOG_CONFIG PLLOG

#define PLOG(_s_,...) PLOGENV(0, _s_, ##__VA_ARGS__)


#define PLOGFILE_ENV(logger,_env_, _s_, ...) \
[logger logForEnv:_env_ file:__FILE__ line:__LINE__ \
method:__PRETTY_FUNCTION__ message:_s_, ##__VA_ARGS__]

#define PLOGFILE(logger, _s_,...) PLOGFILE_ENV(logger,0,_s_,##__VA_ARGS__)

#define PLOGF( _s_,...) PLOGFILE_ENV([PLLOG_File defaultLogger],0,_s_,##__VA_ARGS__)

#else

#define PLOGENV(_env_,_s_,...) ((void)0)
#define PLLOG_CONFIG ((id)nil)

#define PLOG(_s_,...) ((void)0)

#define PLOGFILE_ENV(logger,_env_, _s_, ...) ((void)0)
#define PLOGFILE(logger, _s_,...)  ((void)0)
#define PLOGF( _s_,...) ((void)0)

#endif




#define PLOG_OBJ(obj) PLOG(@"%@",obj)

#define PLOG_IF(case,_s_,...) ((case) ? PLOG(_s_,##__VA_ARGS__) : ((void)0) )

#define PLOG_Point(point) PLOG(@"(%.1f,%.1f)",point.x,point.y)

#define PLOG_Rect(rect) PLOG(@"{%.1f,%.1f, w:%.1f,h:%.1f}",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height)

#define PLOGWARNING(_s_,...) PLOGENV(1, _s_, ##__VA_ARGS__)

#define PLOGERROR(_s_,...) PLOGENV(2, _s_, ##__VA_ARGS__)




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
	PLOG_ENV_ERROR = 2,
    PLOG_ENV_NETWORK = 3
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

//TODO: add time to end of log

@interface PLLOG_File : PLLOG
   //assign, manage logger's life cycle yourself
+ (void)setDefaultLogger:(PLLOG_File*)logger;
+ (PLLOG_File*)createDefaultLogger:(NSString*)path;

+ (PLLOG_File*)defaultLogger;
+ (id)fileLog:(NSString*)path;

- (id)fileLog:(NSString*)path;
- (void)setConsoleVisible:(BOOL)value; // default is YES, also print logs to console
- (void)logForEnv:(PLOG_ENV)env file:(const char*)fileName line:(int)line method:(const char*)method message:(NSString *)format, ...;
@end
