//
//  NSString+Addition.m
//  Apollo
//
//  Created by xhan on 10-9-19.
//  Copyright 2010 ixHan.com. All rights reserved.
//

#import "NSString+Addition.h"
#import "PLGlobal.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Base64.h"
@implementation NSString(Addition)

- (BOOL)isEmpty{
	return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

- (BOOL)isNonEmpty
{
    return !self.isEmpty;
}

- (int)countWithoutSpace
{
    return (int)[[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
}

- (NSString *)striped
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)isEqual:(NSString*)a toB:(NSString*)b
{
	if (a == nil) {
		return b == nil;
	}else {
		return [a isEqualToString:b];
	}

}

+ (NSString*)localizedFileSize:(long long)fileSizeBytes
{
	int gb = (int)(fileSizeBytes / GByte);
	int mb = (int)(fileSizeBytes % GByte / MByte);
	int kb = (int)(fileSizeBytes % MByte/ KByte);
	if (gb > 0) {
		return [NSString stringWithFormat:@"%d GB %d MB",gb,mb];
	}
	if (mb > 0) {
		return [NSString stringWithFormat:@"%d%.2f MB",mb,((float)kb)/KByte];
	}
	return [NSString stringWithFormat:@"%d KB",kb];

}

- (NSString*)firstString:(int)maxLength
{
	if (maxLength > [self length]) {
		return self;
	}else {
		return [self substringToIndex:maxLength];
	}

}


- (NSString*)firstString:(int)maxLength atIndex:(NSUInteger)index
{
	NSUInteger length = self.length;
	if (index >= length) {
		return nil;
	}
	if (index + maxLength > length) {
		maxLength = (int)(length - index);
	}
	
	return [self substringWithRange:NSMakeRange(index, maxLength)];
}

- (NSString *) md5 
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

- (NSString *)stripFreeLines
{
    NSArray* ary = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray* rst = [NSMutableArray arrayWithCapacity:ary.count];
    for (NSString* s in ary) {
        if ([s isNonEmpty]) {
            [rst addObject:s];
        }
    }
//    PLOG(@"striped lines %d",ary.count - rst.count);
    return [rst componentsJoinedByString:@"\n"];
}


- (NSData*)xorWithKey:(NSString*)key
{
    const char* orig = [self UTF8String];
    const char* keys = [key UTF8String];

    int length = strlen(orig);
    int lengthKey = strlen(keys);

    char *rets = malloc(length*sizeof(char));
    for (int i =0; i<length+lengthKey; i+=lengthKey) {
        for (int j=0; j<lengthKey; j++) {
            if (i+j<length) {
                rets[i+j] = orig[i+j] ^ keys[j];
            }
        }
    }
    
    NSData*data = [NSData dataWithBytes:rets length:length];
    free(rets);
    return data;
}

+ (NSString*)xorFromData:(NSData*)raw key:(NSString*)key
{
    const char *orig = [raw bytes];
    const char* keys = [key UTF8String];
    
    int length = raw.length;
    int lengthKey = strlen(keys);
    char *rets = malloc((length+1)*sizeof(char));
    
    for (int i =0; i<length+lengthKey; i+=lengthKey) {
        for (int j=0; j<lengthKey; j++) {
            if (i+j<length) {
                rets[i+j] = keys[j] ^ orig[i+j] ;
            }
        }
    }
    rets[length] = '\0';
    
    NSString*strings = [[NSString alloc] initWithBytes:rets length:length encoding:NSUTF8StringEncoding];
    free(rets);
    return [strings autorelease];
}


- (NSString*)xorEncodeWithKey:(NSString*)key
{
    NSData*data = [self xorWithKey:key];
    return [data base64EncodedString];
}
- (NSString*)xorDecodeWithKey:(NSString*)key
{
    NSData*data = [NSData dataFromBase64String:self];
    return [[self class] xorFromData:data key:key];
}

- (BOOL)contains:(NSString*)string
{
    NSRange rng = [self rangeOfString:string options:0];
    return rng.location != NSNotFound;
}

@end


@implementation NSString (URLEscaped)
- (NSString *)URLEscaped {
	CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`", kCFStringEncodingUTF8);
	NSString *out = [NSString stringWithString:(NSString *)escaped];
	CFRelease(escaped);
	return [[out copy] autorelease];
}
- (NSString *)unURLEscape {
	CFStringRef unescaped = CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)self, (CFStringRef)@"");
	NSString *out = [NSString stringWithString:(NSString *)unescaped];
	CFRelease(unescaped);
	return [[out copy] autorelease];
}
@end