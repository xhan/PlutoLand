//
//  T.h
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

/*
 an global helper class, all the methods inside should be class method.
 */


#import <Foundation/Foundation.h>



@interface T : NSObject 

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIButton

+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img highlightImg:(UIImage*)himg target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector; 

@end
