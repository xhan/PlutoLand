//
//  PLHash.h
//  PLHash is a Class  that support index methods on NSDictionary Class
//  .PS the reason that not directly inherited from NSDictionary because it's a cluster class
//  QiuBai
//
//  Created by xu xhan on 12/15/11.
//  Copyright (c) 2011 Less Everything. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLHash : NSObject<NSCoding>
{
    NSMutableArray* _keySequence;
    NSMutableDictionary* _dict;
    int _maxItems;
    BOOL _isValueDirty; 
}

/* Once items count exceed maxItems , it would remove old items to fit maxItems */
@property(nonatomic,assign) int maxItems;   //default 0 means infinit counts
@property(nonatomic,readonly) int count;

- (id)keyAtIndex:(int)index;
- (id)objectAtIndex:(int)index;

- (void)removeObjectForKey:(id)aKey;
- (void)removeAllObjects;

- (void)setObject:(id)anObject forKey:(id)aKey; 
- (id)objectForKey:(id)aKey;


- (NSArray *)allKeys;
- (NSArray *)allValues;
- (NSArray *)allValuesInOrder;
- (NSArray *)allValuesInOrderDESC;

+ (id)hash;
+ (id)hashFromPath:(NSString*)path;

+ (id)hashFromFile:(NSString*)filePath orNew:(int)maxItems;


- (BOOL)writeHashToFile:(NSString*)path;
@property(nonatomic,copy) NSString* saveFilePath;
- (BOOL)save; // save to disk

#ifdef DEBUG
//    Class a = NSClassFromString(@"PLHash");
//    [a runTests];
+ (void)_runTests;
#endif

@end
