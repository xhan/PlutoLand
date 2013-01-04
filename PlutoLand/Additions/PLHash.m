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
    return _keySequence[index];
}

- (id)objectAtIndex:(int)index
{
    return [self objectForKey:[self keyAtIndex:index]];
}

- (id)objectForKey:(id)aKey
{
    return _dict[aKey];    
}
 
- (NSArray *)allKeys
{
    return _keySequence;
}
- (NSArray *)allValues
{
    return [_dict allValues];
}

- (NSArray *)allValuesInOrder
{
    return [self allValuesInOrderDESC:NO];
}

- (NSArray *)allValuesInOrderDESC
{
    return [self allValuesInOrderDESC:YES];
}

- (NSArray *)allValuesInOrderDESC:(BOOL)desc
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.count];

    if(!desc){
        for (int i = 0; i < self.count; i++) {
            [array addObject:[self objectAtIndex:i]];
        }
    }else{
        for (int i = self.count -1; i>=0; i--) {
            [array addObject:[self objectAtIndex:i]];
        }
    }
    return [NSArray arrayWithArray:array];
}

#pragma mark - origin methods

- (void)setObject:(id)anObject forKey:(id)aKey
{
    _dict[aKey] = anObject;
    // incase modify key's value : update key's position to tail
    if ([_keySequence indexOfObject:aKey]!=NSNotFound) {
        [_keySequence removeObject:aKey];
    }
    [_keySequence addObject:aKey];
    [self _cleanItemsInNeed];
    _isValueDirty = YES;
}

- (void)removeObjectForKey:(id)aKey
{    
    [_dict removeObjectForKey:aKey];
    [_keySequence removeObject:aKey];
    _isValueDirty = YES;
}

- (void)removeAllObjects
{
    [_dict removeAllObjects];
    [_keySequence removeAllObjects];
    _isValueDirty = YES;
}

- (void)dealloc
{
    PLSafeRelease(_keySequence);
    PLSafeRelease(_dict);
    PLSafeRelease(_saveFilePath);
    [super dealloc];
}

- (void)_cleanItemsInNeed
{
    if (_maxItems !=0) {
        while ([_keySequence count] > _maxItems) {
            id key = _keySequence[0];
            [self removeObjectForKey:key];
        }
    }
}


+ (id)hashFromPath:(NSString*)path
{
    PLHash* hash = nil;
    @try {
        hash = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    @catch (NSException *exception) {
        
    }
    if (hash) {
        hash.saveFilePath = path;
    }
    PLOG_IF(!path,@"hash not founded in path %@",path);
    return hash;
}

+ (id)hashFromFile:(NSString*)filePath orNew:(int)maxItems
{
    PLHash* hash = [self hashFromPath:filePath];
    if (!hash) {
        hash = [self hash];
        hash.maxItems = maxItems;
        hash.saveFilePath = filePath;
    }
    return hash;
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
- (BOOL)writeHashToFile:(NSString*)path
{
    
    if (!_isValueDirty) {
        return YES;
    }
    
    // BOOL r __attribute__((unused))
    BOOL ret = NO;
    @try {
        ret = [NSKeyedArchiver archiveRootObject:self toFile:path];
    }
    @catch (NSException *exception) {
        PLOGERROR(@"save error %@",exception);
    }
    return ret;
}

- (BOOL)save
{
    if ([self.saveFilePath isNonEmpty]) {
        return [self writeHashToFile:self.saveFilePath];
    }else{
        PLOGERROR(@"NO saveFilePath specify! %@",self);
        return NO;
    }
    
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
    return [NSString stringWithFormat:@"<PLHash:%p>%@",self,_dict];
}

#ifdef DEBUG
+ (void)_runTests
{
    PLHash* hash = [PLHash hash];
    
    [hash setObject:@"obj1" forKey:@0];
    [hash setObject:@"obj2" forKey:@1];
    [hash setObject:@"obj3" forKey:@2];
    [hash setObject:@"obj4" forKey:@3];
    [hash setObject:@"obj5" forKey:@4];
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
    [hash setObject:@"obj6" forKey:@3];
    NSAssert([hash count]==3 && hash.maxItems==3, @"size should be 3 -3");
    for (int i = 0; i<3; i++) {
        NSLog(@"%@ => %@",[hash keyAtIndex:i],[hash objectAtIndex:i]);
    }
    
}
#endif
@end
