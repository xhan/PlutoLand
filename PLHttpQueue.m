//
//  PLHttpQueue.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "PLHttpQueue.h"

#define DEFAULT_CAPACITY 1000
#define DEFAULT_PARELLEL_CAPACITY 5
#define DEFAULT_ACTIVE_STATE YES
#define DEFAULT_SHOW_ACTIVE_INCIDATER YES

@interface PLHttpQueue(Private)

- (void)runNextAction;
- (void)actionFinished:(id)task;
@end

@implementation PLHttpQueue

@synthesize parellelCapacity = _parellelCapacity;
@synthesize capacity = _capacity;

static NSMutableDictionary* gSharedDictionary;


#pragma mark -
#pragma mark Class Methods
///////////////////////////////////////////////////////////////////////////////////////////////////

+ (void)initialize {    
    if(!gSharedDictionary)
        gSharedDictionary = [[NSMutableDictionary alloc] init];
}

+ (PLHttpQueue*)sharedQueue
{
	NSString *className = NSStringFromClass([self class]);
	PLHttpQueue* queue = [gSharedDictionary objectForKey:className];
	if (!queue) {
		queue = [[[self class] alloc] init];
		[gSharedDictionary setObject:queue forKey:className];
		[queue release];
		return queue;
	}
	return queue;
}

#pragma mark -
#pragma mark Instance Methods
///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
	if (self = [super init]) {
		_capacity = DEFAULT_CAPACITY;
		_parellelCapacity = DEFAULT_PARELLEL_CAPACITY;
		_queues = [[NSMutableArray alloc] init];
		_runningQueues = [[NSMutableArray alloc] init];
		_currentActiveTaskCount = 0;
		_isActived = DEFAULT_ACTIVE_STATE;
		_isShowActiveIndicaterWhileRunning = DEFAULT_SHOW_ACTIVE_INCIDATER;
	}
	return self;
}

- (BOOL)addQueueItem:(id)item
{
	//TODO: check item validation
	[_queues addObject:item];	
	
	[self runNextAction]; // the only condition is that queue is empty 
	
	return YES;
}



//TODO: add more details behavior below , currently \
// queue will paused after tasks on the running queue finished
// acts with runAction method
- (void)pause
{
	if(!_isActived) return;
	_isActived = NO;
}

- (void)start
{
	if(_isActived) return;
	_isActived = YES;	
}

#pragma mark -
#pragma mark Private of Instance Methods
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)runNextAction
{
	if (!_isActived) 		return;

	int idleCount = _parellelCapacity - _currentActiveTaskCount;
	if(idleCount <= 0 ) return;
	id task = nil;
	
	
	//add idle task into running queue and run it's task
	for (int i = 0; (i < idleCount) && [_queues count] ; i++ ) {
		task = [_queues objectAtIndex:0];
		[_runningQueues addObject:task];
		[_queues removeObjectAtIndex:0];
		[task addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
		[task performSelector:@selector(start)];
		_currentActiveTaskCount += 1; 
	}
	
	if (_currentActiveTaskCount >0 && _isShowActiveIndicaterWhileRunning) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
//	NSLog(@"%@",keyPath);
	if ([keyPath isEqualToString:@"isFinished"]) {
		[self actionFinished:object];	
	}
}

- (void)actionFinished:(id)task
{
	NSInteger index = [_runningQueues indexOfObject:task];
//	if(index == NSNotFound) return;
	//else
	[task removeObserver:self forKeyPath:@"isFinished"];
	[_runningQueues removeObjectAtIndex:index];
	_currentActiveTaskCount -= 1; 
	/* run next action or nothing */
	[self runNextAction];
	
	if (_isShowActiveIndicaterWhileRunning) {
		NSAssert(_currentActiveTaskCount>=0,@"task count should GE 0");
		_currentActiveTaskCount = MAX(0,_currentActiveTaskCount);
		if (_currentActiveTaskCount == 0) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
	}
}

@end


