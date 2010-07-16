//
//  ImageLoaderSpecial.h
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <UIKit/UIKit.h>

//TODO: need to handle memory waring and remove the whole queue(cancel)


/*
 by using PLImageLoader module to load images on tableViewCell async**
 
 How to load images Lazily as apple's demo 'LazyTableImages' do?
 # remove [image fetchUrl] at the cell configure method (cellForRowAtIndexPath)
 # add UIScrollView delegate method
	## didEndDragging:willDecelerate
	## didEndDecelerating:
 # and inside the methods -fetch images for on screen cells
 
 --[tableView indexPathForVisibleRows]
 */



@interface ImageLoaderSpecial : UITableViewController {
	NSOperationQueue *queue;
	NSMutableArray* entries;
}

@property (nonatomic, copy) NSMutableArray *entries;
@property (nonatomic, retain) NSOperationQueue *queue;

@end


