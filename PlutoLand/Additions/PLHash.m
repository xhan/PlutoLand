//
//  PLHash.m
//  QiuBai
//
//  Created by xu xhan on 12/15/11.
//  Copyright (c) 2011 Less Everything. All rights reserved.
//

#import "PLHash.h"

@interface PLHash(/*Private*/)
- (void)_cleanItemsInNeed;
@end

@implementation PLHash
@synthesize maxItems = _maxItems;


- (int) count
{
    return (int)[_keySequence count];
}

- (void)setMaxItems:(int)maxItems
{
    _maxItems = maxItems;
    [self _cleanItemsInNeed];
}

- (id)keyAtIndex:(int)index
{
    return [_keySequence objectAtIndex:index];
}

- (id)objectAtIndex:(int)index
{
    return [self objectForKey:[self keyAtIndex:index]];
}

- (id)objectForKey:(id)aKey
{
    return [_dict objectForKey:aKey];    
}
 
- (NSArray *)allKeys
{
    return [_dict allKeys];
}
- (NSArray *)allValues
{
    return [_dict allValues];
}
#pragma mark - origin methods

- (void)setObject:(id)anObject forKey:(id)aKey
{
    [_dict setObject:anObject forKey:aKey];
    // incase modify key's value : update key's position to tail
    if ([_keySequence indexOfObject:aKey]!=NSNotFound) {
        [_keySequence removeObject:aKey];
    }
    [_keySequence addObject:aKey];
    [self _cleanItemsInNeed];
}

- (void)removeObjectForKey:(id)aKey
{    
    [_dict removeObjectForKey:aKey];
    [_keySequence removeObject:aKey];
}

- (void)removeAllObjects
{
    [_dict removeAllObjects];
    [_keySequence removeAllObjects];
}

- (void)dealloc
{
    PLSafeRelease(_keySequence);
    [super dealloc];
}

- (void)_cleanItemsInNeed
{
    if (_maxItems !=0) {
        while ([_keySequence count] > _maxItems) {
            id key = [_keySequence objectAtIndex:0];
            [self removeObjectForKey:key];
        }
    }
}


+ (id)hashFromPath:(NSString*)path
{
    id hash = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (hash) {
        return hash;
    }else {
        return [self hash];
    }
}

+ (id)hash
{
    return [[[self alloc] init] autorelease];
}
- (id)init
{
    self = [super init];
    _dict = [[NSMutableDictionary alloc] init];
    _keySequence = [[NSMutableArray alloc] init];
    return self;
}
- (void)writeHashToFile:(NSString*)path
{
    BOOL r = [NSKeyedArchiver archiveRootObject:self toFile:path];
    PLOG(@"saving historyList result %d",r);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _keySequence = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:@"indexes"]];
    _dict =  [[NSMutableDictionary alloc] initWithDictionary:[aDecoder decodeObjectForKey:@"hash"]];
    _maxItems = [aDecoder decodeInt32ForKey:@"max"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_keySequence forKey:@"indexes"];
    [aCoder encodeInt:_maxItems forKey:@"max"];
    [aCoder encodeObject:_dict forKey:@"hash"];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<PLHash:%0x>%@",self,_dict];
}

#ifdef DEBUG
+ (void)_runTests
{
    PLHash* hash = [PLHash hash];
    
    [hash setObject:@"obj1" forKey:NUM(0)];
    [hash setObject:@"obj2" forKey:NUM(1)];
    [hash setObject:@"obj3" forKey:NUM(2)];
    [hash setObject:@"obj4" forKey:NUM(3)];
    [hash setObject:@"obj5" forKey:NUM(4)];
    [hash setMaxItems:3];
    NSLog(@"%@",hash);
    
    NSAssert([[hash allKeys] count] == 3, @"size should be 3 -1");
    
    NSString*path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"plhash.md"];
    NSLog(@"%@",path);
    [hash writeHashToFile:path];

    
    NSLog(@"-- read from disk");
    hash = [PLHash hashFromPath:path];
    NSLog(@"%@",hash);
    NSAssert([hash count]==3 && hash.maxItems==3, @"size should be 3 -2");
    [hash setObject:@"obj6" forKey:NUM(3)];
    NSAssert([hash count]==3 && hash.maxItems==3, @"size should be 3 -3");
    for (int i = 0; i<3; i++) {
        NSLog(@"%@ => %@",[hash keyAtIndex:i],[hash objectAtIndex:i]);
    }
    
}
#endif
@end
