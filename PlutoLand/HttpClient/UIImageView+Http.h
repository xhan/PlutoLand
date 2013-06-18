//
//  UIImageView+Http.h
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImageView(Http)


//TODO: add force reload(ignore and remove cache) args?


/*
 @Q:why need freshOnSucceed option ?
 @A:in some special condition such as loading images from a tableViewCell, bcz its reuseable speciality ,
 its better to setValue to false and add a observer to handle load image succeed event . and than update
 the cell's image manually.
 */

- (void)fetchByURL:(NSString*)urlstr userInfo:(NSDictionary*)info freshOnSucceed:(BOOL)isFresh placeHolder:(UIImage*)img cache:(BOOL)cache;

- (void)fetchByURL:(NSString*)urlstr userInfo:(NSDictionary*)info freshOnSucceed:(BOOL)isFresh placeHolder:(UIImage*)img;

- (void)fetchByURL:(NSString*)urlstr;

- (void)fetchByURL:(NSString*)urlstr placeHolder:(UIImage*)img;


- (BOOL)cleanFetchURL:(NSString*)url;
@end
