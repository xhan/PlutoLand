//
//  NSDictionary+NonNull.h
//  Secret
//
//  Created by xu xhan on 7/5/11.
//  Copyright 2011 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionary_NonNull)

- (id)objectForKeyPL:(id)aKey;
@end

@interface NSArray (NonNull)
- (id)objectAtIndexPL:(NSUInteger)index;
@end