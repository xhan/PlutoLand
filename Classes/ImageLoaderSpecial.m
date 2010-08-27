//
//  ImageLoaderSpecial.m
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "ImageLoaderSpecial.h"
#import "UIImageView+Http.h"
#import "AppRecord.h"
#import "ParseOperation.h"
#import "PLHttpClient.h"
#import "PLImageLoader.h"

#define USING_FETCH_METHOD_COMMON



static NSString *const TopPaidAppsFeed =
@"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";

@interface ImageLoaderSpecial(private)<ParseOperationDelegate>

@end

@implementation ImageLoaderSpecial

@synthesize entries;
@synthesize queue;



#pragma mark -
#pragma mark NSNotificationCenter observer fro ImageLoader 

- (void)onGetNotificationImageSucceeded:(NSNotification*)notify
{
	NSLog(@"notified me");
	NSDictionary* info = [notify userInfo];
	NSIndexPath* indexpath = [info objectForKey:@"indexPath"];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] 
						  withRowAnimation:UITableViewRowAnimationNone];	
}



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSLog(@"loading top list ...");	
	NSData* appListData = [PLHttpClient simpleSyncGet:TopPaidAppsFeed];
	
	NSLog(@"- top list loaded");
	self.title = @"Top Paied Apps";
	
	ParseOperation *parser = [[ParseOperation alloc] initWithData:appListData delegate:self];	
	queue = [[NSOperationQueue alloc] init];
	[queue addOperation:parser];
	[parser release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.entries = [NSMutableArray array];
	self.title = @"loading top list";
	self.tableView.rowHeight = 60;
#ifndef USING_FETCH_METHOD_COMMON	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetNotificationImageSucceeded:) name:NOTICE_IMAGE_LOADER_SUCCEEDED object:nil];
#endif
	
}


- (void)handleLoadedApps:(NSArray *)loadedApps
{
	//NSLog(@"finished load :%d",[loadedApps count]);	
	self.entries = [NSMutableArray arrayWithArray:loadedApps];
	images = [[NSMutableArray arrayWithCapacity:[loadedApps count]] retain];	
	for(int i =0; i< [loadedApps count]; i++)  [images addObject:[NSNull null]];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark ParseOperation delegate

- (void)didFinishParsing:(NSArray *)appList
{
    [self performSelectorOnMainThread:@selector(handleLoadedApps:) withObject:appList waitUntilDone:NO];
    
    self.queue = nil;   // we are finished with the queue and our ParseOperation
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [entries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
	cell.textLabel.text = appRecord.appName;
	cell.detailTextLabel.text = appRecord.artist;
	
#ifdef USING_FETCH_METHOD_COMMON
	
//	NSLog(@"%d",[images count]);
//	id obj = [images objectAtIndex:indexPath.row];
//	NSLog(@"%@ class:%@",obj,NSStringFromClass(obj));
	if ([images objectAtIndex:indexPath.row] != [NSNull null]) {
		cell.imageView.image = [images objectAtIndex:indexPath.row]; 
	}else {
		NSDictionary* dic = [NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"];	
		[PLImageLoader fetchURL:appRecord.imageURLString object:self userInfo:dic];
		cell.imageView.image = [UIImage imageNamed:@"placeHolder.png"];
	}

#else
	cell.imageView.image = [UIImage imageNamed:@"placeHolder.png"];
	NSDictionary* dic = [NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"];	
	[cell.imageView fetchByURL:appRecord.imageURLString userInfo:dic freshOnSucceed:NO];
#endif
    return cell;
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning");
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)dealloc {
    [entries release], entries = nil;
    [queue release], queue = nil;
    [super dealloc];
}


#pragma mark - ImageLoader delegate

- (void)fetchedSuccessed:(UIImage*)image userInfo:(NSDictionary*)info
{
//	NSDictionary* info = [notify userInfo];
	NSIndexPath* indexpath = [info objectForKey:@"indexPath"];
	[images replaceObjectAtIndex:indexpath.row withObject:image];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] 
						  withRowAnimation:UITableViewRowAnimationNone];		
}

@end

