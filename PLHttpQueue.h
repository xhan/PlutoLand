//
//  PLHttpQueue.h
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 as a queue instance of PLHttpQueue, the instance mush 
 implement method 'start' and has a property named 'isFinished'
 */

//TODO: add activeIndicater on the status bar

@interface PLHttpQueue : NSObject {
	int _capacity;
	int _parellelCapacity;
	NSMutableArray* _queues;
	NSMutableArray* _runningQueues;	
	int _currentActiveTaskCount;
	
	BOOL _isActived; // response to start && pause
	
}

@property (nonatomic, assign) int parellelCapacity;
@property (nonatomic, assign) int capacity;

+ (PLHttpQueue*)sharedQueue;

- (BOOL)addQueueItem:(id)item;

- (void)pause;
- (void)start;

@end

